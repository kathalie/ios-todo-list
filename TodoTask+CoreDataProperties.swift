//
//  TodoTask+CoreDataProperties.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 21.10.2024.
//
//

import Foundation
import CoreData


extension TodoTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoTask> {
        return NSFetchRequest<TodoTask>(entityName: "TodoTask")
    }

    @NSManaged public var content: String
    @NSManaged public var dueDate: Date
    @NSManaged public var id: UUID
    @NSManaged public var isCompleted: Bool
    @NSManaged public var notificationsOn: Bool
    @NSManaged public var subtasks: NSSet?

}

// MARK: Generated accessors for subtasks
extension TodoTask {

    @objc(addSubtasksObject:)
    @NSManaged public func addToSubtasks(_ value: TodoSubtask)

    @objc(removeSubtasksObject:)
    @NSManaged public func removeFromSubtasks(_ value: TodoSubtask)

    @objc(addSubtasks:)
    @NSManaged public func addToSubtasks(_ values: NSSet)

    @objc(removeSubtasks:)
    @NSManaged public func removeFromSubtasks(_ values: NSSet)

}

extension TodoTask : Identifiable {

}
