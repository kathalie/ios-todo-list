//
//  TodoSubtask+CoreDataProperties.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 16.10.2024.
//
//

import Foundation
import CoreData


extension TodoSubtask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoSubtask> {
        return NSFetchRequest<TodoSubtask>(entityName: "TodoSubtask")
    }

    @NSManaged public var content: String
    @NSManaged public var id: UUID
    @NSManaged public var isCompleted: Bool
    @NSManaged public var parentTask: TodoTask

}

extension TodoSubtask : Identifiable {

}
