//
//  Water+CoreDataProperties.swift
//  
//
//  Created by Apple on 26/03/24.
//
//

import Foundation
import CoreData


extension Water {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Water> {
        return NSFetchRequest<Water>(entityName: "Water")
    }

    @NSManaged public var time: Date?
    @NSManaged public var litre: Int16
    @NSManaged public var timestr: String
    
}
