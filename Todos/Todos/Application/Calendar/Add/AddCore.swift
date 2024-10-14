import ComposableArchitecture
import SwiftUI
import RealmSwift

enum Priority: Int {
    case emergency = 1
    case high = 2
    case middle = 3
    case low = 4
}

enum RemindTime: String {
    case hour = "1시간 전"
    case halfHour = "30분 전"
    case quarterHour = "15분 전"
    case immediately = "시작"
    
    var time: Int {
        switch self {
        case .hour: return 60
        case .halfHour: return 30
        case .quarterHour: return 15
        case .immediately: return 1
        }
    }
}

struct AddCore: Reducer {
    struct State: Equatable {
        let id: UUID
        
        @BindingState var useLocation = false
        @BindingState var usePriority = false
        @BindingState var useColor = false
        @BindingState var useAlarm = false
        @BindingState var useDaily = false
        
        @BindingState var todo = ""
        @BindingState var date = Date()
        @BindingState var location = ""
        @BindingState var priority = ""
        @BindingState var alarm = ""
        @BindingState var color = "blue"
        @BindingState var daily = false
        
        @BindingState var isCompleted = false
        
        var alert: AlertState<Action>?
    }
    
    enum Action: BindableAction, Equatable, Sendable {
        case binding(BindingAction<State>)
        case useLocation
        case usePriority
        case useColor
        case useAlarm
        case useDaily
        case changeColor(Color)
        case save
        case disappear
    }
    
    @Dependency(\.realmClient) var realmClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            
            case .useLocation:
                state.useLocation.toggle()
                return .none
                
            case .usePriority:
                state.usePriority.toggle()
                return .none
                
            case .useColor:
                state.useColor.toggle()
                return .none
                
            case .useAlarm:
                state.useAlarm.toggle()
                return .none
                
            case .useDaily:
                state.useDaily.toggle()
                return .none
                
            case let .changeColor(color):
                state.color = color.description
                return .none
                
            case .save:
                let reminderTime = RemindTime(rawValue: state.alarm)?.time ?? 0

                let todo = TodoEntity(value: [
                    "title": state.todo,
                    "date": state.date,
                    "location": state.location,
                    "priority": state.priority,
                    "alarm": reminderTime,
                    "color": state.color,
                    "daily": state.daily
                ])
                
                realmClient.addTodo(todo)
                state.isCompleted = true
                return .none
                
            case .disappear:
                state = State(id: state.id) // 상태 초기화
                return .none
            }
        }
    }
}
