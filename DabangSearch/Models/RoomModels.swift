//
//  RoomModels.swift
//  DabangSearch
//
//  Created by Eido Goya on 2020/09/11.
//  Copyright © 2020 Dymm. All rights reserved.
//

import Foundation

struct AverageModel: Codable {
    let monthPrice: String
    let name: String
    let yearPrice: String
}

struct RoomModel: Codable {
    let desc: String
    let is_check: Bool
    let price_title: String
    let room_type: Int16
    let selling_type: Int16
    let hash_tags: [String]
    let img_url: String
}

struct RoomWrapperModel: Codable {
    let average: AverageModel
    let rooms: [RoomModel]
}
