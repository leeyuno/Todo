import ComposableArchitecture
import SwiftUI

struct TodoItem: View {
    var todo: [TodoEntity]
    
    init(_ todo: [TodoEntity]) {
        self.todo = todo
    }
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(todo, id: \.self) { todo in
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(todo.title)
                            .font(.system(size: 20))
                            .bold()
                            .lineLimit(1)
                        Text(todo.date, style: .date)
                            .font(.system(size: 16))
                    }
                    Spacer()
                }
                .padding()
                .background(Color(todo.color))
                .cornerRadius(10)
            }
        }
        .padding()  // 전체 뷰에 여유 공간을 추가
    }
}
