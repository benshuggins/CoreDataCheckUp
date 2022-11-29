//
//  Person+CoreDataProperties.swift
//  CoreDataCheckUp
//
//  Created by Ben Huggins on 11/22/22.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Date?

}

extension Person : Identifiable {

}
