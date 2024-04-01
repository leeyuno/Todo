//
//  AddCore.swift
//  Todos
//
//  Created by Hanna Shin's iMac on 1/10/24.
//

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
        case .hour:
            return 60
        case .halfHour:
            return 30
        case .quarterHour:
            return 15
        case .immediately:
            return 1
        }
    }
}

struct AddCore: Reducer {
    struct State: Equatable {
        let id: UUID
        
        @BindingState var useLocation: Bool = false
        @BindingState var usePriority: Bool = false
        @BindingState var useColor: Bool = false
        @BindingState var useAlarm: Bool = false
        @BindingState var useDaily: Bool = false
        
        @BindingState var todo: String = ""
        @BindingState var date: Date = .now
        @BindingState var location: String = ""
        @BindingState var priority: String = ""
        @BindingState var alarm: String = ""
        @BindingState var color: String = "blue"
        @BindingState var daily: Bool = false
        
        @BindingState var isCompleted: Bool = false
        
        var alert: AlertState<Action>?
    }
    
    enum Action: BindableAction, Equatable, Sendable {
        case binding(BindingAction<State>)
        case useLocation
        case usePrioity
        case useColor
        case useAlarm
        case useDaily
        case changeColor(Color)
        case save
        case disappear
    }
    
    @Dependency(\.realmClient) var realmClient // RealmClient 의존성 주입
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .useLocation:
                state.useLocation.toggle()
                return .none
            case .usePrioity:
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
//                if color == .red {
//                    state.color = "red"
//                } else if color == .orange {
//                    state.color = "orange"
//                } else if color == .yellow {
//                    state.color = "yellow"
//                } else if color == .green {
//                    state.color = "green"
//                } else if color == .blue {
//                    state.color = "blue"
//                }
                return .none
            case .save:
                var time = 0
                if let reminder = RemindTime(rawValue: state.alarm) {
                    time = reminder.time
                }

                let todo = TodoEntity(value: [
                    "title": state.todo,
                    "date": state.date,
                    "location": state.location,
                    "priority": state.priority,
                    "alarm": time,
                    "color": state.color,
                    "daily": state.daily
                ])
                
                realmClient.addTodo(todo)
                
                return .none
            case .disappear:
                state.todo = ""
                state.date = Date()
                state.location = ""
                state.priority = ""
                state.alarm = ""
                state.color = "red"
                state.daily = false
                return .none
            }
        }
    }
}
