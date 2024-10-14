//
//  Subtask+CoreDataProperties.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 14.10.2024.
//
//

import Foundation
import CoreData


extension Subtask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subtask> {
        return NSFetchRequest<Subtask>(entityName: "Subtask")
    }

    @NSManaged public var content: String
    @NSManaged public var isCompleted: Bool
    @NSManaged public var id: UUID
    @NSManaged public var parentTask: Task

}

extension Subtask : Identifiable {

}
