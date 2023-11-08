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
        var todos: IdentifiedArrayOf<Todo.State> = []
        
        var filteredTodos: IdentifiedArrayOf<Todo.State> {
            switch filter {
            case .active: return self.todos.filter { !$0.isComplete }
            case .all: return self.todos
            case .completed: return self.todos.filter(\.isComplete)
            }
        }
    }
    
    enum Action: BindableAction, Equatable, Sendable {
        case addTodoButtonTapped(AddTitle.Action)
        case binding(BindingAction<State>)
        case delete(IndexSet)
        case move(IndexSet, Int)
        case sortCompletedTodos
        case todo(id: Todo.State.ID, action: Todo.Action)
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.uuid) var uuid
    private enum CancelID { case todoCompletion }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .addTodoButtonTapped:
                ////                state.todos.insert(Todo.State(id: self.uuid()), at: 0)
                //
                return .none
            case .binding:
                return .none
                
            case let .delete(indexSet):
                let filteredTodos = state.filteredTodos
                for index in indexSet {
                    state.todos.remove(id: filteredTodos[index].id)
                }
                
                return .none
                
            case var .move(source, destination):
                if state.filter == .completed {
                    source = IndexSet (
                        source
                            .map { state.filteredTodos[$0] }
                            .compactMap { state.todos.index(id: $0.id) }
                    )
                    destination = (destination < state.filteredTodos.endIndex ? state.todos.index(id: state.filteredTodos[destination].id) : state.todos.endIndex) ?? destination
                }
                
                state.todos.move(fromOffsets: source, toOffset: destination)
                
                return .run { send in
                    try await self.clock.sleep(for: .milliseconds(100))
                    await send(.sortCompletedTodos)
                }
                
            case .sortCompletedTodos:
                state.todos.sort { $1.isComplete && !$0.isComplete }
                return .none
                
            case .todo(id: _, action: .binding(\.$isComplete)):
                return .run { send in
                    try await self.clock.sleep(for: .seconds(1))
                    await send(.sortCompletedTodos, animation: .default)
                }
                .cancellable(id: CancelID.todoCompletion, cancelInFlight: true)
                
            case .todo:
                return .none
            }
        }
        .forEach(\.todos, action: /Action.todo(id:action:)) {
            Todo()
        }
        
        Scope(state: \.titleState, action: /Action.addTodoButtonTapped) {
            AddTitle()
        }
    }
}
