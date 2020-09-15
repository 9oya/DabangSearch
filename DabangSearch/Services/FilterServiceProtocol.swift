//
//  FilterServiceProtocol.swift
//  DabangSearch
//
//  Created by Eido Goya on 2020/09/12.
//  Copyright © 2020 Dymm. All rights reserved.
//

import UIKit
import RxSwift

protocol FilterServiceProtocol {
    
    // MARK: GET Services
    var getRoomTypeFilterCodes: () -> [Int] { get set }
    var getSellTypeFilterCodes: () -> [Int] { get set }
    var getRoomTypes: () -> [FilterModel] { get set }
    var getSellTypes: () -> [FilterModel] { get set }
    var getPriceTypes: () -> [FilterModel] { get set }
    var getSelectedPriceTypeFilter: () -> FilterModel { get set }
    
    // MARK: UPDATE Services
    func toggleRoomTypeFilter(indexPath: IndexPath) -> Observable<[FilterModel]>
    
    func toggleSellTypeFilter(indexPath: IndexPath) -> Observable<[FilterModel]>
    
    func togglePriceFilter() -> Single<FilterModel>
}
