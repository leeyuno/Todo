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
            GeometryReader { geo in
                List {
                    Section {
                        GOCalendar(store: self.goStore)
                            .background(.orange)
                            .frame(width: geo.size.width, height: 500)
                    }
                    
                    ForEach(Array(zip(viewStore.todoList.indices, viewStore.todoList)), id: \.0) { index, item in
                        Section {
                            TodoItem(item.todo ?? [])
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
            
//            List {
//
//            }
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

extension CalendarView {
    private var goStore: Store<GOCore.State, GOCore.Action> {
        return store.scope(
            state: { $0.goState },
            action: CalendarCore.Action.goCalendar
        )
    }
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
