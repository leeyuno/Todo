//
//  GOCalendar.swift
//  Todos
//
//  Created by Hanna Shin's iMac on 3/7/24.
//

import SwiftUI

struct GOCalendar: View {
    private func numberOfDays(date: Date) -> [Int] {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        let totalCount = calendar.range(of: .day, in: .month, for: date)?.count ?? 0
        let firstWeekDay = date.firstWeekDay
        let lastWeekDay = date.lastWeekDay
        
        var result: [Int] = (1 ... totalCount).map { $0 }
        
        if firstWeekDay != 1 {
            if let previousMonth = calendar.date(byAdding: .month, value: -1, to: date)?.endOfMonth {
                if let day = calendar.dateComponents([.day], from: previousMonth).day {
                    for i in 0 ..< firstWeekDay {
                        result.insert(day - i, at: 0)
                    }
                }
            }
            
        }
        
        if lastWeekDay != 7 {
            
        }

        return result
    }
    
    private func startWeek(date: Date) -> Int {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        let components = calendar.dateComponents([.year, .month], from: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let year = components.year, let month = components.month {
            let firstDate = "\(year)-\(month)-01"
            if let d = dateFormatter.date(from: firstDate) {
                if let weekday = calendar.dateComponents([.weekday], from: d).weekday {
                    print(weekday)
                    return weekday
                }
            }
        }
            
        return 0
    }
    
    private let weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    
    var body: some View {
        let numberOfDays = numberOfDays(date: Date())
        let firstWeekday = startWeek(date: Date())
        
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7), content: {
            Section {
                ForEach(weeks, id: \.self) { week in
                    Text(week)
                        .font(.caption)
                }
            }
            .padding(.bottom, 30)
            
            Section {
                ForEach(Array(zip(numberOfDays.indices, numberOfDays)), id: \.0) { index, day in
                    GOCalendarCell(day: String(day), color: index >= firstWeekday ? Double(index).truncatingRemainder(dividingBy: 7.0) == 0 ? .red : Double(index + 1).truncatingRemainder(dividingBy: 7.0) == 0 ? .blue : .black : .gray)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 2).stroke(.blue, lineWidth: 1)
//                        )
                        .padding(.bottom, 25)
//                    Text("\(day)")
//                        .foregroundStyle(index >= firstWeekday ? Double(index).truncatingRemainder(dividingBy: 7.0) == 0 ? .red : Double(index + 1).truncatingRemainder(dividingBy: 7.0) == 0 ? .blue : .black : .gray)
//                        .padding(.bottom, 25)
                }
            }
        })
//        .frame(width: .greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        .padding()
    }
}

#Preview {
    GOCalendar()
        .frame(width: .infinity, height: 500)
}
