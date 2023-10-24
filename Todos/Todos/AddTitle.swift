//
//  AddTitle.swift
//  Todos
//
//  Created by 이윤오 on 2023/10/20.
//

import SwiftUI
import ComposableArchitecture

struct AddTitle: Reducer {
    struct State: Equatable {
        @BindingState var title: String = ""
    }
    
    enum Action: BindableAction, Equatable, Sendable {
        case binding(BindingAction<State>)
        case next(String)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case let .next(title):
                
                
                return .none
            }
        }
    }
}


struct AddTitleView: View {
    let store: StoreOf<AddTitle>
    let plabeHolder = "할일을 입력해주세요"
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                VStack(alignment: .center, spacing: 20) {
                    Text("어떤 계획이 있으신가요?")
                    
                    TextEditor(text: viewStore.$title)
                }
            }
            .toolbar {
                Button("Next") { viewStore.send(.next(viewStore.title), animation: .default) }
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
        }
    }
}
