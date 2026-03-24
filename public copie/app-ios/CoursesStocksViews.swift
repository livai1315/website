// CoursesStocksViews.swift
// La Maison Mirage — Module Courses & Stocks (complet)
// Sous-écrans : Stocks, Alertes, Liste de courses, Fournisseurs

import SwiftUI
import SwiftData

// MARK: - Main Courses View (replaces stub)

struct CoursesView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Ingredient.name) private var ingredients: [Ingredient]
    @Query(sort: \Supplier.name) private var suppliers: [Supplier]
    @State private var selectedTab: StockTab = .all
    @State private var searchText = ""
    @State private var categoryFilter = "Tous"
    @State private var showAddIngredient = false
    @StateObject private var stockVM = StockViewModelObs()

    enum StockTab: String, CaseIterable {
        case all = "Tous les stocks"
        case alerts = "Alertes"
        case shopping = "Liste de courses"
        case suppliers = "Fournisseurs"
    }

    private var lowStock: [Ingredient] {
        ingredients.filter { $0.isLowStock }
    }

    private var categories: [String] {
        let cats = Set(ingredients.map { $0.category })
        return ["Tous"] + cats.sorted()
    }

    private var filteredIngredients: [Ingredient] {
        ingredients.filter { ingredient in
            let matchSearch = searchText.isEmpty ||
                ingredient.name.localizedCaseInsensitiveContains(searchText) ||
                (ingredient.supplier?.name.localizedCaseInsensitiveContains(searchText) ?? false)
            let matchCategory = categoryFilter == "Tous" || ingredient.category == categoryFilter
            return matchSearch && matchCategory
        }
    }

    private var totalStockValue: Double {
        ingredients.reduce(0) { $0 + ($1.currentStock * $1.costPerUnit) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    statsBar
                    tabPicker
                    contentForSelectedTab
                }
                .padding()
            }
            .background(Color.mirageBg)
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddIngredient) {
                AddIngredientSheet(suppliers: suppliers)
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                EyebrowText("Approvisionnements")
                Text("Courses & ")
                    .font(.custom("CormorantGaramond-Light", size: 32))
                    .foregroundColor(.mirageText)
                + Text("Stocks")
                    .font(.custom("CormorantGaramond-LightItalic", size: 32))
                    .foregroundColor(.mirageGold)
            }
            Spacer()
            Button {
                showAddIngredient = true
            } label: {
                Label("Ingrédient", systemImage: "plus")
                    .font(.custom("JetBrainsMono-Regular", size: 10))
                    .textCase(.uppercase)
                    .tracking(2)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.mirageGold)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
        }
    }

    // MARK: - Stats Bar (KPI)

    private var statsBar: some View {
        HStack(spacing: 1) {
            StockStatItem(
                value: "\(ingredients.count)",
                label: "Ingrédients suivis"
            )
            StockStatItem(
                value: "\(lowStock.count)",
                label: "Stocks bas",
                highlight: !lowStock.isEmpty
            )
            StockStatItem(
                value: String(format: "%.0f €", totalStockValue),
                label: "Valeur stock"
            )
        }
        .background(Color(red: 26/255, green: 23/255, blue: 20/255, opacity: 0.06))
        .cornerRadius(16)
    }

    // MARK: - Tab Picker (Filter Pills)

    private var tabPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(StockTab.allCases, id: \.self) { tab in
                    let label = tab == .alerts ? "\(tab.rawValue) (\(lowStock.count))" : tab.rawValue
                    FilterPill(label: label, isActive: selectedTab == tab) {
                        withAnimation(.easeOut(duration: 0.25)) {
                            selectedTab = tab
                        }
                    }
                }
            }
        }
    }

    // MARK: - Content Router

    @ViewBuilder
    private var contentForSelectedTab: some View {
        switch selectedTab {
        case .all:
            allStocksView
        case .alerts:
            alertsView
        case .shopping:
            shoppingListView
        case .suppliers:
            suppliersView
        }
    }

    // MARK: - All Stocks

    private var allStocksView: some View {
        VStack(spacing: 16) {
            // Search
            SearchBar(text: $searchText, placeholder: "Rechercher un ingrédient ou fournisseur...")

            // Category filters
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(categories, id: \.self) { cat in
                        FilterPill(label: cat, isActive: categoryFilter == cat, compact: true) {
                            categoryFilter = cat
                        }
                    }
                }
            }

            // Ingredient list
            LazyVStack(spacing: 0) {
                ForEach(filteredIngredients) { ingredient in
                    IngredientRow(
                        ingredient: ingredient,
                        onAdjust: { delta in
                            stockVM.recordMovement(
                                ingredient: ingredient,
                                quantity: delta,
                                reason: delta > 0 ? "Ajout manuel" : "Retrait manuel",
                                context: context
                            )
                        }
                    )
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        }
    }

    // MARK: - Alerts

    private var alertsView: some View {
        VStack(spacing: 16) {
            if lowStock.isEmpty {
                emptyState(
                    title: "Tous les stocks sont en ordre",
                    subtitle: "Aucun ingrédient sous le seuil d'alerte"
                )
            } else {
                ForEach(lowStock) { ingredient in
                    StockAlertCard(ingredient: ingredient)
                }

                Button {
                    withAnimation { selectedTab = .shopping }
                } label: {
                    HStack {
                        Text("Générer liste de courses")
                        Image(systemName: "arrow.right")
                    }
                    .font(.custom("JetBrainsMono-Regular", size: 12))
                    .textCase(.uppercase)
                    .tracking(2)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.mirageGold)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .shadow(color: Color.mirageGold.opacity(0.25), radius: 8, y: 4)
                }
            }
        }
    }

    // MARK: - Shopping List

    private var shoppingListView: some View {
        VStack(spacing: 16) {
            let shoppingItems = stockVM.generateShoppingList(ingredients: ingredients)
            let grouped = Dictionary(grouping: shoppingItems) { $0.ingredient.supplier?.name ?? "Sans fournisseur" }

            if shoppingItems.isEmpty {
                emptyState(title: "Liste vide", subtitle: "Tous les stocks sont au-dessus du seuil")
            } else {
                ForEach(grouped.keys.sorted(), id: \.self) { supplierName in
                    if let items = grouped[supplierName] {
                        ShoppingGroupSection(supplierName: supplierName, items: items)
                    }
                }

                // Total
                HStack {
                    Text("Total estimé")
                        .font(.custom("JetBrainsMono-Regular", size: 10))
                        .textCase(.uppercase)
                        .tracking(3)
                        .foregroundColor(.mirageSubtle)
                    Spacer()
                    let total = shoppingItems.reduce(0.0) { $0 + ($1.quantityNeeded * $1.ingredient.costPerUnit) }
                    Text(String(format: "%.0f €", total))
                        .font(.custom("CormorantGaramond-Light", size: 28))
                        .foregroundColor(.mirageText)
                }
                .padding(.top, 8)
            }
        }
    }

    // MARK: - Suppliers

    private var suppliersView: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 320), spacing: 16)], spacing: 16) {
            ForEach(suppliers) { supplier in
                SupplierCard(supplier: supplier)
            }
        }
    }

    // MARK: - Empty State

    private func emptyState(title: String, subtitle: String) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.custom("CormorantGaramond-Light", size: 22))
                .foregroundColor(.mirageText)
            Text(subtitle)
                .font(.custom("JetBrainsMono-Regular", size: 10))
                .textCase(.uppercase)
                .tracking(2)
                .foregroundColor(.mirageSubtle)
        }
        .frame(maxWidth: .infinity)
        .padding(48)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }
}

