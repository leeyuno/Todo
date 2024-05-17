//
//  GOCore.swift
//  Todos
//
//  Created by Hanna Shin's iMac on 3/7/24.
//

import ComposableArchitecture
import SwiftUI

struct GOCore: Reducer {
    struct State: Equatable {
        @BindingState var date = Date()
        var items: [GOCalendarItem] = []
        let weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
        @BindingState var currentDate: String = ""
        var selectedDate: Int = 0
    }
    
    enum Action: BindableAction, Equatable, Sendable {
        case binding(BindingAction<State>)
        case fetchCalendar(Date)
        case previous
        case next
        case selectedDate(Int)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case let .fetchCalendar(date):
                state.currentDate = currentDate()
                state.items = getCalendarItem(date: date)
                
                if let firstIndex = state.items.firstIndex(where: { checkToday(date: $0.date) }) {
                    state.selectedDate = firstIndex
                }
                return .none
            case .previous:
                let tmp = state.currentDate
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy년 MM월"
                if let date = dateFormatter.date(from: tmp) {
                    if let previousDate = Calendar.current.date(byAdding: .month, value: -1, to: date) {
                        let date2 = dateFormatter.string(from: previousDate)
                        state.currentDate = date2
                        state.items = getCalendarItem(date: previousDate)
                    }
                }
                
                return .none
            case .next:
                let tmp = state.currentDate
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy년 MM월"
                if let date = dateFormatter.date(from: tmp) {
                    if let previousDate = Calendar.current.date(byAdding: .month, value: 1, to: date) {
                        let date2 = dateFormatter.string(from: previousDate)
                        state.currentDate = date2
                        state.items = getCalendarItem(date: previousDate)
                    }
                }
                return .none
            case let .selectedDate(index):
                state.selectedDate = index
                
                return .none
            }
        }
    }
    
    private func checkToday(date: Date?) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let calendarDate = dateFormatter.string(from: date ?? Date())
        let today = dateFormatter.string(from: Date())
        
        return calendarDate == today
    }
    
    private func getCalendarItem(date: Date) -> [GOCalendarItem] {
        var result = [GOCalendarItem]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .year], from: date)
        
        let firstWeekDay = date.firstWeekDay
        let lastWeekDay = date.lastWeekDay

        let range = calendar.range(of: .day, in: .month, for: date)
        

        if let year = components.year, let month = components.month, let upperBound = range?.upperBound {
            for i in 1 ..< upperBound {
                let dateString = String(format: "\(year)-\(month)-%02d", i)
                if let date2 = dateFormatter.date(from: dateString) {
                    result.append(GOCalendarItem(date: date2, title: String(i), items: nil, isCurrentMonth: true))
                }
            }
            
            if firstWeekDay != 1 {
                if let firstDay = date.startOfMonth {
                    for i in 1 ..< firstWeekDay {
                        let previousDay = firstDay.addingTimeInterval(-Double((86400 * i)))
                        let day = calendar.dateComponents([.day], from: previousDay).day
                        result.insert(GOCalendarItem(date: previousDay, title: String(day ?? 0), items: nil, isCurrentMonth: false), at: 0)
                    }
                }
            }
            
            if lastWeekDay != 7 {
                if let endDate = date.endOfMonth {
                    for i in 1 ..< 8 - lastWeekDay {
                        let nextDay = endDate.addingTimeInterval(Double(86400 * i))
                        let day = calendar.dateComponents([.day], from: nextDay).day
                        result.append(GOCalendarItem(date: nextDay, title: String(day ?? 0), items: nil, isCurrentMonth: false))
                    }
                }
            }
        }
        
        return result
    }
    
    private func currentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월"
        
        let date = Date()
        return dateFormatter.string(from: date)
    }
}
