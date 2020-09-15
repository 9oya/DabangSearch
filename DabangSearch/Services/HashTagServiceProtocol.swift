//
//  HashTagServiceProtocol.swift
//  DabangSearch
//
//  Created by Eido Goya on 2020/09/11.
//  Copyright © 2020 Dymm. All rights reserved.
//

import Foundation

protocol HashTagServiceProtocol {
    
    // MARK: CREATE Services
    func createHashTag(room: Room, title: String, priority: Int16) -> HashTag
}
