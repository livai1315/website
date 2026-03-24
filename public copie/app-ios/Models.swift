// Models.swift
// La Maison Mirage — SwiftData Models
// Modèles de données pour stocks, ventes, production et CRM

import Foundation
import SwiftData

// MARK: - Enums

enum OrderType: String, Codable, CaseIterable {
    case b2b = "B2B"
    case b2c = "B2C"
    case event = "Événement"
}

enum OrderStatus: String, Codable, CaseIterable {
    case draft = "Brouillon"
    case confirmed = "Confirmée"
    case inProduction = "En production"
    case ready = "Prête"
    case delivered = "Livrée"
    case invoiced = "Facturée"
    case cancelled = "Annulée"

    var color: String {
        switch self {
        case .draft: return "gray"
        case .confirmed: return "blue"
        case .inProduction: return "orange"
        case .ready: return "green"
        case .delivered: return "purple"
        case .invoiced: return "mint"
        case .cancelled: return "red"
        }
    }
}

enum StockUnit: String, Codable, CaseIterable {
    case kg = "kg"
    case g = "g"
    case l = "L"
    case cl = "cL"
    case piece = "pièce(s)"
    case gousse = "gousse(s)"
}

enum Assignee: String, Codable, CaseIterable {
    case karim = "Karim"
    case associe = "Associé"
    case both = "Les deux"
}

enum InvoiceStatus: String, Codable, CaseIterable {
    case draft = "Brouillon"
    case sent = "Envoyée"
    case paid = "Payée"
    case overdue = "En retard"
}

// MARK: - Ingredient (Stock Management)

@Model
final class Ingredient {
    var name: String
    var currentStock: Double
    var unit: StockUnit
    var alertThreshold: Double
    var costPerUnit: Double
    var category: String // "Chocolat", "Fruits", "Crème", "Décoration", etc.
    var storageInfo: String // "Réfrigéré", "Sec", "Congelé"
    var supplier: Supplier?
    var movements: [StockMovement]

    @Transient
    var isLowStock: Bool {
        currentStock <= alertThreshold
    }

    @Transient
    var stockPercentage: Double {
        guard alertThreshold > 0 else { return 100 }
        return min((currentStock / (alertThreshold * 2)) * 100, 100)
    }

    init(
        name: String,
        currentStock: Double = 0,
        unit: StockUnit = .kg,
        alertThreshold: Double = 0,
        costPerUnit: Double = 0,
        category: String = "",
        storageInfo: String = "Sec",
        supplier: Supplier? = nil
    ) {
        self.name = name
        self.currentStock = currentStock
        self.unit = unit
        self.alertThreshold = alertThreshold
        self.costPerUnit = costPerUnit
        self.category = category
        self.storageInfo = storageInfo
        self.supplier = supplier
        self.movements = []
    }
}

// MARK: - StockMovement (Traceability)

@Model
final class StockMovement {
    var date: Date
    var quantity: Double // positive = in, negative = out
    var reason: String // "Livraison fournisseur", "Production CMD-XXX", "Perte"
    var ingredient: Ingredient?

    init(date: Date = .now, quantity: Double, reason: String, ingredient: Ingredient? = nil) {
        self.date = date
        self.quantity = quantity
        self.reason = reason
        self.ingredient = ingredient
    }
}

// MARK: - Supplier

@Model
final class Supplier {
    var name: String
    var contactName: String
    var phone: String
    var email: String
    var address: String
    var notes: String
    var minimumOrder: Double
    var deliveryDays: String // "Lundi, Jeudi"
    var ingredients: [Ingredient]

    init(
        name: String,
        contactName: String = "",
        phone: String = "",
        email: String = "",
        address: String = "",
        notes: String = "",
        minimumOrder: Double = 0,
        deliveryDays: String = ""
    ) {
        self.name = name
        self.contactName = contactName
        self.phone = phone
        self.email = email
        self.address = address
        self.notes = notes
        self.minimumOrder = minimumOrder
        self.deliveryDays = deliveryDays
        self.ingredients = []
    }
}

// MARK: - Product (Creations Catalog)

@Model
final class Product {
    var name: String
    var productDescription: String
    var basePrice: Double
    var preparationTimeHours: Double // Crucial for trompe-l'œil
    var category: String // "Signature", "Saisonnière", "Sur mesure"
    var isActive: Bool
    var imageData: Data?
    var steps: [ProductionStep]
    var orderItems: [OrderItem]

    @Transient
    var formattedPrice: String {
        String(format: "%.2f €", basePrice)
    }

    @Transient
    var formattedPrepTime: String {
        if preparationTimeHours >= 24 {
            let days = Int(preparationTimeHours / 24)
            let hours = Int(preparationTimeHours.truncatingRemainder(dividingBy: 24))
            return "\(days)j \(hours)h"
        }
        return "\(Int(preparationTimeHours))h"
    }

    init(
        name: String,
        description: String = "",
        basePrice: Double = 0,
        preparationTimeHours: Double = 0,
        category: String = "Signature",
        isActive: Bool = true
    ) {
        self.name = name
        self.productDescription = description
        self.basePrice = basePrice
        self.preparationTimeHours = preparationTimeHours
        self.category = category
        self.isActive = isActive
        self.steps = []
        self.orderItems = []
    }
}

// MARK: - ProductionStep

@Model
final class ProductionStep {
    var name: String
    var stepDescription: String
    var durationMinutes: Int
    var order: Int // Step sequence
    var requiresRefrigeration: Bool
    var restTimeMinutes: Int // Temps de repos/prise (critical for trompe-l'œil)
    var product: Product?

