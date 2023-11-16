//
//  AddTitle.swift
//  Todos
//
//  Created by 이윤오 on 2023/10/20.
//

import SwiftUI
import ComposableArchitecture

struct AddTitleView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let store: Store<AddTitle.State, AddTitle.Action>
    @ObservedObject var viewStore: ViewStore<AddTitle.State, AddTitle.Action>
    
    init(store: Store<AddTitle.State, AddTitle.Action>) {
        self.store = store
        self.viewStore = ViewStore(self.store) { $0 }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 20) {
                Text("어떤 계획이 있으신가요?")
                    .font(.title2)
                    .bold()
                    .shadow(color: colorScheme == .dark ? .gray : .gray, radius: 0.4)
                
                TextField(
                    "할일을 입력해주세요",
                    text: Binding(
                        get: { self.viewStore.title },
                        set: { self.viewStore.send(.changeTitle($0)) }
                    )
                )
                .padding()
                
                Spacer()
            }
        }
        .toolbar {
            NavigationLink {
                AddTypeView(
                    store: self.typeStore
                )
            } label: {
                Text("중요도")
            }
        }
    }
}

extension AddTitleView {
    private var typeStore: Store<AddType.State, AddType.Action> {
        return store.scope(state: { $0.typeState }, action: AddTitle.Action.next)
    }
}
