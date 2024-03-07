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
    @State var isSelected: Bool = false
    
    var body: some View {
        VStack {
            Text(day)
                .foregroundStyle(color)
        }
        .frame(width: .greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        .overlay(
            RoundedRectangle(cornerRadius: 2).stroke(.blue, lineWidth: 1.0)
        )
//        .frame(width: .infinity, height: .infinity)
//        .border(.red, width: 1)
        
    }
}

#Preview {
    GOCalendarCell(day: "1", color: .black)
        .frame(width: 50, height: 50)
}

