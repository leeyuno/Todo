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

struct TodoList: Codable, Equatable {
    var section: String?
    var todo: [TodoEntity]?
}

struct CalendarCore: Reducer {
    struct State: Equatable {
        var addState = AddCore.State(id: UUID())
        
        @BindingState var filter: Filter = .daily
        var todos: [TodoEntity] = []
        
        var todoList: [TodoList] = []
        
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
                // FIXME: 임시 Mock
                if let filePath = Bundle.main.path(forResource: "mock", ofType: "json") {
                    if let jsonString = try? String(contentsOfFile: filePath) {
                        if let data = jsonString.data(using: .utf8) {
                            if let jsonData = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [[String: Any]] {
                                let dateFormatter = DateFormatter()
                                var date = [String]()
                                var realmData = [TodoEntity]()
                                for json in jsonData {
                                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                                    dateFormatter.locale = Locale(identifier: "ko_KR")
                                    let todoDate = dateFormatter.date(from: json["date"] as! String)
                                    var new = json
                                    new.updateValue(todoDate ?? Date.now, forKey: "date")
                                    date.append((json["date"] as! String).components(separatedBy: " ").first ?? "")
                                    let realm = TodoEntity(value: new)
                                    realmData.append(realm)
                                }
                                
                                date = Array(Set(date))
                                state.todos = realmData
                                
                                var list = [TodoList]()
                                for d in date {
                                    let data = realmData.filter {
                                        let realmDate = $0.date
                                        let dateString = dateFormatter.string(from: realmDate)
                                        return dateString.hasPrefix(d)
                                    }
                                    
                                    list.append(TodoList(section: d, todo: data))
                                }
                                print(list)
                                state.todoList = list
                            }
                        }
                    }
                }
//                state.todos = realmClient.findAllTodo()
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
