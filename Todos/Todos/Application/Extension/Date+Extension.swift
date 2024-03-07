//
//  Date+Extension.swift
//  Todos
//
//  Created by Hanna Shin's iMac on 3/7/24.
//

import Foundation

extension Date {
    var startOfMonth: Date? {
        let date = Calendar.current.dateComponents([.year, .month], from: self)
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let year = date.year, let month = date.month else { return nil }
        return dateFormatter.date(from: "\(year)-\(month)-01")
    }
    
    var endOfMonth: Date? {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth ?? Date())
    }
    
    var firstWeekDay: Int {
        let calendar = Calendar.current
        if let startDay = self.startOfMonth {
            if let startWeekDay = calendar.dateComponents([.weekday], from: startDay).weekday {
                return startWeekDay == 1 ? 7 : startWeekDay - 1
            }
        }
        
        return 0
    }
    
    var lastWeekDay: Int {
        let calendar = Calendar.current
        if let startDay = self.endOfMonth {
            if let startWeekDay = calendar.dateComponents([.weekday], from: startDay).weekday {
                return startWeekDay == 1 ? 7 : startWeekDay - 1
            }
        }
        
        return 0
    }
}
