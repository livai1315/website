// Views.swift
// La Maison Mirage — SwiftUI Views (Stubs + Dashboard)
// Each view connects to SwiftData via @Query and @Environment

import SwiftUI
import SwiftData

// MARK: - Design Tokens

extension Color {
    static let mirageGold = Color(red: 201/255, green: 168/255, blue: 76/255)
    static let mirageBg = Color(red: 10/255, green: 10/255, blue: 15/255)
    static let mirageCard = Color(red: 18/255, green: 18/255, blue: 26/255)
    static let mirageBorder = Color(red: 36/255, green: 36/255, blue: 51/255)
    static let mirageText = Color(red: 224/255, green: 224/255, blue: 240/255)
    static let mirageSubtle = Color(red: 136/255, green: 136/255, blue: 170/255)
}

// MARK: - Dashboard View

struct DashboardView: View {
    @Query(filter: #Predicate<Order> { order in
        order.status != .cancelled && order.status != .invoiced
    }, sort: \Order.deliveryDate)
    private var activeOrders: [Order]

    @Query(filter: #Predicate<Ingredient> { $0.currentStock <= $0.alertThreshold })
    private var lowStockIngredients: [Ingredient]

    @Query(filter: #Predicate<ProductionTask> { !$0.isCompleted },
           sort: \ProductionTask.startTime)
    private var pendingTasks: [ProductionTask]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    headerSection

                    // KPI Cards
                    kpiSection

                    // Urgent Orders
                    if !urgentOrders.isEmpty {
                        urgentOrdersSection
                    }

                    // Stock Alerts
                    if !lowStockIngredients.isEmpty {
                        stockAlertsSection
                    }

                    // Today's Tasks
                    todayTasksSection
                }
                .padding()
            }
            .background(Color.mirageBg)
            .navigationBarHidden(true)
        }
    }

    private var urgentOrders: [Order] {
        activeOrders.filter { $0.isUrgent }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("La Maison Mirage")
                    .font(.custom("PlayfairDisplay-SemiBold", size: 22))
                    .foregroundColor(.mirageText)
                Text(Date.now.formatted(.dateTime.weekday(.wide).day().month(.wide)))
                    .font(.caption)
                    .foregroundColor(.mirageSubtle)
            }
            Spacer()
            HStack(spacing: -8) {
                avatarBadge("K", highlight: true)
                avatarBadge("A", highlight: false)
            }
        }
    }

    private func avatarBadge(_ initial: String, highlight: Bool) -> some View {
        Text(initial)
            .font(.caption.bold())
            .frame(width: 32, height: 32)
            .background(highlight ? Color.mirageGold.opacity(0.2) : Color.mirageBorder)
            .foregroundColor(highlight ? .mirageGold : .mirageSubtle)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.mirageBg, lineWidth: 2))
    }

    // MARK: - KPI Cards

    private var kpiSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12),
        ], spacing: 12) {
            KPICard(
                icon: "eurosign.circle.fill",
                title: "CA du jour",
                value: todayRevenue,
                subtitle: "vs hier"
            )
            KPICard(
                icon: "bag.fill",
                title: "Commandes actives",
                value: "\(activeOrders.count)",
                subtitle: "\(urgentOrders.count) urgente(s)"
            )
            KPICard(
                icon: "person.2.fill",
                title: "Clients ce mois",
                value: "\(uniqueClientsThisMonth)",
                subtitle: nil
            )
            KPICard(
                icon: "exclamationmark.triangle.fill",
                title: "Alertes stock",
                value: "\(lowStockIngredients.count)",
                subtitle: lowStockIngredients.isEmpty ? "Tout est OK" : "À commander",
                isAlert: !lowStockIngredients.isEmpty
            )
        }
    }

    private var todayRevenue: String {
        let today = Calendar.current.startOfDay(for: .now)
        let total = activeOrders
            .filter { $0.status == .delivered && Calendar.current.isDate($0.deliveryDate, inSameDayAs: today) }
            .reduce(0) { $0 + $1.totalAmount }
        return String(format: "%.0f €", total)
    }

    private var uniqueClientsThisMonth: Int {
        let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: .now))!
        return Set(
            activeOrders
                .filter { $0.createdAt >= startOfMonth }
                .compactMap { $0.client?.fullName }
        ).count
    }

    // MARK: - Urgent Orders Section

    private var urgentOrdersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Livraisons urgentes", icon: "truck.box.fill")
            ForEach(urgentOrders) { order in
                OrderRow(order: order)
            }
        }
        .cardStyle()
    }

    // MARK: - Stock Alerts Section

    private var stockAlertsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Alertes stock", icon: "exclamationmark.triangle.fill", tint: .orange)
            ForEach(lowStockIngredients) { ingredient in
                StockAlertRow(ingredient: ingredient)
            }
            NavigationLink {
                CoursesView()
            } label: {
                Text("Générer liste de courses")
                    .font(.subheadline.weight(.medium))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.mirageGold.opacity(0.1))
                    .foregroundColor(.mirageGold)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.mirageGold.opacity(0.2), lineWidth: 1)
                    )
            }
        }
        .cardStyle()
    }

    // MARK: - Tasks Section

    private var todayTasksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Tâches du jour", icon: "checklist")
            if pendingTasks.isEmpty {
                Text("Aucune tâche en attente")
                    .font(.subheadline)
                    .foregroundColor(.mirageSubtle)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                ForEach(pendingTasks) { task in
                    TaskRow(task: task)
                }
            }
        }
        .cardStyle()
    }
}

