//
//  TodoEntity.swift
//  Todos
//
//  Created by 이윤오 on 2023/10/20.
//

import Foundation
import SwiftUI
import RealmSwift

class TodoEntity: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String = ""
    @Persisted var date: Date = Date.now
//    @Persisted var date: String = ""
    @Persisted var color: String = "green"
    @Persisted var isComplete: Bool = false
    @Persisted var daily: Bool = false
    @Persisted var priority: String = ""
    @Persisted var location: String = ""
    @Persisted var alarm: Int = 0
}

enum ConstantColor: String {
    case company
    case personal
    case family
    case etc
    
    var color: Color {
        switch self {
        case .company:
            return Color("Company", bundle: nil)
        case .personal:
            return Color("Personal", bundle: nil)
        case .family:
            return Color("Family", bundle: nil)
        case .etc:
            return Color("Etc", bundle: nil)
        }
    }
}
