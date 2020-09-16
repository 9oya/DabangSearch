//
//  HashTagService.swift
//  DabangSearch
//
//  Created by Eido Goya on 2020/09/11.
//  Copyright © 2020 Dymm. All rights reserved.
//

import CoreData

class HashTagService: HashTagServiceProtocol {
    static let shared = HashTagService(coreDataStack: CoreDataStack())
    var managedObjContext: NSManagedObjectContext
    var coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.managedObjContext = coreDataStack.mainContext
        self.coreDataStack = coreDataStack
    }
    
    // MARK: CREATE Services
    func createHashTag(room: Room, title: String, priority: Int16) -> HashTag {
        let hashTag = HashTag(context: managedObjContext)
        hashTag.title = title
        hashTag.jamo = Jamo.getJamo(title)
        hashTag.priority = priority
        hashTag.room = room
        
        room.addToHashTags(hashTag)
        
        managedObjContext.perform {
            self.coreDataStack.saveContext(self.managedObjContext)
        }
        return hashTag
    }
}
