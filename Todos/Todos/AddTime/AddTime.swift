//
//  AddTime.swift
//  Todos
//
//  Created by 이윤오 on 2023/10/20.
//

import SwiftUI
import ComposableArchitecture

struct AddTimeView: View {
    let store: Store<AddTime.State, AddTime.Action>
    @ObservedObject var viewStore: ViewStore<AddTime.State, AddTime.Action>
    
    init(store: Store<AddTime.State, AddTime.Action>) {
        self.store = store
        self.viewStore = ViewStore(self.store) { $0 }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 20) {
                Text("언제 할까요?")
                DatePicker(
                    "Do it",
                    selection: self.viewStore.$date,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.graphical)
                .padding([.leading, .trailing], 15)
                Spacer()
            }
        }
    }
}
