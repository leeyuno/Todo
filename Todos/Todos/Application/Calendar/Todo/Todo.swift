//
//  Todo.swift
//  Todos
//
//  Created by 이윤오 on 2023/10/17.
//

import ComposableArchitecture
import SwiftUI

struct TodoItem: View {
    var todo: TodoEntity
    
    init(_ todo: TodoEntity) {
        self.todo = todo
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(todo.title)
                    .font(.system(size: 20))
                    .bold()
                    .lineLimit(1)
                Text(todo.date, style: .date)
                    .font(.system(size: 16))
                    .padding(.top, 12)
            }
            Spacer()
        }
        .padding()
        .background(Color(todo.color))
        .cornerRadius(15)
    }
}
