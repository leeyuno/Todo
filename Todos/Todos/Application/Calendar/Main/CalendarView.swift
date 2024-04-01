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
                    GOCalendar()
                }
                
                ForEach(Array(zip(viewStore.todoList.indices, viewStore.todoList)), id: \.0) { index, item in
                    
                    Section {
                        TodoItem(item.todo ?? [])
//                        NavigationLink {
//                            AddView(store: addStore)
//                        } label: {
//                            
//                        }
//                        NavigationLink {
//                            AddView(store: addStore)
//                        } label: {
//                            TodoItem(item.todo ?? [])
////                                .frame(height: item.todo.count ?? 0 * 100)
//                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                viewStore.send(.delete(IndexSet(integer: 0)))
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    } header: {
                        Text(item.section ?? "")
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

#Preview {
    CalendarView(
        store: Store(initialState: CalendarCore.State(
            todos: [
                TodoEntity(value: [
                    "title": "운동",
                    "date": Date(),
                    "color": "Personal"
                ]),
                TodoEntity(value: [
                    "title": "공부",
                    "date": Date(),
                    "color": "Personal"
                ])
            ]
        )) {
            CalendarCore()
        }
    )
}