    @Transient
    var totalTimeMinutes: Int {
        durationMinutes + restTimeMinutes
    }

    init(
        name: String,
        description: String = "",
        durationMinutes: Int = 0,
        order: Int = 0,
        requiresRefrigeration: Bool = false,
        restTimeMinutes: Int = 0,
        product: Product? = nil
    ) {
        self.name = name
        self.stepDescription = description
        self.durationMinutes = durationMinutes
        self.order = order
        self.requiresRefrigeration = requiresRefrigeration
        self.restTimeMinutes = restTimeMinutes
        self.product = product
    }
}

// MARK: - Client (CRM)

@Model
final class Client {
    var companyName: String
    var contactFirstName: String
    var contactLastName: String
    var email: String
    var phone: String
    var address: String
    var type: OrderType // B2B, B2C, Event
    var preferences: String // Allergies, goûts, notes spéciales
    var notes: String
    var createdAt: Date
    var orders: [Order]

    @Transient
    var fullName: String {
        if companyName.isEmpty {
            return "\(contactFirstName) \(contactLastName)"
        }
        return companyName
    }

    @Transient
    var totalRevenue: Double {
        orders
            .filter { $0.status == .delivered || $0.status == .invoiced }
            .reduce(0) { $0 + $1.totalAmount }
    }

    @Transient
    var orderCount: Int {
        orders.count
    }

    init(
        companyName: String = "",
        contactFirstName: String = "",
        contactLastName: String = "",
        email: String = "",
        phone: String = "",
        address: String = "",
        type: OrderType = .b2c,
        preferences: String = "",
        notes: String = ""
    ) {
        self.companyName = companyName
        self.contactFirstName = contactFirstName
        self.contactLastName = contactLastName
        self.email = email
        self.phone = phone
        self.address = address
        self.type = type
        self.preferences = preferences
        self.notes = notes
        self.createdAt = .now
        self.orders = []
    }
}

// MARK: - Order

@Model
final class Order {
    var reference: String // "CMD-2026-087"
    var status: OrderStatus
    var type: OrderType
    var createdAt: Date
    var deliveryDate: Date
    var deliveryAddress: String
    var notes: String
    var client: Client?
    var items: [OrderItem]
    var invoice: Invoice?

    @Transient
    var totalAmount: Double {
        items.reduce(0) { $0 + $1.lineTotal }
    }

    @Transient
    var isUrgent: Bool {
        let calendar = Calendar.current
        let daysUntilDelivery = calendar.dateComponents([.day], from: .now, to: deliveryDate).day ?? 0
        return daysUntilDelivery <= 2 && status != .delivered && status != .invoiced && status != .cancelled
    }

    init(
        reference: String = "",
        status: OrderStatus = .draft,
        type: OrderType = .b2c,
        deliveryDate: Date = .now,
        deliveryAddress: String = "",
        notes: String = "",
        client: Client? = nil
    ) {
        self.reference = reference
        self.status = status
        self.type = type
        self.createdAt = .now
        self.deliveryDate = deliveryDate
        self.deliveryAddress = deliveryAddress
        self.notes = notes
        self.client = client
        self.items = []
    }
}

// MARK: - OrderItem

@Model
final class OrderItem {
    var quantity: Int
    var unitPrice: Double
    var customization: String // Specific requests per item
    var order: Order?
    var product: Product?

    @Transient
    var lineTotal: Double {
        Double(quantity) * unitPrice
    }

    init(
        quantity: Int = 1,
        unitPrice: Double = 0,
        customization: String = "",
        order: Order? = nil,
        product: Product? = nil
    ) {
        self.quantity = quantity
        self.unitPrice = unitPrice
        self.customization = customization
        self.order = order
        self.product = product
    }
}

// MARK: - Invoice

@Model
final class Invoice {
    var number: String // "FAC-2026-042"
    var issueDate: Date
    var dueDate: Date
    var status: InvoiceStatus
    var taxRate: Double // TVA 5.5% for artisanal food in France
    var notes: String
    var order: Order?

    @Transient
    var subtotal: Double {
        order?.totalAmount ?? 0
    }

    @Transient
    var taxAmount: Double {
        subtotal * taxRate
    }

    @Transient
    var total: Double {
        subtotal + taxAmount
    }

    init(
        number: String = "",
        issueDate: Date = .now,
        dueDate: Date = Calendar.current.date(byAdding: .day, value: 30, to: .now)!,
        status: InvoiceStatus = .draft,
        taxRate: Double = 0.055, // 5.5% TVA alimentaire
        notes: String = "",
        order: Order? = nil
    ) {
        self.number = number
        self.issueDate = issueDate
        self.dueDate = dueDate
        self.status = status
        self.taxRate = taxRate
        self.notes = notes
        self.order = order
    }
}

// MARK: - ProductionTask (Planning)

@Model
final class ProductionTask {
    var title: String
    var taskDescription: String
    var date: Date
    var startTime: Date
    var estimatedDurationMinutes: Int
    var assignee: Assignee
    var isCompleted: Bool
    var orderReference: String // Link to CMD-XXXX

    init(
        title: String,
        description: String = "",
        date: Date = .now,
        startTime: Date = .now,
        estimatedDurationMinutes: Int = 60,
        assignee: Assignee = .karim,
        isCompleted: Bool = false,
        orderReference: String = ""
    ) {
        self.title = title
        self.taskDescription = description
        self.date = date
        self.startTime = startTime
        self.estimatedDurationMinutes = estimatedDurationMinutes
        self.assignee = assignee
        self.isCompleted = isCompleted
        self.orderReference = orderReference
    }
}
