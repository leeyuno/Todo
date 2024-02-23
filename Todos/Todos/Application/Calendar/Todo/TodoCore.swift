//
//  TodoCore.swift
//  Todos
//
//  Created by 이윤오 on 2023/11/07.
//

import ComposableArchitecture
import SwiftUI

struct TodoCore: Reducer {
    struct State: Equatable, Identifiable {
        var description = ""
        let id: UUID
        @BindingState var isComplete = false
    }
    
    enum Action: BindableAction, Equatable, Sendable {
        case binding(BindingAction<State>)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
    }
}
