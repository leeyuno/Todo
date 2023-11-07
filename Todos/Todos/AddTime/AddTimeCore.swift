//
//  AddTimeCore.swift
//  Todos
//
//  Created by 이윤오 on 2023/11/07.
//

import ComposableArchitecture
import SwiftUI

struct AddTime: Reducer {
    struct State: Equatable {
//        @ObservedObject var item = TodoEntity()
        var item = TodoEntity()
        @BindingState var date = Date()
    }
    
    enum Action: BindableAction, Equatable, Sendable {
        case binding(BindingAction<State>)
        case save
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .save:
                return .none
            }
        }
    }
}
