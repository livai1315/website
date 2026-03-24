// ViewModels.swift
// La Maison Mirage — MVVM Business Logic
// Observable ViewModels for each module

import SwiftUI
import SwiftData

// MARK: - Dashboard ViewModel

@Observable
final class DashboardViewModel {
    var selectedPeriod: Period = .today

    enum Period: String, CaseIterable {
        case today = "Aujourd'hui"
        case week = "Semaine"
        case month = "Mois"
    }

    func revenue(from orders: [Order], period: Period) -> Double {
        let calendar = Calendar.current
        let now = Date.now

        return orders
            .filter { $0.status == .delivered || $0.status == .invoiced }
            .filter { order in
                switch period {
                case .today:
                    return calendar.isDateInToday(order.deliveryDate)
                case .week:
                    return calendar.isDate(order.deliveryDate, equalTo: now, toGranularity: .weekOfYear)
                case .month:
                    return calendar.isDate(order.deliveryDate, equalTo: now, toGranularity: .month)
                }
            }
            .reduce(0) { $0 + $1.totalAmount }
    }
}

// MARK: - Stock ViewModel

@Observable
final class StockViewModel {
    /// Generate a shopping list from all low-stock ingredients
    func generateShoppingList(ingredients: [Ingredient]) -> [(ingredient: Ingredient, quantityNeeded: Double)] {
        ingredients
            .filter { $0.isLowStock }
            .map { ingredient in
                let needed = (ingredient.alertThreshold * 2) - ingredient.currentStock
                return (ingredient: ingredient, quantityNeeded: max(needed, 0))
            }
            .sorted { $0.ingredient.name < $1.ingredient.name }
    }

    /// Record a stock movement (in or out)
    func recordMovement(
        ingredient: Ingredient,
        quantity: Double,
        reason: String,
        context: ModelContext
    ) {
        let movement = StockMovement(
            quantity: quantity,
            reason: reason,
            ingredient: ingredient
        )
        ingredient.currentStock += quantity
        ingredient.movements.append(movement)
        context.insert(movement)
        try? context.save()
    }
}

// MARK: - Order ViewModel

@Observable
final class OrderViewModel {
    private var nextOrderNumber: Int = 1

    /// Generate next order reference: CMD-2026-XXX
    func generateReference() -> String {
        let year = Calendar.current.component(.year, from: .now)
        let ref = String(format: "CMD-%d-%03d", year, nextOrderNumber)
        nextOrderNumber += 1
        return ref
    }

    /// Generate next invoice reference: FAC-2026-XXX
    func generateInvoiceNumber() -> String {
        let year = Calendar.current.component(.year, from: .now)
        return String(format: "FAC-%d-%03d", year, nextOrderNumber)
    }

    /// Transition order through the workflow
    func advanceStatus(order: Order) {
        switch order.status {
        case .draft: order.status = .confirmed
        case .confirmed: order.status = .inProduction
        case .inProduction: order.status = .ready
        case .ready: order.status = .delivered
        case .delivered: order.status = .invoiced
        default: break
        }
    }

    /// Create invoice from delivered order
    func createInvoice(for order: Order, context: ModelContext) -> Invoice? {
        guard order.status == .delivered || order.status == .invoiced else { return nil }

        let invoice = Invoice(
            number: generateInvoiceNumber(),
            order: order
        )
        order.invoice = invoice
        order.status = .invoiced
        context.insert(invoice)
        try? context.save()
        return invoice
    }
}

// MARK: - Production ViewModel

@Observable
final class ProductionViewModel {
    /// Calculate total production time for an order
    func estimatedProductionTime(for order: Order) -> Int {
        order.items.reduce(0) { total, item in
            guard let product = item.product else { return total }
            let stepsTime = product.steps.reduce(0) { $0 + $1.totalTimeMinutes }
            return total + (stepsTime * item.quantity)
        }
    }

    /// Generate production tasks from an order
    func generateTasks(for order: Order, context: ModelContext) {
        var currentDate = Date.now
        let calendar = Calendar.current

        for item in order.items {
            guard let product = item.product else { continue }
            for step in product.steps.sorted(by: { $0.order < $1.order }) {
                let task = ProductionTask(
                    title: "\(step.name) — \(product.name)",
                    description: step.stepDescription,
                    date: currentDate,
                    startTime: currentDate,
                    estimatedDurationMinutes: step.durationMinutes,
                    assignee: .karim,
                    orderReference: order.reference
                )
                context.insert(task)

                // Advance time for next step (duration + rest)
                currentDate = calendar.date(
                    byAdding: .minute,
                    value: step.totalTimeMinutes,
                    to: currentDate
                ) ?? currentDate
            }
        }
        try? context.save()
    }
}

// MARK: - Export ViewModel (Accounting Integration)

@Observable
final class ExportViewModel {
    /// Export invoices to CSV for accounting software (Sage/QuickBooks compatible)
    func exportToCSV(invoices: [Invoice]) -> String {
        var csv = "Numéro;Date;Client;HT;TVA;TTC;Statut\n"

        for invoice in invoices {
            let clientName = invoice.order?.client?.fullName ?? "—"
            let line = [
                invoice.number,
                invoice.issueDate.formatted(.iso8601.year().month().day()),
                clientName,
                String(format: "%.2f", invoice.subtotal),
                String(format: "%.2f", invoice.taxAmount),
                String(format: "%.2f", invoice.total),
                invoice.status.rawValue,
            ].joined(separator: ";")
            csv += line + "\n"
        }

        return csv
    }
}