// MARK: - Sub-Components

struct EyebrowText: View {
    let text: String
    init(_ text: String) { self.text = text }

    var body: some View {
        HStack(spacing: 10) {
            Rectangle()
                .fill(Color.mirageGold.opacity(0.5))
                .frame(width: 30, height: 1)
            Text(text)
                .font(.custom("JetBrainsMono-Regular", size: 10))
                .textCase(.uppercase)
                .tracking(4)
                .foregroundColor(Color(red: 138/255, green: 109/255, blue: 59/255))
        }
    }
}

struct StockStatItem: View {
    let value: String
    let label: String
    var highlight: Bool = false

    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.custom("CormorantGaramond-Light", size: 28))
                .foregroundColor(highlight ? .mirageGold : .mirageText)
            Text(label)
                .font(.custom("JetBrainsMono-Regular", size: 8))
                .textCase(.uppercase)
                .tracking(3)
                .foregroundColor(.mirageSubtle)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(red: 250/255, green: 245/255, blue: 239/255))
    }
}

struct FilterPill: View {
    let label: String
    let isActive: Bool
    var compact: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.custom("JetBrainsMono-Regular", size: compact ? 8 : 9))
                .textCase(.uppercase)
                .tracking(compact ? 1.5 : 2.5)
                .padding(.horizontal, compact ? 12 : 18)
                .padding(.vertical, compact ? 8 : 12)
                .background(isActive ? Color.mirageGold : .clear)
                .foregroundColor(isActive ? .white : .mirageSubtle)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(isActive ? Color.clear : Color(red: 26/255, green: 23/255, blue: 20/255, opacity: 0.15), lineWidth: 1)
                )
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.subheadline)
                .foregroundColor(.mirageSubtle)
            TextField(placeholder, text: $text)
                .font(.custom("Outfit-Regular", size: 15))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(999)
        .overlay(
            RoundedRectangle(cornerRadius: 999)
                .stroke(Color(red: 26/255, green: 23/255, blue: 20/255, opacity: 0.08), lineWidth: 1)
        )
    }
}

