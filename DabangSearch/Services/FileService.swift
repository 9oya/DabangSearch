//
//  FileService.swift
//  DabangSearch
//
//  Created by Eido Goya on 2020/09/11.
//  Copyright © 2020 Dymm. All rights reserved.
//

import Foundation

final class FileService: FileServiceProtocol {
    static let shared = FileService()
    
    func importRoomsJSONSeedData() {
        let jsonURL = Bundle.main.url(forResource: "RoomListData", withExtension: "txt")!
        let jsonData = try! Data(contentsOf: jsonURL)
        do {
            let roomWrapperModel = try JSONDecoder().decode(RoomWrapperModel.self, from: jsonData)
            let averageModel = roomWrapperModel.average
            AverageService.shared.createAverage(monthPrice: averageModel.monthPrice, name: averageModel.name, yearPrice: averageModel.yearPrice)
            
            let roomModels = roomWrapperModel.rooms
            let roomService = RoomService(coreDataStack: AverageService.shared.coreDataStack)
            let hashTagService = HashTagService(coreDataStack: AverageService.shared.coreDataStack)
            roomModels.forEach { (roomModel) in
                let room = roomService.createRoom(desc: roomModel.desc, isCheck: roomModel.is_check, priceTitle: roomModel.price_title, roomType: roomModel.room_type, sellingType: roomModel.selling_type, imgUrl: roomModel.img_url)
                
                for (idx, title) in roomModel.hash_tags.enumerated() {
                    _ = hashTagService.createHashTag(room: room, title: title, priority: Int16(idx))
                }
            }
            
        } catch let error as NSError {
            print("Error importing rooms: \(error)")
        }
    }
}
