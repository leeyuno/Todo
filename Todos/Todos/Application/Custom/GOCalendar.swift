import ComposableArchitecture
import SwiftUI

struct GOCalendarItem: Codable, Equatable {
    var date: Date?
    var title: String?
    var items: [String]?
    var isCurrentMonth: Bool?
}

struct GOCalendar: View {
    let store: Store<GOCore.State, GOCore.Action>
    @ObservedObject var viewStore: ViewStore<GOCore.State, GOCore.Action>
    
    init(store: Store<GOCore.State, GOCore.Action>) {
        self.store = store
        self.viewStore = ViewStore(self.store) { $0 }
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center, spacing: 0) {
                headerView(geo: geo)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                    ForEach(viewStore.weeks, id: \.self) { week in
                        Text(week)
                            .font(.caption)
                    }
                    
                    ForEach(Array(zip(viewStore.state.items.indices, viewStore.state.items)), id: \.0) { index, item in
                        GOCalendarCell(
                            day: item.title ?? "",
                            color: getItemColor(for: index, isCurrentMonth: item.isCurrentMonth ?? false),
                            date: item.date ?? Date(),
                            isSelected: index == viewStore.state.selectedDate,
                            items: item.items ?? []
                        )
                        .frame(width: geo.size.width / 7, height: geo.size.width / 7)
                        .border(index == viewStore.state.selectedDate ? Color.purple : Color.clear, width: 1.5)
                        .onTapGesture {
                            viewStore.send(.dateSelected(index))
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                viewStore.send(.fetchCalendar(Date()))
            }
        }
        .padding()
    }
    
    // MARK: - Header View
    private func headerView(geo: GeometryProxy) -> some View {
        HStack {
            Button(action: { viewStore.send(.previous) }) {
                Image(systemName: "chevron.left")
                    .frame(width: 50, height: 50)
            }
            .padding()
            
            Spacer()
            
            Text(viewStore.currentDate)
            
            Spacer()
            
            Button(action: { viewStore.send(.next) }) {
                Image(systemName: "chevron.right")
                    .frame(width: 50, height: 50)
            }
            .padding()
        }
        .frame(width: geo.size.width, height: 50)
    }
    
    // MARK: - Get Item Color
    private func getItemColor(for index: Int, isCurrentMonth: Bool) -> Color {
        if isCurrentMonth {
            return Double(index).truncatingRemainder(dividingBy: 7.0) == 0 ? .red :
                   Double(index + 1).truncatingRemainder(dividingBy: 7.0) == 0 ? .blue : .black
        } else {
            return .gray
        }
    }
}

#Preview {
    GOCalendar(
        store: Store(initialState: GOCore.State(), reducer: {
            GOCore()
        })
    )
    .frame(width: .infinity, height: 500)
}