struct IngredientRow: View {
    let ingredient: Ingredient
    let onAdjust: (Double) -> Void

    private var status: (color: Color, label: String) {
        let pct = ingredient.currentStock / ingredient.alertThreshold
        if pct <= 0.5 { return (.mirageError, "Critique") }
        if pct <= 1.0 { return (.mirageGold, "Bas") }
        return (.mirageSuccess, "OK")
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                // Status + Name
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(status.color)
                            .frame(width: 8, height: 8)
                        Text(ingredient.name)
                            .font(.custom("Outfit-Regular", size: 15))
                            .foregroundColor(.mirageText)
                    }
                    Text("\(ingredient.category) · \(ingredient.storageInfo)")
                        .font(.custom("JetBrainsMono-Regular", size: 8))
                        .textCase(.uppercase)
                        .tracking(1.5)
                        .foregroundColor(.mirageSubtle)
                }

                Spacer()

                // Quantity
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text(String(format: "%.1f", ingredient.currentStock))
                            .font(.custom("CormorantGaramond-Light", size: 20))
                            .foregroundColor(.mirageText)
                        Text(ingredient.unit.rawValue)
                            .font(.custom("JetBrainsMono-Regular", size: 9))
                            .foregroundColor(.mirageSubtle)
                    }

                    // Progress bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.mirageBorder)
                                .frame(height: 3)
                            RoundedRectangle(cornerRadius: 2)
                                .fill(status.color)
                                .frame(width: geo.size.width * ingredient.stockPercentage / 100, height: 3)
                        }
                    }
                    .frame(width: 80, height: 3)
                }

                // Adjust buttons
                HStack(spacing: 6) {
                    Button { onAdjust(-0.5) } label: {
                        Image(systemName: "minus")
                            .font(.caption2)
                            .frame(width: 32, height: 32)
                            .background(Circle().stroke(Color.mirageBorder, lineWidth: 1))
                            .foregroundColor(.mirageSubtle)
                    }
                    Button { onAdjust(0.5) } label: {
                        Image(systemName: "plus")
                            .font(.caption2)
                            .frame(width: 32, height: 32)
                            .background(Circle().stroke(Color.mirageBorder, lineWidth: 1))
                            .foregroundColor(.mirageSubtle)
                    }
                }
            }
            .padding(.vertical, 14)

            Divider().opacity(0.3)
        }
    }
}

