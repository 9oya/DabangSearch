//
//  Average+CoreDataProperties.swift
//  
//
//  Created by Eido Goya on 2020/09/11.
//
//

import Foundation
import CoreData


extension Average {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Average> {
        return NSFetchRequest<Average>(entityName: "Average")
    }

    @NSManaged public var monthPrice: String?
    @NSManaged public var name: String?
    @NSManaged public var yearPrice: String?

}
