//
//  AddCore.swift
//  Todos
//
//  Created by Hanna Shin's iMac on 1/10/24.
//

import ComposableArchitecture
import SwiftUI

struct AddCore: Reducer {
    struct State: Equatable {
        let id: UUID
        @BindingState var title: String = ""
        @BindingState var color: String = ""
        @BindingState var location: String = ""
        @BindingState var date: String = ""
    }
    
    enum Action: BindableAction, Equatable, Sendable {
        case binding(BindingAction<State>)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            }
        }
    }
}
