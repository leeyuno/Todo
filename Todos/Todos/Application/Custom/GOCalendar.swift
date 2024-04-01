//
//  GOCalendar.swift
//  Todos
//
//  Created by Hanna Shin's iMac on 3/7/24.
//

import SwiftUI

struct GOCalendarItem: Codable {
    var date: Date?     // cell 별로 실제 날짜
    var title: String?      // cell에 표시할 day
    var items: [String]?        // 등록된 할일들
    var isCurrentMonth: Bool?       // 전달 or 다음 달 인지 체크
}

struct GOCalendar: View {
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
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        let date = Date()
        return dateFormatter.string(from: date)
    }
    
    private let weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    
    var body: some View {
        let items = getCalendarItem(date: Date())
        LazyHStack(alignment: .center, spacing: 0) {
            Button {
                
            } label: {
                Image(systemName: "chevron.left")
                    .frame(width: 50, height: 50)
                    .padding()
            }
            
            Text(currentDate())
            
            Button {
                
            } label: {
                Image(systemName: "chevron.right")
                    .frame(width: 50, height: 50)
                    .padding()
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7), content: {
            Section {
                ForEach(weeks, id: \.self) { week in
                    Text(week)
                        .font(.caption)
                }
            }
            .padding(.bottom, 30)
            
            Section {
                ForEach(Array(zip(items.indices, items)), id: \.0) { index, item in
                    GOCalendarCell(
                        day: item.title ?? "",
                        color: item.isCurrentMonth == true ? Double(index).truncatingRemainder(dividingBy: 7.0) == 0 ? .red : Double(index + 1).truncatingRemainder(dividingBy: 7.0) == 0 ? .blue : .black : .gray,
                        date: item.date ?? Date()
                    )
                    .padding(.bottom, 25)
                    .onTapGesture {
                        print(items[index].date)
//                        print("\(index) : \(dd[index])")
                    }
                }
            }
        })
        .padding()
        
        
    }
}

#Preview {
    GOCalendar()
        .frame(width: .infinity, height: 500)
}