// MARK: - Reusable Components

struct KPICard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String?
    var isAlert: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(isAlert ? .orange : .mirageGold)
                .frame(width: 36, height: 36)
                .background((isAlert ? Color.orange : Color.mirageGold).opacity(0.1))
                .cornerRadius(10)

            Text(value)
                .font(.custom("PlayfairDisplay-SemiBold", size: 24))
                .foregroundColor(.mirageText)

            Text(title)
                .font(.caption)
                .foregroundColor(.mirageSubtle)

            if let subtitle {
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(isAlert ? .orange : .mirageSubtle.opacity(0.7))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.mirageCard)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.mirageGold.opacity(0.06), lineWidth: 1)
        )
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String
    var tint: Color = .mirageGold

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(tint)
            Text(title)
                .font(.custom("PlayfairDisplay-Medium", size: 16))
                .foregroundColor(.mirageText)
            Spacer()
        }
    }
}

struct OrderRow: View {
    let order: Order

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(order.client?.fullName ?? "—")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.mirageText)
                    TypeBadge(type: order.type)
                }
                Text(order.reference)
                    .font(.caption)
                    .foregroundColor(.mirageSubtle)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(order.deliveryDate.formatted(.dateTime.day().month().hour().minute()))
                    .font(.caption)
                    .foregroundColor(.mirageSubtle)
                StatusBadge(status: order.status)
            }
        }
        .padding(12)
        .background(Color.mirageBg.opacity(0.5))
        .cornerRadius(12)
    }
}

struct StatusBadge: View {
    let status: OrderStatus

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(statusColor)
                .frame(width: 6, height: 6)
            Text(status.rawValue)
                .font(.caption2.weight(.medium))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(statusColor.opacity(0.1))
        .cornerRadius(8)
    }

    private var statusColor: Color {
        switch status {
        case .draft: return .gray
        case .confirmed: return .blue
        case .inProduction: return .orange
        case .ready: return .green
        case .delivered: return .purple
        case .invoiced: return .mint
        case .cancelled: return .red
        }
    }
}

struct TypeBadge: View {
    let type: OrderType

    var body: some View {
        Text(type.rawValue)
            .font(.caption2.weight(.medium))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(typeColor.opacity(0.1))
            .foregroundColor(typeColor)
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(typeColor.opacity(0.2), lineWidth: 1)
            )
    }

    private var typeColor: Color {
        switch type {
        case .b2b: return .blue
        case .b2c: return .purple
        case .event: return .pink
        }
    }
}

struct StockAlertRow: View {
    let ingredient: Ingredient

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(ingredient.name)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.mirageText)
                Spacer()
                Text("\(String(format: "%.1f", ingredient.currentStock)) \(ingredient.unit.rawValue)")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.orange)
            }
            ProgressView(value: ingredient.stockPercentage, total: 100)
                .tint(ingredient.stockPercentage < 40 ? .red : .orange)
            if let supplier = ingredient.supplier {
                Text(supplier.name)
                    .font(.caption2)
                    .foregroundColor(.mirageSubtle)
            }
        }
        .padding(10)
        .background(Color.orange.opacity(0.03))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.orange.opacity(0.1), lineWidth: 1)
        )
    }
}

