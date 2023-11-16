//
//  AddTitleCore.swift
//  Todos
//
//  Created by 이윤오 on 2023/11/07.
//

import ComposableArchitecture
import SwiftUI

struct AddTitle: Reducer {
    struct State: Equatable {
        @BindingState var text = ""
        var title: String = ""
        var typeState = AddType.State()
        var item = TodoEntity()
    }
    
    enum Action: BindableAction, Equatable, Sendable {
        case binding(BindingAction<State>)
        case changeTitle(_ newValue: String)
        case next(AddType.Action)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case let .changeTitle(title):
                
                state.title = title
                state.typeState = AddType.State(title: state.title)
                
                return .none
            case .next:
//                state.typeState = AddType.State(item: state.item, title: state.title)
                
                return .none
            }
        }
        
        Scope(state: \.typeState, action: /Action.next) {
            AddType()
        }
    }
}
