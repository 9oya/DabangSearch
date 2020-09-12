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
    
    // MARK: GET Services
    func getRooms(roomTypes: [Int] = [0, 1, 2, 3], sellTypes: [Int] = [0, 1, 2], isPriceSortAscended: Bool = true) -> [Room]? {
        let fetchRequest: NSFetchRequest<Room> = Room.fetchRequest()
        
        // Filtering
        let roomTypeArgArr: [Any] = [#keyPath(Room.roomType)] + roomTypes
        let roomTypePredicate = NSPredicate(format: "%K = %@", argumentArray: roomTypeArgArr)
        
        let sellTypeArgArr: [Any] = [#keyPath(Room.sellingType)] + sellTypes
        let sellTypePredicate = NSPredicate(format: "%K = %@", argumentArray: sellTypeArgArr)
        
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [roomTypePredicate, sellTypePredicate])
        
        fetchRequest.predicate = andPredicate
        
        // Sorting
        let priceSort = NSSortDescriptor(key: #keyPath(Room.priceTitle), ascending: isPriceSortAscended)
        fetchRequest.sortDescriptors = [priceSort]
        
        // Execute
        let results: [Room]?
        do {
            results = try managedObjContext.fetch(fetchRequest)
        } catch {
            return nil
        }
        return results
    }
}
