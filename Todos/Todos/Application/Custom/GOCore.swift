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
        case dateSelected(Int)
        case calendarDateSelected(Date)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case let .fetchCalendar(date):
                state.currentDate = currentDateFormatted()
                
                return EffectTask.run { send in
                    let todoItems = await fetchTodos()
                    let calendarItems = getCalendarItem(date: date, todo: todoItems)
                    
                    await send(.updateCalendarItems(calendarItems))
                }

            case let .updateCalendarItems(items):
                state.items = items
                if let firstIndex = items.firstIndex(where: { checkToday(date: $0.date) }) {
                    state.selectedDate = firstIndex
                }
                return .none

            case .previous:
                if let previousMonth = previousMonth(from: state.currentDate) {
                    state.currentDate = previousMonth
                    let calendarItems = getCalendarItem(date: previousMonthDate(from: state.currentDate), todo: fetchTodos())
                    state.items = calendarItems
                }
                return .none

            case .next:
                if let nextMonth = nextMonth(from: state.currentDate) {
                    state.currentDate = nextMonth
                    let calendarItems = getCalendarItem(date: nextMonthDate(from: state.currentDate), todo: fetchTodos())
                    state.items = calendarItems
                }
                return .none

            case let .dateSelected(index):
                state.selectedDate = index
                let date = state.items[index].date ?? Date()
                return Effect.send(.calendarDateSelected(date))

            case .calendarDateSelected:
                return .none
            }
        }
    }
    
    // Helper functions to get previous/next months
    private func previousMonth(from currentDate: String) -> String? {
        guard let date = dateFormatter().date(from: currentDate) else { return nil }
        return dateFormatter().string(from: Calendar.current.date(byAdding: .month, value: -1, to: date) ?? date)
    }

    private func nextMonth(from currentDate: String) -> String? {
        guard let date = dateFormatter().date(from: currentDate) else { return nil }
        return dateFormatter().string(from: Calendar.current.date(byAdding: .month, value: 1, to: date) ?? date)
    }

    private func previousMonthDate(from currentDate: String) -> Date {
        return dateFormatter().date(from: currentDate) ?? Date()
    }

    private func nextMonthDate(from currentDate: String) -> Date {
        return dateFormatter().date(from: currentDate) ?? Date()
    }

    // Format the current date for display in UI
    private func currentDateFormatted() -> String {
        return dateFormatter(format: "yyyy년 MM월").string(from: Date())
    }
    
    // Check if a given date is today
    private func checkToday(date: Date?) -> Bool {
        return dateFormatter(format: "yyyy-MM-dd").string(from: date ?? Date()) == dateFormatter(format: "yyyy-MM-dd").string(from: Date())
    }

    // DateFormatter with default format
    private func dateFormatter(format: String = "yyyy-MM-dd") -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }
    
    // Mocking function to fetch todos (Async simulation)
    private func fetchTodos() async -> [TodoList] {
        // Mock data fetching. Replace with your Realm logic
        return []
    }

    // Function to generate calendar items
    private func getCalendarItem(date: Date, todo: [TodoList]) -> [GOCalendarItem] {
        var result = [GOCalendarItem]()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .year], from: date)
        let range = calendar.range(of: .day, in: .month, for: date) ?? 1..<30
        let firstWeekDay = date.firstWeekDay
        let lastWeekDay = date.lastWeekDay

        // Generate current month days
        for i in range {
            if let day = calendar.date(bySetting: .day, value: i, of: date) {
                result.append(GOCalendarItem(date: day, title: "\(i)", items: nil, isCurrentMonth: true))
            }
        }

        // Fill in previous month days
        if firstWeekDay != 1, let firstDay = date.startOfMonth {
            for i in 1..<firstWeekDay {
                let previousDay = calendar.date(byAdding: .day, value: -i, to: firstDay) ?? Date()
                result.insert(GOCalendarItem(date: previousDay, title: "\(calendar.component(.day, from: previousDay))", items: nil, isCurrentMonth: false), at: 0)
            }
        }

        // Fill in next month days
        if lastWeekDay != 7, let lastDay = date.endOfMonth {
            for i in 1..<(8 - lastWeekDay) {
                let nextDay = calendar.date(byAdding: .day, value: i, to: lastDay) ?? Date()
                result.append(GOCalendarItem(date: nextDay, title: "\(calendar.component(.day, from: nextDay))", items: nil, isCurrentMonth: false))
            }
        }

        // Filter todos by matching dates
        return result.map { item in
            let filteredTodo = todo.filter { dateFormatter().string(from: $0.section ?? "") == dateFormatter().string(from: item.date ?? Date()) }
            var newItem = item
            newItem.items = filteredTodo.first?.todo?.compactMap { $0.color }
            return newItem
        }
    }
}
