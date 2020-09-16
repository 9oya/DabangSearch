//
//  HashTag+CoreDataProperties.swift
//  
//
//  Created by Eido Goya on 2020/09/16.
//
//

import Foundation
import CoreData


extension HashTag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HashTag> {
        return NSFetchRequest<HashTag>(entityName: "HashTag")
    }

    @NSManaged public var priority: Int16
    @NSManaged public var title: String?
    @NSManaged public var jamo: String?
    @NSManaged public var room: Room?

}
