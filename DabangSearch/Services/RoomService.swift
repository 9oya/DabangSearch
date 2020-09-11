//
//  RoomService.swift
//  DabangSearch
//
//  Created by Eido Goya on 2020/09/11.
//  Copyright © 2020 Dymm. All rights reserved.
//

import CoreData

class RoomService: RoomServiceProtocol {
    static let shared = RoomService(coreDataStack: CoreDataStack())
    var managedObjContext: NSManagedObjectContext
    var coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.managedObjContext = coreDataStack.mainContext
        self.coreDataStack = coreDataStack
    }
    
    // MARK: CREATE Services
    func createRoom(desc: String, isCheck: Bool, priceTitle: String, roomType: Int16, sellingType: Int16, imgUrl: String) -> Room {
        let room = Room(context: managedObjContext)
        room.desc = desc
        room.isCheck = isCheck
        room.priceTitle = priceTitle
        room.roomType = roomType
        room.sellingType = sellingType
        room.imgUrl = imgUrl
        managedObjContext.perform {
            self.coreDataStack.saveContext(self.managedObjContext)
        }
        return room
    }
}
