//
//  RealmModels.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 15.10.2024.
//

import Foundation
import RealmSwift

class TaskRealmModel: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var content: String
    @Persisted var dueDate: Date
    @Persisted var isCompleted = true
    @Persisted var notificationsOn = true
    
    @Persisted(originProperty: "parentTask") var subtasks: LinkingObjects<SubtaskRealmModel>
    
    convenience init(
        id: UUID = UUID(),
        content: String,
        dueDate: Date,
        isCompleted: Bool = false,
        notificationsOn: Bool = true
    ) {
        self.init()
        self.id = id
        self.content = content
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.notificationsOn = notificationsOn
    }
}

class SubtaskRealmModel: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var content: String
    @Persisted var isCompleted = true
    
    @Persisted var parentTask: TaskRealmModel?
    
    convenience init(
        id: UUID = UUID(),
        content: String,
        isCompleted: Bool = false,
        parentTask: TaskRealmModel
    ) {
        self.init()
        self.id = id
        self.content = content
        self.isCompleted = isCompleted
        self.parentTask = parentTask
    }
}
