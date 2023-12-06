//
//  AddColorCore.swift
//  Todos
//
//  Created by 이윤오 on 2023/11/07.
//

import ComposableArchitecture
import SwiftUI

struct AddType: Reducer {
    struct State: Equatable {
        @BindingState var color: Color = .yellow
        var item = TodoEntity()
        var title: String = ""
        var timeState = AddTime.State()
        var outputColor: Color = .yellow
    }
    
    enum Action: BindableAction, Equatable, Sendable {
        case binding(BindingAction<State>)
        case next(AddTime.Action)
        case changeColor(_ newValue: Color)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.$color):
                return .none
            case .binding:
                return .none
            case let .changeColor(color):
                state.color = color
                state.timeState = AddTime.State(color: color, title: state.title)
                return .none
            case .next:
                
                return .none
            }
        }
        
        Scope(state: \.timeState, action: /Action.next) {
            AddTime()
        }
    }
}
