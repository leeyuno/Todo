//
//  GOCalendarCell.swift
//  Todos
//
//  Created by Hanna Shin's iMac on 3/7/24.
//

import SwiftUI

struct GOCalendarCell: View {
    var day: String
    var color: Color
    var date: Date
    @State var isSelected: Bool = false
    
    var items: [String] = []
    
    var body: some View {
        VStack {
            Text(day)
                .foregroundStyle(color)
            
            LazyVGrid(columns: Array(repeating: GridItem(), count: 4), content: {
                ForEach(Array(zip(items.indices, items)), id: \.0) { index, color in
                    Circle()
                        .foregroundStyle(Color(color))
                }
            })
            
//            Circle()
//                .frame(width: 5, height: 5)
//                .backgroundStyle(.pink)
//                .opacity(isSelected ? 1.0 : 0.0)
        }
//        .frame(width: .infinity, height: .infinity)
//        .overlay(
//            RoundedRectangle(cornerRadius: 2).stroke(.blue, lineWidth: 1.0)
//        )
//        .frame(width: .infinity, height: .infinity)
//        .border(.red, width: 1)
        
    }
}

#Preview {
    GOCalendarCell(day: "1", color: .black, date: Date(), items: ["Company", "Company", "Family", "Etc", "Personal", "Company"])
        .frame(width: 50, height: 50)
}

