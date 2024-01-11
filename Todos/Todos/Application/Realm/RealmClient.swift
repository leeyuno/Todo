//
//  RealmClient.swift
//  Todos
//
//  Created by Hanna Shin's iMac on 1/10/24.
//

import Foundation
import RealmSwift
import ComposableArchitecture
import XCTestDynamicOverlay


struct RealmClient {
    var findAllTodo: @Sendable() -> [TodoEntity]
    var findTodo: @Sendable(_ id: ObjectId) -> TodoEntity?
    var addTodo: @Sendable(_ todo: TodoEntity) -> Void
    var deleteTodo: @Sendable(_ id: ObjectId) -> Void
    var updateTodo: @Sendable(_ id: ObjectId, _ text: String, _ color: String) -> Void
    
}

extension DependencyValues {
    var realmClient: RealmClient {
        get { self[RealmClient.self] }
        set { self[RealmClient.self] = newValue }
    }
}

extension RealmClient: DependencyKey {
    static var liveValue = RealmClient(
        findAllTodo: {
            let realm = try! Realm(configuration: .init(schemaVersion: 2))
            let allTodo = realm.objects(TodoEntity.self).sorted(byKeyPath: "date")
            var result = [TodoEntity]()
            allTodo.forEach { todo in
                result.append(todo)
            }
            return result
        },
        findTodo: { id in
            let realm = try! Realm(configuration: .init(schemaVersion: 2))
            let todoToFind = realm.objects(TodoEntity.self).filter(NSPredicate(format: "id == %@", id))
            guard !todoToFind.isEmpty else { return nil }
            return todoToFind.first
        },
        addTodo: { todo in
            let realm = try! Realm(configuration: .init(schemaVersion: 2))
            do {
                try realm.write {
                    realm.add(todo)
                    print("Added new todo to Realm : \(todo)")
                }
            } catch {
                print("Error adding todo to Realm : \(error)")
            }
        },
        deleteTodo: { id in
            let realm = try! Realm(configuration: .init(schemaVersion: 2))
            do {
                let todoToDelete = realm.objects(TodoEntity.self).filter(NSPredicate(format: "id == %@", id))
                guard !todoToDelete.isEmpty else { return }
                
                try realm.write {
                    realm.delete(todoToDelete)
                    print("Deleted todo with id : \(id)")
                }
                
            } catch {
                print("Error deleting todo \(id) from Realm: \(error)")
            }
        },
        updateTodo: { id, text, color in
            let realm = try! Realm(configuration: .init(schemaVersion: 2))
            do {
                if let todoToUpdate = realm.objects(TodoEntity.self).filter(NSPredicate(format: "id == %@", id)).first {
                    try realm.write {
                        todoToUpdate.date = Date.now
                        todoToUpdate.title = text
                        todoToUpdate.color = color
                    }
                    print("updated todo with id : \(id)")
                }
            } catch {
                print("Error updating todo \(id) from Realm: \(error)")
            }
        }
    )
}
