//
//  Person+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Aaron Cleveland on 9/5/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var age: Int64
    @NSManaged public var gender: String?
    @NSManaged public var name: String?
    @NSManaged public var family: Family?

}
