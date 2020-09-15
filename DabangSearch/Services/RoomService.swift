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
    func createRoom(desc: String, isCheck: Bool, price: Int32, roomType: Int16, sellingType: Int16, imgUrl: String) -> Room {
        let room = Room(context: managedObjContext)
        room.desc = desc
        room.isCheck = isCheck
        room.price = price
        room.roomType = roomType
        room.sellingType = sellingType
        room.imgUrl = imgUrl
        managedObjContext.perform {
            self.coreDataStack.saveContext(self.managedObjContext)
        }
        return room
    }
    
    // MARK: GET Services
    func getRooms(roomTypes: [Int] = [0, 1, 2, 3], sellTypes: [Int] = [0, 1, 2], isPriceSortAscended: Bool = true, keyword: String? = nil, fetchStart: Int, fetchSize: Int) -> [Room]? {
        let fetchRequest: NSFetchRequest<Room> = Room.fetchRequest()
        
        // Pagination
        fetchRequest.fetchOffset = fetchStart
        fetchRequest.fetchLimit = fetchSize
        
        // Filtering
        var andSubpredicates = [NSPredicate]()
        var orSubpredicates = [NSPredicate]()
        
        // OR: roomTypes
        for roomType in roomTypes {
            orSubpredicates.append(
                NSPredicate(format: "%K = %@", argumentArray: [#keyPath(Room.roomType), roomType])
            )
        }
        andSubpredicates.append(
            NSCompoundPredicate(type: .or, subpredicates: orSubpredicates)
        )
        
        // OR: sellingTypes
        orSubpredicates = [NSPredicate]()
        for sellType in sellTypes {
            orSubpredicates.append(
                NSPredicate(format: "%K = %@", argumentArray: [#keyPath(Room.sellingType), sellType])
            )
        }
        andSubpredicates.append(
            NSCompoundPredicate(type: .or, subpredicates: orSubpredicates)
        )
        
        // AND: roomTypes, sellingTypes
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: andSubpredicates)
        fetchRequest.predicate = andPredicate
        
        // Sorting
        let priceSort = NSSortDescriptor(key: #keyPath(Room.price), ascending: isPriceSortAscended)
        fetchRequest.sortDescriptors = [priceSort]
        
        // Execute
        let results: [Room]?
        do {
            results = try managedObjContext.fetch(fetchRequest)
        } catch {
            return nil
        }
        
        if keyword != nil {
            let jamoKeyword = Jamo.getJamo(keyword!)
            return results!.filter {
                ($0.hashTags!.allObjects as! [HashTag]).map { $0.title }.filter {
                    Jamo.getJamo($0!).contains(jamoKeyword)
                }.count > 0 ? true : false
            }
        } else {
            return results
        }
    }
}
