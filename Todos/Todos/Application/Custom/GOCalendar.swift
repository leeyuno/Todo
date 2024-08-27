//
//  GOCalendar.swift
//  Todos
//
//  Created by Hanna Shin's iMac on 3/7/24.
//

import ComposableArchitecture
import SwiftUI

struct GOCalendarItem: Codable, Equatable {
    var date: Date?     // cell 별로 실제 날짜
    var title: String?      // cell에 표시할 day
    var items: [String]?        // 등록된 할일들
    var isCurrentMonth: Bool?       // 전달 or 다음 달 인지 체크
//    var badges: [Color]?
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
                HStack(alignment: .center, spacing: 0) {
                    Button {
    //                    viewStore.send(.previous)
                    } label: {
                        Image(systemName: "chevron.left")
                            .frame(width: 50, height: 50)
                    }
                    .onTapGesture {
                        viewStore.send(.previous)
                    }
                    .padding()
                    
                    Text(viewStore.state.currentDate)
                    
                    Button {
    //                    viewStore.send(.next)
                    } label: {
                        Image(systemName: "chevron.right")
                            .frame(width: 50, height: 50)
                    }
                    .onTapGesture {
                        viewStore.send(.next)
                    }
                    .padding()
                }
                .frame(width: geo.size.width, height: 50, alignment: .center)
//                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50, alignment: .center)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 35, maximum: 50)), count: 7), content: {
                    Section {
                        ForEach(viewStore.weeks, id: \.self) { week in
                            Text(week)
                                .font(.caption)
                        }
                    }
                    .padding(.bottom, 30)
                    
                    Section {
                        ForEach(Array(zip(viewStore.state.items.indices, viewStore.state.items)), id: \.0) { index, item in
                            GOCalendarCell(
                                day: item.title ?? "",
                                color: item.isCurrentMonth == true ? Double(index).truncatingRemainder(dividingBy: 7.0) == 0 ? .red : Double(index + 1).truncatingRemainder(dividingBy: 7.0) == 0 ? .blue : .black : .gray,
                                date: item.date ?? Date(),
                                isSelected: index == viewStore.state.selectedDate,
                                items: item.items ?? []
                            )
                            .frame(width: geo.size.width / 7, height: geo.size.width / 7)
                            .border(index == viewStore.state.selectedDate ? Color.purple : Color.clear, width: 1.5)
                            .onTapGesture {
                                viewStore.send(.selectedDate(index))
                            }
                        }
                    }
                })
                .padding()
            }
            .onAppear {
                viewStore.send(.fetchCalendar(Date()))
            }
        }
        .padding()
        
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
