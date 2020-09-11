//
//  AverageService.swift
//  DabangSearch
//
//  Created by Eido Goya on 2020/09/11.
//  Copyright © 2020 Dymm. All rights reserved.
//

import Foundation
import CoreData

class AverageService: AverageServiceProtocol {
    static let shared = AverageService(coreDataStack: CoreDataStack())
    var managedObjContext: NSManagedObjectContext
    var coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.managedObjContext = coreDataStack.mainContext
        self.coreDataStack = coreDataStack
    }
    
    // MARK: CREATE Services
    func createAverage(monthPrice: String, name: String, yearPrice: String) {
        let average = Average(context: managedObjContext)
        average.monthPrice = monthPrice
        average.name = name
        average.yearPrice = yearPrice
        coreDataStack.saveContext(managedObjContext)
    }
    
    // MARK: GET Services
    func getAverage() -> Average? {
        let fetchRequest: NSFetchRequest<Average> = Average.fetchRequest()
        let averages: [Average]?
        do {
            averages = try managedObjContext.fetch(fetchRequest)
        } catch {
            return nil
        }
        return averages != nil ? averages!.first : nil
    }
}
