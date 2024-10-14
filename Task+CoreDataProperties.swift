//
//  Task+CoreDataProperties.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 14.10.2024.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var content: String
    @NSManaged public var isCompleted: Bool
    @NSManaged public var dueDate: Date
    @NSManaged public var id: UUID
    @NSManaged public var subtasks: NSSet

}

// MARK: Generated accessors for subtasks
extension Task {

    @objc(addSubtasksObject:)
    @NSManaged public func addToSubtasks(_ value: Subtask)

    @objc(removeSubtasksObject:)
    @NSManaged public func removeFromSubtasks(_ value: Subtask)

    @objc(addSubtasks:)
    @NSManaged public func addToSubtasks(_ values: NSSet)

    @objc(removeSubtasks:)
    @NSManaged public func removeFromSubtasks(_ values: NSSet)

}

extension Task : Identifiable {

}
