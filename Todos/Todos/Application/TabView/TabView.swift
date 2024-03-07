//
//  tabView.swift
//  Todos
//
//  Created by Hanna Shin's iMac on 2/23/24.
//

import SwiftUI
import ComposableArchitecture

struct MainTabView: View {
    var body: some View {
        //        NavigationStack {
        //            TabView {
        //                CalendarView(
        //                    store: Store(initialState: CalendarCore.State()) {
        //                        CalendarCore()
        //                    }
        //                )
        //                .tabItem {
        //                    Image(systemName: "calendar")
        //                    Text("Calendar")
        //                }
        //
        //                ChartView(
        //                    store: Store(initialState: ChartCore.State()) {
        //                        ChartCore()
        //                    }
        //                )
        //                .tabItem {
        //                    Image(systemName: "chart.pie")
        //                    Text("Chart")
        //                }
        //            }
        //        }
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
                Text("Calendar")
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
                Text("Chart")
            }
            
        }
    }
}

#Preview {
    MainTabView()
}