struct StockAlertCard: View {
    let ingredient: Ingredient

    private var isCritical: Bool {
        ingredient.currentStock <= ingredient.alertThreshold * 0.5
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack(spacing: 6) {
                    Circle()
                        .fill(isCritical ? Color.mirageError : .mirageGold)
                        .frame(width: 8, height: 8)
                    Text(ingredient.name)
                        .font(.custom("Outfit-Medium", size: 15))
                        .foregroundColor(.mirageText)
                }
                Spacer()
                Text("\(String(format: "%.1f", ingredient.currentStock)) \(ingredient.unit.rawValue)")
                    .font(.custom("CormorantGaramond-Light", size: 20))
                    .foregroundColor(isCritical ? .mirageError : .mirageGold)
            }

            ProgressView(value: ingredient.stockPercentage, total: 100)
                .tint(isCritical ? Color.mirageError : .mirageGold)

            HStack {
                Text("Seuil : \(String(format: "%.1f", ingredient.alertThreshold)) \(ingredient.unit.rawValue)")
                    .font(.custom("JetBrainsMono-Regular", size: 8))
                    .tracking(1)
                    .foregroundColor(.mirageSubtle)
                Spacer()
                let needed = (ingredient.alertThreshold * 2) - ingredient.currentStock
                Text("Commander : \(String(format: "%.1f", needed)) \(ingredient.unit.rawValue)")
                    .font(.custom("JetBrainsMono-Regular", size: 9))
                    .textCase(.uppercase)
                    .tracking(1.5)
                    .foregroundColor(.mirageGold)
            }
        }
        .padding(16)
        .background(isCritical ? Color.mirageError.opacity(0.03) : Color.mirageGold.opacity(0.03))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isCritical ? Color.mirageError.opacity(0.12) : Color.mirageGold.opacity(0.12), lineWidth: 1)
        )
    }
}

struct ShoppingGroupSection: View {
    let supplierName: String
    let items: [(ingredient: Ingredient, quantityNeeded: Double)]
    @State private var checkedItems: Set<String> = []

