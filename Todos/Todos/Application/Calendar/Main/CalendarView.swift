//
//  Todos.swift
//  Todos
//
//  Created by 이윤오 on 2023/10/17.
//

import ComposableArchitecture
@preconcurrency import SwiftUI

struct CalendarView: View {
    let store: Store<CalendarCore.State, CalendarCore.Action>
    @ObservedObject var viewStore: ViewStore<CalendarCore.State, CalendarCore.Action>
    
    init(store: Store<CalendarCore.State, CalendarCore.Action>) {
        self.store = store
        self.viewStore = ViewStore(self.store) { $0 }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    
                }
                
                Section {
                    ForEach(viewStore.todos, id: \.id) { todo in
                        NavigationLink {
                            AddView(store: addStore)
                        } label: {
                            TodoItem(todo)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                viewStore.send(.delete(IndexSet(integer: 0)))
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .refreshable {
                viewStore.send(.fetchAllTodos)
            }
            .onAppear {
                print("onAppear")
                viewStore.send(.fetchAllTodos)
            }
        }
        .navigationTitle("Calendar")
        .toolbar {
            NavigationLink {
                AddView(store: self.addStore)
            } label: {
                Image(systemName: "plus")
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

extension CalendarView {
    private var addStore: Store<AddCore.State, AddCore.Action> {
        return store.scope(
            state: { $0.addState },
            action: CalendarCore.Action.addTodoButtonTapped
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
