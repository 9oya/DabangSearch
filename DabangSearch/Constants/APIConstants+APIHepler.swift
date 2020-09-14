//
//  APIConstants.swift
//  DabangSearch
//
//  Created by Eido Goya on 2020/09/14.
//  Copyright © 2020 Dymm. All rights reserved.
//

import Foundation

struct APIConstants {
    
}

class APIHelper {
    static let shared = APIHelper()
    
    func getRoomTypeTxt(roomType: RoomType) -> String {
        switch roomType {
        case .oneRoom:
            return "원룸"
        case .twoThreeRoom:
            return "투쓰리룸"
        case .officetel:
            return "오피스텔"
        case .apartment:
            return "아파트"
        }
    }
    
    func getSellTypeTxt(sellType: SellType) -> String {
        switch sellType {
        case .monthly:
            return "월세"
        case .annually:
            return "전세"
        case .sale:
            return "매매"
        }
    }
    
    func convertPriceTitleToPrice(priceTitle: String) -> Int32 {
        if priceTitle.contains("억") {
            if priceTitle.contains("천") {
                // ex: 1억7천
                let components = priceTitle.components(separatedBy: "억")
                let value1 = Int(components.first!)!
                let value2 = Int(components[1].components(separatedBy: "천").first!)!
                return Int32((value1 * 10000) + (value2 * 1000))
            } else {
                // ex: 1억
                let value = Int(priceTitle.components(separatedBy: "억").first!)!
                return Int32(value * 10000)
            }
        } else if priceTitle.contains("만원") {
            // ex: 6000만원
            return Int32(priceTitle.components(separatedBy: "만원").first!)!
        } else {
            fatalError("Unexpected value has been passed")
        }
    }
    
    func convertPriceToPriceTitle(price: Int32) -> String {
        if price >= 10000 {
            if price % 10000 == 0 {
                // ex: 10000 (n억)
                return "\(price / 10000)억"
            } else {
                // ex: 11000 (n억k천)
                let n = price / 10000
                let k = (price % 10000) / 1000
                return "\(n)억\(k)천"
            }
        } else {
            return "\(price)만원"
        }
    }
}

enum RoomType: Int16 {
    case oneRoom = 0
    case twoThreeRoom = 1
    case officetel = 2
    case apartment = 3
}

enum SellType: Int16 {
    case monthly = 0
    case annually = 1
    case sale = 2
}
