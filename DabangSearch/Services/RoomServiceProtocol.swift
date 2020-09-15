//
//  RoomServiceProtocol.swift
//  DabangSearch
//
//  Created by Eido Goya on 2020/09/11.
//  Copyright © 2020 Dymm. All rights reserved.
//

import Foundation

protocol RoomServiceProtocol {
    
    // MARK: CREATE Services
    func createRoom(desc: String, isCheck: Bool, price: Int32, roomType: Int16, sellingType: Int16, imgUrl: String) -> Room
    
    // MARK: GET Services
    func getRooms(roomTypes: [Int], sellTypes: [Int], isPriceSortAscended: Bool, keyword: String?, fetchStart: Int, fetchSize: Int) -> [Room]?
}
