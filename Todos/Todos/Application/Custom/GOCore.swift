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
                
                let list = getTodo()
                state.currentDate = currentDate()
                state.items = getCalendarItem(date: date, todo: list)
                
                print(getCalendarItem(date: date, todo: list))
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
                        state.items = getCalendarItem(date: previousDate, todo: getTodo())
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
                        state.items = getCalendarItem(date: previousDate, todo: getTodo())
                    }
                }
                return .none
            case let .selectedDate(index):
                state.selectedDate = index
                
                return .none
            }
        }
    }
    
    private func getTodo() -> [TodoList] {
        var list = [TodoList]()
        // MARK: - 임시 Mock 데이터
        if let filePath = Bundle.main.path(forResource: "mock", ofType: "json") {
            if let jsonString = try? String(contentsOfFile: filePath) {
                if let data = jsonString.data(using: .utf8) {
                    if let jsonData = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [[String: Any]] {
                        let dateFormatter = DateFormatter()
                        var date = [String]()
                        var realmData = [TodoEntity]()
                        for json in jsonData {
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                            dateFormatter.locale = Locale(identifier: "ko_KR")
                            let todoDate = dateFormatter.date(from: json["date"] as! String)
                            var new = json
                            new.updateValue(todoDate ?? Date.now, forKey: "date")
                            date.append((json["date"] as! String).components(separatedBy: " ").first ?? "")
                            let realm = TodoEntity(value: new)
                            realmData.append(realm)
                        }
                        
                        date = Array(Set(date))
                        
                        
                        for d in date {
                            let data = realmData.filter {
                                let realmDate = $0.date
                                let dateString = dateFormatter.string(from: realmDate)
                                return dateString.hasPrefix(d)
                            }
                            
                            list.append(TodoList(section: d, todo: data))
                        }
                        return list
                    }
                }
            }
        }
        
        return []
    }
    
    private func checkToday(date: Date?) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let calendarDate = dateFormatter.string(from: date ?? Date())
        let today = dateFormatter.string(from: Date())
        
        return calendarDate == today
    }
    
    private func getCalendarItem(date: Date, todo: [TodoList]) -> [GOCalendarItem] {
        var result = [GOCalendarItem]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")

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
        
        return result.map { item in
//            todo.forEach {
//                print("///////")
//                print(dateFormatter.date(from: $0.section ?? ""))
//                print(item.date)
//            }
//            print(dateFormatter.date(from: $0.section ?? ""))
            let filteredTodo = todo.filter({ dateFormatter.date(from: $0.section ?? "") == item.date })
            var new = item
            new.items = filteredTodo.compactMap{ $0.todo?.compactMap { $0.color } }.first
            return new
        }
//        todo.forEach { t in
//            if let date = dateFormatter.date(from: t.section ?? "") {
//                let a = result.map {
//                    var new = $0
//                    
//                    if new.date == date {
//                        var filter = t.section?.filter { $0 }
//                        print("\(date) \(t.todo?.compactMap { $0.color })")
//                        new.items = t.todo?.compactMap { $0.color }
//                        return new
//                    }
//                    
//                    return new
//                }
//                result = a
//            }
//        }
        
        return result
    }
    
    private func currentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월"
        
        let date = Date()
        return dateFormatter.string(from: date)
    }
}
