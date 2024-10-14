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
        var goState = GOCore.State(date: Date())
        
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
        case binding(BindingAction<State>)
        case fetchAllTodos
        case sortTodos
        case addTodoButtonTapped(AddCore.Action)
        case delete(IndexSet)
        case goCalendar(GOCore.Action)
        case calendarDateSelected(Date)
    }

    @Dependency(\.realmClient) var realmClient
    @Dependency(\.mainQueue) var mainQueue  // TCA 내장 타임라인 주입
    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .fetchAllTodos:
                // Realm에서 Todos 데이터를 비동기적으로 불러오는 부분
                return EffectTask.run { send in
                    let todos = await realmClient.findAllTodo()
                    await send(.sortTodos(todos))
                }
                
            case let .sortTodos(todos):
                // 날짜별로 할 일을 정렬하는 로직
                state.todos = todos
                state.todoList = sortTodosIntoSections(todos: todos)
                return .none

            case .addTodoButtonTapped:
                return .none

            case .binding:
                return .none

            case let .delete(indexSet):
                // Realm에서 삭제하는 부분 추가 가능
                return .none

            case .goCalendar:
                return .none

            case let .calendarDateSelected(date):
                print(date)
                return .none
            }
        }
        
        Scope(state: \.addState, action: /Action.addTodoButtonTapped) {
            AddCore()
        }
        
        Scope(state: \.goState, action: /Action.goCalendar) {
            GOCore()
        }
    }

    // Todo 항목을 섹션으로 그룹화하고 정렬하는 함수
    private func sortTodosIntoSections(todos: [TodoEntity]) -> [TodoList] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // 날짜별로 그룹화
        let groupedTodos = Dictionary(grouping: todos) { todo in
            dateFormatter.string(from: todo.date)
        }
        
        // 섹션 리스트 생성 후, 날짜순으로 정렬
        var list = groupedTodos.map { section, todos in
            TodoList(section: section, todo: todos)
        }
        
        list = list.filter {
            let sectionDate = dateFormatter.date(from: $0.section ?? "") ?? Date()
            return sectionDate >= Date()
        }
        
        list.sort {
            (dateFormatter.date(from: $0.section ?? "") ?? Date()) <
            (dateFormatter.date(from: $1.section ?? "") ?? Date())
        }
        
        return list
    }
}
