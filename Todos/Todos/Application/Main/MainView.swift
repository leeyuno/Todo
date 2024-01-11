//
//  Todos.swift
//  Todos
//
//  Created by 이윤오 on 2023/10/17.
//

import ComposableArchitecture
@preconcurrency import SwiftUI

struct MainView: View {
    let store: Store<MainCore.State, MainCore.Action>
    @ObservedObject var viewStore: ViewStore<MainCore.State, MainCore.Action>
    
    init(store: Store<MainCore.State, MainCore.Action>) {
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
                    ForEach(viewStore.todos, id: \.id) { todo in
                        if !todo.isInvalidated && !todo.isFrozen {
                            NavigationLink {
                                AddView(store: addStore)
                            } label: {
                                TodoItem(todo)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Todos")
            .toolbar {
                NavigationLink {
                    AddView(store: self.addStore)
                } label: {
                    Text("할일")
                }
            }
        }
    }
}

//extension IdentifiedArray where ID == Todo.State.ID, Element == Todo.State {
//    static let mock: Self = [
//        Todo.State(
//            description: "Check Mail",
//            id: UUID(),
//            isComplete: false
//        ),
//        Todo.State(
//            description: "Buy Milk",
//            id: UUID(),
//            isComplete: false
//        ),
//        Todo.State(
//            description: "Call Mom",
//            id: UUID(),
//            isComplete: false
//        )
//    ]
//}

extension MainView {
    private var addStore: Store<AddCore.State, AddCore.Action> {
        return store.scope(
            state: { $0.addState },
            action: MainCore.Action.addTodoButtonTapped
        )
    }
}



//struct AppView_Proviews: PreviewProvider {
//    static var previews: some View {
//        AppView(store: Store(initialState: Todos.State(todos: .mock), reducer: {
//            Todos()
//        }))
//    }
//}
