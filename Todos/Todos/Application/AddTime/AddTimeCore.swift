//
//  AddTimeCore.swift
//  Todos
//
//  Created by 이윤오 on 2023/11/07.
//

import ComposableArchitecture
import SwiftUI

import RealmSwift

struct AddTime: Reducer {
    struct State: Equatable {
//        @ObservedObject var item = TodoEntity()
        var color: String = "yellow"
        var title: String = ""
        var item = TodoEntity()
        @BindingState var date = Date()
        var isCompleted: Bool = false
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
                let todo = TodoEntity()
                todo.color = state.color
                todo.title = state.title
                todo.date = state.date
                
                print(todo)
//                Color.red.description
//                Color(
//                todo.
                
                state.isCompleted.toggle()
                return .none
            }
        }
    }
}
