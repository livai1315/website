// MaisonMirageApp.swift
// La Maison Mirage — Application principale
// Architecture: MVVM + SwiftData + CloudKit sync

import SwiftUI
import SwiftData

// MARK: - App Entry Point

@main
struct MaisonMirageApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Ingredient.self,
            Supplier.self,
            Product.self,
            ProductionStep.self,
            Client.self,
            Order.self,
            OrderItem.self,
            Invoice.self,
            ProductionTask.self,
            StockMovement.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .automatic // Sync between both partners
        )
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(sharedModelContainer)
    }
}

// MARK: - Main Navigation (TabView)

struct MainTabView: View {
    @State private var selectedTab: Tab = .dashboard

    enum Tab: String, CaseIterable {
        case dashboard = "Dashboard"
        case courses = "Courses"
        case planning = "Planning"
        case ventes = "Ventes"
        case reglages = "Réglages"

        var icon: String {
            switch self {
            case .dashboard: return "chart.bar.fill"
            case .courses: return "cart.fill"
            case .planning: return "calendar"
            case .ventes: return "briefcase.fill"
            case .reglages: return "gearshape.fill"
            }
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label(Tab.dashboard.rawValue, systemImage: Tab.dashboard.icon)
                }
                .tag(Tab.dashboard)

            CoursesView()
                .tabItem {
                    Label(Tab.courses.rawValue, systemImage: Tab.courses.icon)
                }
                .tag(Tab.courses)

            PlanningView()
                .tabItem {
                    Label(Tab.planning.rawValue, systemImage: Tab.planning.icon)
                }
                .tag(Tab.planning)

            VentesView()
                .tabItem {
                    Label(Tab.ventes.rawValue, systemImage: Tab.ventes.icon)
                }
                .tag(Tab.ventes)

            ReglagesView()
                .tabItem {
                    Label(Tab.reglages.rawValue, systemImage: Tab.reglages.icon)
                }
                .tag(Tab.reglages)
        }
        .tint(Color("MirageGold")) // #C9A84C
    }
}