    var body: some View {
        VStack(spacing: 8) {
            // Group header
            HStack {
                Text(supplierName)
                    .font(.custom("Outfit-Medium", size: 15))
                    .foregroundColor(.mirageText)
                Spacer()
                Text("\(items.count) article\(items.count > 1 ? "s" : "")")
                    .font(.custom("JetBrainsMono-Regular", size: 8))
                    .textCase(.uppercase)
                    .tracking(2)
                    .foregroundColor(.mirageSubtle)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.mirageBg)
            .cornerRadius(12)

            // Items
            VStack(spacing: 0) {
                ForEach(items, id: \.ingredient.name) { item in
                    let isChecked = checkedItems.contains(item.ingredient.name)
                    HStack(spacing: 12) {
                        Button {
                            if isChecked {
                                checkedItems.remove(item.ingredient.name)
                            } else {
                                checkedItems.insert(item.ingredient.name)
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(isChecked ? Color.mirageGold : Color.mirageBorder, lineWidth: 1.5)
                                .frame(width: 22, height: 22)
                                .background(
                                    isChecked ?
                                    RoundedRectangle(cornerRadius: 6).fill(Color.mirageGold.opacity(0.15)) : nil
                                )
                                .overlay {
                                    if isChecked {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.mirageGold)
                                    }
                                }
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.ingredient.name)
                                .font(.custom("Outfit-Regular", size: 14))
                                .foregroundColor(isChecked ? .mirageSubtle : .mirageText)
                                .strikethrough(isChecked)
                            Text("En stock : \(String(format: "%.1f", item.ingredient.currentStock)) \(item.ingredient.unit.rawValue)")
                                .font(.custom("JetBrainsMono-Regular", size: 8))
                                .foregroundColor(.mirageSubtle)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 2) {
                            HStack(alignment: .firstTextBaseline, spacing: 2) {
                                Text(String(format: "%.1f", item.quantityNeeded))
                                    .font(.custom("CormorantGaramond-Light", size: 18))
                                    .foregroundColor(.mirageText)
                                Text(item.ingredient.unit.rawValue)
                                    .font(.custom("JetBrainsMono-Regular", size: 8))
                                    .foregroundColor(.mirageSubtle)
                            }
                            Text("~\(String(format: "%.0f", item.quantityNeeded * item.ingredient.costPerUnit)) €")
                                .font(.custom("JetBrainsMono-Regular", size: 8))
                                .foregroundColor(.mirageGold)
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 4)

                    if item.ingredient.name != items.last?.ingredient.name {
                        Divider().opacity(0.2)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        }
    }
}

struct SupplierCard: View {
    let supplier: Supplier

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.mirageGold.opacity(0.1))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Text(String(supplier.name.prefix(1)))
                            .font(.custom("CormorantGaramond-Light", size: 18))
                            .foregroundColor(.mirageGold)
                    )
                VStack(alignment: .leading, spacing: 2) {
                    Text(supplier.name)
                        .font(.custom("Outfit-Medium", size: 15))
                        .foregroundColor(.mirageText)
                    Text(supplier.contactName)
                        .font(.custom("JetBrainsMono-Regular", size: 8))
                        .textCase(.uppercase)
                        .tracking(1.5)
                        .foregroundColor(.mirageSubtle)
                }
            }

            // Contact
            HStack(spacing: 16) {
                Label(supplier.phone, systemImage: "phone")
                    .font(.custom("JetBrainsMono-Regular", size: 9))
                    .foregroundColor(.mirageSubtle)
            }

            // Delivery info
            HStack(spacing: 8) {
                Image(systemName: "truck.box")
                    .font(.caption)
                    .foregroundColor(.mirageGold)
                Text("Livraison : \(supplier.deliveryDays)")
                    .font(.custom("JetBrainsMono-Regular", size: 9))
                    .foregroundColor(.mirageSubtle)
                Spacer()
                Text("Min. \(String(format: "%.0f", supplier.minimumOrder)) €")
                    .font(.custom("JetBrainsMono-Regular", size: 9))
                    .foregroundColor(.mirageGold)
            }
            .padding(12)
            .background(Color.mirageBg)
            .cornerRadius(10)

            // Ingredients tags
            VStack(alignment: .leading, spacing: 6) {
                EyebrowText("Produits")
                FlowLayout(spacing: 4) {
                    ForEach(supplier.ingredients) { ingredient in
                        Text(ingredient.name)
                            .font(.custom("JetBrainsMono-Regular", size: 8))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.mirageGold.opacity(0.06))
                            .overlay(
                                RoundedRectangle(cornerRadius: 999)
                                    .stroke(Color.mirageGold.opacity(0.12), lineWidth: 1)
                            )
                            .clipShape(Capsule())
                            .foregroundColor(.mirageSubtle)
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(red: 26/255, green: 23/255, blue: 20/255, opacity: 0.04), lineWidth: 1)
        )
    }
}

// MARK: - Add Ingredient Sheet

