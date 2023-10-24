//
//  TodoEntity.swift
//  Todos
//
//  Created by 이윤오 on 2023/10/20.
//

import Foundation
import RealmSwift

class TodoEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String = ""
    @Persisted var date: Date = Date.now
    @Persisted var color: String = "blue"
}

struct Constant {
    static let red = "red"
    static let blue = "blue"
    static let yellow = "yellow"
    static let pink = "pink"
    static let purple = "purple"
    static let green = "green"
}
