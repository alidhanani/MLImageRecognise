//
//  Entity+CoreDataProperties.swift
//  MLTryApp
//
//  Created by Ali Dhanani on 14/02/2019.
//  Copyright © 2019 Ali Dhanani. All rights reserved.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var value: String?
    @NSManaged public var desc: String?

}
