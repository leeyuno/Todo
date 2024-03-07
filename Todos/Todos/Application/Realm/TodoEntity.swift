//
//  TodoEntity.swift
//  Todos
//
//  Created by 이윤오 on 2023/10/20.
//

import Foundation
import SwiftUI
import RealmSwift

class TodoEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String = ""
    @Persisted var date: Date = Date.now
    @Persisted var color: String = ""
    @Persisted var isComplete: Bool = false
    @Persisted var daily: Bool = false
    @Persisted var priority: String = ""
    @Persisted var location: String = ""
    @Persisted var alarm: Int = 0
}

enum ConstantColor: String {
    case red
    case blue
    case yellow
    case pink
    case purple
    case green
    
    var color: Color {
        switch self {
        case .red:
            return .red
        case .blue:
            return .blue
        case .yellow:
            return .yellow
        case .pink:
            return .pink
        case .purple:
            return .purple
        case .green:
            return .green
        }
    }
}
