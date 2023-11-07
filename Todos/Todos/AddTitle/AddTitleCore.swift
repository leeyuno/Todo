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
        @BindingState var title = ""
        var typeState = AddType.State()
        var item = TodoEntity()
    }
    
    enum Action: BindableAction, Equatable, Sendable {
        case binding(BindingAction<State>)
        case next(AddType.Action)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
//        Reduce { state, action in
//            switch action {
//            case .binding:
//                return .none
//            case .next:
//                return .none
//            }
//        }
    }
}
