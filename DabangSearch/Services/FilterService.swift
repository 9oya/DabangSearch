//
//  FilterService.swift
//  DabangSearch
//
//  Created by Eido Goya on 2020/09/12.
//  Copyright © 2020 Dymm. All rights reserved.
//

import Foundation

class FilterService: FilterServiceProtocol {
    static let shared = FilterService()
    
    // MARK: GET Services
    func getRoomTypeFilters() -> [FilterModel] {
        return [
            FilterModel(title: "원룸", code: 0),
            FilterModel(title: "투쓰리룸", code: 1),
            FilterModel(title: "오피스텔", code: 2),
            FilterModel(title: "아파트", code: 3)
        ]
    }
}
