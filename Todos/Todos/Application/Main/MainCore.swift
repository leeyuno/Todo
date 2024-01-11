//
//  TodosCore.swift
//  Todos
//
//  Created by 이윤오 on 2023/11/07.d
//

import ComposableArchitecture
import SwiftUI

enum Filter: LocalizedStringKey, CaseIterable, Hashable {
    case all = "All"
    case active = "Active"
    case completed = "Completed"
}

struct MainCore: Reducer {
    struct State: Equatable {
        var addState = AddCore.State(id: UUID())
        
        @BindingState var filter: Filter = .all
        var todos: [TodoEntity] = []
        
        var filteredTodos: [TodoEntity] {
          switch filter {
          case .active: return self.todos.filter { !$0.isComplete }
          case .all: return self.todos
          case .completed: return self.todos.filter(\.isComplete)
          }
        }
    }
    
    enum Action: BindableAction, Equatable, Sendable {
        case addTodoButtonTapped(AddCore.Action)
        case binding(BindingAction<State>)
        case delete(IndexSet)
    }
    
//    @Dependency(\.numberFact) var numberFact
//    func reduce(into state: inout State, action: Action) -> Effect<Action> {
//        return .none
//    }
    
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
        
        Scope(state: \.addState, action: /Action.addTodoButtonTapped) {
            AddCore()
        }
    }
}
