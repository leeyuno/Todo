import SwiftUI
import ComposableArchitecture

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                CalendarView(
                    store: Store(initialState: CalendarCore.State()) {
                        CalendarCore()
                    }
                )
            }
            .tabItem {
                Image(systemName: "calendar")
                Text("Calendar") // Optionally use LocalizedStringKey for localization
            }
            
            NavigationStack {
                ChartView(
                    store: Store(initialState: ChartCore.State()) {
                        ChartCore()
                    }
                )
            }
            .tabItem {
                Image(systemName: "chart.pie")
                Text("Chart") // Optionally use LocalizedStringKey for localization
            }
        }
    }
}

#Preview {
    MainTabView()
}
