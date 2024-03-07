//
//  ChartCore.swift
//  Todos
//
//  Created by Hanna Shin's iMac on 2/23/24.
//

import ComposableArchitecture
import SwiftUI
import RealmSwift

struct ChartCore: Reducer {
    struct State: Equatable {
        
    }
    
    enum Action: BindableAction, Equatable, Sendable {
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.realmClient) var realmClient // RealmClient 의존성 주입
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            }
        }
    }
}
