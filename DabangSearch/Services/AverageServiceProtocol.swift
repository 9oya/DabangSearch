//
//  AverageServiceProtocol.swift
//  DabangSearch
//
//  Created by Eido Goya on 2020/09/11.
//  Copyright © 2020 Dymm. All rights reserved.
//

import Foundation

protocol AverageServiceProtocol {
    
    // MARK: CREATE Services
    func createAverage(monthPrice: String, name: String, yearPrice: String)
    
    // MARK: GET Services
    func getAverage() -> Average?
}
