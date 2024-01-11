//
//  TodosApp.swift
//  Todos
//
//  Created by 이윤오 on 2023/10/17.
//

import ComposableArchitecture
import SwiftUI

@main
struct TodosApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(
                store: Store(initialState: MainCore.State()) {
                    MainCore()._printChanges()
                }
            )
        }
    }
}
