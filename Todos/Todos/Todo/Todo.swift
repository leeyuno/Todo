//
//  Todo.swift
//  Todos
//
//  Created by 이윤오 on 2023/10/17.
//

import ComposableArchitecture
import SwiftUI

struct TodoView: View {
    let store: StoreOf<Todo>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack {
                TextField("Untitled Todo", text: viewStore.$description)
            }
            .foregroundColor(viewStore.isComplete ? .gray : nil)
        }
    }
}