struct AddIngredientSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    let suppliers: [Supplier]

    @State private var name = ""
    @State private var quantity = ""
    @State private var unit: StockUnit = .kg
    @State private var threshold = ""
    @State private var cost = ""
    @State private var category = ""
    @State private var storage = "Sec"
    @State private var selectedSupplier: Supplier?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    EyebrowText("Nouvel ingrédient")

                    Text("Ajouter au ")
                        .font(.custom("CormorantGaramond-Light", size: 28))
                        .foregroundColor(.mirageText)
                    + Text("stock")
                        .font(.custom("CormorantGaramond-LightItalic", size: 28))
                        .foregroundColor(.mirageGold)

                    // Form fields
                    VStack(spacing: 20) {
                        FormField(label: "Nom", text: $name, placeholder: "Ex: Chocolat Valrhona Dulcey 32%")

                        HStack(spacing: 16) {
                            FormField(label: "Quantité", text: $quantity, placeholder: "0", keyboardType: .decimalPad)
                            Picker("Unité", selection: $unit) {
                                ForEach(StockUnit.allCases, id: \.self) { u in
                                    Text(u.rawValue).tag(u)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(.mirageGold)
                        }

                        HStack(spacing: 16) {
                            FormField(label: "Seuil d'alerte", text: $threshold, placeholder: "0", keyboardType: .decimalPad)
                            FormField(label: "Coût unitaire (€)", text: $cost, placeholder: "0.00", keyboardType: .decimalPad)
                        }

                        FormField(label: "Catégorie", text: $category, placeholder: "Ex: Chocolat")
                    }
                }
                .padding(24)
            }
            .background(Color.mirageBg)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                        .font(.custom("JetBrainsMono-Regular", size: 10))
                        .textCase(.uppercase)
                        .foregroundColor(.mirageSubtle)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        saveIngredient()
                        dismiss()
                    }
                    .font(.custom("JetBrainsMono-Regular", size: 10))
                    .textCase(.uppercase)
                    .foregroundColor(.mirageGold)
                    .disabled(name.isEmpty)
                }
            }
        }
    }

    private func saveIngredient() {
        let ingredient = Ingredient(
            name: name,
            currentStock: Double(quantity) ?? 0,
            unit: unit,
            alertThreshold: Double(threshold) ?? 0,
            costPerUnit: Double(cost) ?? 0,
            category: category,
            storageInfo: storage,
            supplier: selectedSupplier
        )
        context.insert(ingredient)
        try? context.save()
    }
}

struct FormField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.custom("JetBrainsMono-Regular", size: 9))
                .textCase(.uppercase)
                .tracking(2)
                .foregroundColor(.mirageGold)
            TextField(placeholder, text: $text)
                .font(.custom("Outfit-Regular", size: 16))
                .keyboardType(keyboardType)
                .padding(.bottom, 8)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(red: 26/255, green: 23/255, blue: 20/255, opacity: 0.15)),
                    alignment: .bottom
                )
        }
    }
}

// MARK: - Observable ViewModel Wrapper

class StockViewModelObs: ObservableObject {
    private let vm = StockViewModel()

    func generateShoppingList(ingredients: [Ingredient]) -> [(ingredient: Ingredient, quantityNeeded: Double)] {
        vm.generateShoppingList(ingredients: ingredients)
    }

    func recordMovement(ingredient: Ingredient, quantity: Double, reason: String, context: ModelContext) {
        vm.recordMovement(ingredient: ingredient, quantity: quantity, reason: reason, context: context)
    }
}

// MARK: - Color Extensions

extension Color {
    static let mirageBg = Color(red: 250/255, green: 245/255, blue: 239/255)      // --cream
    static let mirageText = Color(red: 26/255, green: 23/255, blue: 20/255)        // --ink
    static let mirageGold = Color(red: 168/255, green: 137/255, blue: 92/255)      // --gold
    static let mirageGoldLight = Color(red: 201/255, green: 170/255, blue: 124/255) // --gold-light
    static let mirageSubtle = Color(red: 107/255, green: 101/255, blue: 96/255)    // --ink-muted
    static let mirageBorder = Color(red: 237/255, green: 232/255, blue: 226/255)   // --cream-3
    static let mirageSuccess = Color(red: 74/255, green: 124/255, blue: 89/255)    // --success
    static let mirageError = Color(red: 140/255, green: 58/255, blue: 58/255)      // --error
}