struct TaskRow: View {
    @Bindable var task: ProductionTask

    var body: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation { task.isCompleted.toggle() }
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                    .foregroundColor(task.isCompleted ? .mirageGold : .mirageSubtle)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .font(.subheadline)
                    .foregroundColor(task.isCompleted ? .mirageSubtle : .mirageText)
                    .strikethrough(task.isCompleted)
                HStack(spacing: 8) {
                    Text(task.startTime.formatted(.dateTime.hour().minute()))
                        .font(.caption2)
                        .foregroundColor(.mirageSubtle)
                    AssigneeBadge(assignee: task.assignee)
                }
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct AssigneeBadge: View {
    let assignee: Assignee

    var body: some View {
        Text(assignee.rawValue)
            .font(.caption2)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(assignee == .karim ? Color.mirageGold.opacity(0.1) : Color.mirageBorder)
            .foregroundColor(assignee == .karim ? .mirageGold : .mirageSubtle)
            .cornerRadius(4)
    }
}

// MARK: - Card Style Modifier

extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .background(Color.mirageCard)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.mirageGold.opacity(0.06), lineWidth: 1)
            )
    }
}

// MARK: - Tab View Stubs (to expand)

struct CoursesView: View {
    @Query(sort: \Ingredient.name) private var ingredients: [Ingredient]
    @Query(sort: \Supplier.name) private var suppliers: [Supplier]

    var body: some View {
        NavigationStack {
            List {
                Section("Stock bas") {
                    ForEach(ingredients.filter { $0.isLowStock }) { ingredient in
                        StockAlertRow(ingredient: ingredient)
                            .listRowBackground(Color.mirageCard)
                    }
                }
                Section("Tous les ingrédients") {
                    ForEach(ingredients) { ingredient in
                        HStack {
                            Text(ingredient.name)
                                .foregroundColor(.mirageText)
                            Spacer()
                            Text("\(String(format: "%.1f", ingredient.currentStock)) \(ingredient.unit.rawValue)")
                                .foregroundColor(.mirageSubtle)
                        }
                        .listRowBackground(Color.mirageCard)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.mirageBg)
            .navigationTitle("Courses & Stocks")
        }
    }
}

struct PlanningView: View {
    @Query(sort: \ProductionTask.startTime) private var tasks: [ProductionTask]

    var body: some View {
        NavigationStack {
            List {
                ForEach(tasks) { task in
                    TaskRow(task: task)
                        .listRowBackground(Color.mirageCard)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.mirageBg)
            .navigationTitle("Planning")
        }
    }
}

struct VentesView: View {
    @Query(sort: \Order.createdAt, order: .reverse) private var orders: [Order]

    var body: some View {
        NavigationStack {
            List {
                ForEach(orders) { order in
                    OrderRow(order: order)
                        .listRowBackground(Color.mirageCard)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.mirageBg)
            .navigationTitle("Ventes & CRM")
        }
    }
}

struct ReglagesView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Profils") {
                    Label("Karim", systemImage: "person.fill")
                    Label("Associé", systemImage: "person.fill")
                }
                Section("Catalogue") {
                    Label("Produits", systemImage: "square.grid.2x2")
                }
                Section("Facturation") {
                    Label("Paramètres TVA", systemImage: "doc.text")
                    Label("Mentions légales", systemImage: "doc.plaintext")
                    Label("Export comptable", systemImage: "square.and.arrow.up")
                }
                Section("Données") {
                    Label("Seuils d'alerte stock", systemImage: "gauge.medium")
                    Label("Sauvegarde iCloud", systemImage: "icloud")
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.mirageBg)
            .navigationTitle("Réglages")
        }
    }
}

// MARK: - Preview

#Preview {
    MainTabView()
        .modelContainer(for: [
            Ingredient.self, Supplier.self, Product.self,
            ProductionStep.self, Client.self, Order.self,
            OrderItem.self, Invoice.self, ProductionTask.self,
            StockMovement.self,
        ], inMemory: true)
}
