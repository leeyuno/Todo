//
//  Color+Extension.swift
//  Todos
//
//  Created by 이윤오 on 2023/10/20.
//

import SwiftUI

extension Color {
    var randomColor: Color {
        return [Color.red, Color.green, Color.blue, Color.yellow, Color.purple, Color.pink].randomElement() ?? Color.green
    }
}
