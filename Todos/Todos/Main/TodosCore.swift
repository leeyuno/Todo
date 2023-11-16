//
//  TodosCore.swift
//  Todos
//
//  Created by 이윤오 on 2023/11/07.
//

import ComposableArchitecture
import SwiftUI

enum Filter: LocalizedStringKey, CaseIterable, Hashable {
    case all = "All"
    case active = "Active"
    case completed = "Completed"
}

struct Todos: Reducer {
    struct State: Equatable {
        var titleState = AddTitle.State()
        
        @BindingState var filter: Filter = .all
        var todos: [TodoEntity] = []
    }
    
    enum Action: BindableAction, Equatable, Sendable {
        case addTodoButtonTapped(AddTitle.Action)
        case binding(BindingAction<State>)
        case delete(IndexSet)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .addTodoButtonTapped:
                return .none
            case .binding:
                return .none
            case let .delete(indexSet):
                
                return .none
            }
        }
        
        Scope(state: \.titleState, action: /Action.addTodoButtonTapped) {
            AddTitle()
        }
    }
}
