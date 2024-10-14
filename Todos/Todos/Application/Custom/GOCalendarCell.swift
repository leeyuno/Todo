import SwiftUI

struct GOCalendarCell: View {
    var day: String
    var color: Color
    var date: Date
    var isSelected: Bool = false
    var items: [String] = []

    var body: some View {
        VStack(spacing: 4) {
            Text(day)
                .foregroundColor(color)
                .frame(height: 20)
                .padding(.top, 8)

            // 일정 항목을 그리드 형태로 표시
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 5, maximum: 5), spacing: 4), count: 4)) {
                ForEach(items.prefix(4), id: \.self) { item in
                    Circle()
                        .frame(width: 5, height: 5)
                        .foregroundStyle(Color(item))
                }
            }

            Spacer()
        }
        .padding(4)
        .background(isSelected ? Color.purple.opacity(0.2) : Color.clear)
        .cornerRadius(8)
    }
}

#Preview {
    GOCalendarCell(
        day: "1",
        color: .black,
        date: Date(),
        isSelected: true,
        items: ["red", "blue", "green", "yellow"]
    )
    .frame(width: 50, height: 50)
}
