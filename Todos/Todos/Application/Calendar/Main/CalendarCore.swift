//
//  TodosCore.swift
//  Todos
//
//  Created by 이윤오 on 2023/11/07.d
//

import ComposableArchitecture
import SwiftUI
import RealmSwift

enum Filter: LocalizedStringKey, CaseIterable, Hashable {
    case daily = "일별"
    case weekly = "주별"
    case monthly = "월별"
}

struct CalendarCore: Reducer {
    struct State: Equatable {
        var addState = AddCore.State(id: UUID())
        
        @BindingState var filter: Filter = .daily
        var todos: [TodoEntity] = []
        
        var filteredTodos: [TodoEntity] {
          switch filter {
          case .daily: return self.todos.filter { !$0.isComplete }
          case .weekly: return self.todos
          case .monthly: return self.todos.filter(\.isComplete)
          }
        }
    }
    
    enum Action: BindableAction, Equatable, Sendable {
        case fetchAllTodos
        case sortTodos
        case addTodoButtonTapped(AddCore.Action)
        case binding(BindingAction<State>)
        case delete(IndexSet)
    }
    
//    @Dependency(\.numberFact) var numberFact
//    func reduce(into state: inout State, action: Action) -> Effect<Action> {
//        return .none
//    }
    
    @Dependency(\.realmClient) var realmClient // RealmClient 의존성 주입
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .fetchAllTodos:
                state.todos = realmClient.findAllTodo()
                return Effect.run { send in
                    await send.callAsFunction(.sortTodos)
                }
            case .sortTodos:
                return .none
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
