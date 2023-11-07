//
//  Todos.swift
//  Todos
//
//  Created by 이윤오 on 2023/10/17.
//

import ComposableArchitecture
@preconcurrency import SwiftUI

struct AppView: View {
    let store: Store<Todos.State, Todos.Action>
    @ObservedObject var viewStore: ViewStore<Todos.State, Todos.Action>
    
    init(store: Store<Todos.State, Todos.Action>) {
        self.store = store
        self.viewStore = ViewStore(self.store) { $0 }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Picker("Filter", selection: viewStore.$filter.animation()) {
                    ForEach(Filter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                
                List {
                    ForEachStore(
                        self.store.scope(state: \.filteredTodos, action: { .todo(id: $0, action: $1) })
                    ) { store in
                        NavigationLink {
                            
                        } label: {
                            TodoView(store: store)
                        }
                    }
                    .onDelete { store.send(.delete($0)) }
                    .onMove { store.send(.move($0, $1)) }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Todos")
            .toolbar {
                NavigationLink {
                    AddTitleView(store: self.titleStore)
                } label: {
                    Text("할일")
                }
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
        }
    }
}

extension IdentifiedArray where ID == Todo.State.ID, Element == Todo.State {
    static let mock: Self = [
        Todo.State(
            description: "Check Mail",
            id: UUID(),
            isComplete: false
        ),
        Todo.State(
            description: "Buy Milk",
            id: UUID(),
            isComplete: false
        ),
        Todo.State(
            description: "Call Mom",
            id: UUID(),
            isComplete: false
        )
    ]
}

extension AppView {
    private var titleStore: Store<AddTitle.State, AddTitle.Action> {
        return store.scope(
            state: { $0.titleState },
            action: Todos.Action.addTodoButtonTapped
        )
    }
}

struct AppView_Proviews: PreviewProvider {
    static var previews: some View {
        AppView(store: Store(initialState: Todos.State(todos: .mock), reducer: {
            Todos()
        }))
    }
}
