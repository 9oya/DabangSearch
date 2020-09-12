//
//  FilterModel.swift
//  DabangSearch
//
//  Created by Eido Goya on 2020/09/12.
//  Copyright © 2020 Dymm. All rights reserved.
//

import Foundation

class FilterModel {
    let title: String
    let code: Int
    var isSelected: Bool
    
    init(title: String, code: Int, isSelected: Bool) {
        self.title = title
        self.code = code
        self.isSelected = isSelected
    }
}
