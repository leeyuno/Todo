//
//  Todo.swift
//  Todo
//
//  Created by 이윤오 on 2022/11/03.
//

import Foundation

import RealmSwift

class Todo: Object {
    @objc dynamic var title: String?
    @objc dynamic var type: String?
    @objc dynamic var priority: String?
    @objc dynamic var date: Date?
}

class TodoDataStore {
    static let shared = TodoDataStore()
    let realm = try! Realm()
    
    func write(_ todo: Todo, completion: (Bool) -> ()) {
        do {
            try realm.write {
                realm.add(todo)
                completion(true)
            }
        } catch {
            completion(false)
            print("Write error")
        }
    }
    
    func fetch() -> [Todo] {
        removePastTodo()
        
        let todo = realm.objects(Todo.self)
        
        return todo.compactMap { $0 }
    }
    
    func update(_ todo: Todo) {
//        do {
//            try realm.write {
//
//            }
//        } catch {
//            print("Write error")
//        }
    }
    
    func delete(_ todo: Todo) {
        do {
            try realm.write {
                realm.delete(todo)
            }
        } catch {
            print("Delete Error")
        }
    }
    
    func removePastTodo() {
        let todo = realm.objects(Todo.self)
        let list = todo.compactMap { $0 }.filter { $0.date!.timeIntervalSinceNow < 0 }
        let realm = try! Realm()
        
        do {
            try realm.write {
                list.forEach {
                    realm.delete($0)
                }
            }
        } catch {
            print("erroree")
        }
    }
}

//struct Todo: Hashable, Codable, Identifiable {
//    var id: Int
//    var title: String
//    var priority: Int
//}
