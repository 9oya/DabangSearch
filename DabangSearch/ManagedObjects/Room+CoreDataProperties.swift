//
//  Room+CoreDataProperties.swift
//  
//
//  Created by Eido Goya on 2020/09/11.
//
//

import Foundation
import CoreData


extension Room {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Room> {
        return NSFetchRequest<Room>(entityName: "Room")
    }

    @NSManaged public var desc: String?
    @NSManaged public var imgUrl: String?
    @NSManaged public var isCheck: Bool
    @NSManaged public var priceTitle: String?
    @NSManaged public var roomType: Int16
    @NSManaged public var sellingType: Int16
    @NSManaged public var hashTags: NSSet?

}

// MARK: Generated accessors for hashTags
extension Room {

    @objc(addHashTagsObject:)
    @NSManaged public func addToHashTags(_ value: HashTag)

    @objc(removeHashTagsObject:)
    @NSManaged public func removeFromHashTags(_ value: HashTag)

    @objc(addHashTags:)
    @NSManaged public func addToHashTags(_ values: NSSet)

    @objc(removeHashTags:)
    @NSManaged public func removeFromHashTags(_ values: NSSet)

}
