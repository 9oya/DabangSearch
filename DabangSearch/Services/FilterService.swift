//
//  FilterService.swift
//  DabangSearch
//
//  Created by Eido Goya on 2020/09/12.
//  Copyright © 2020 Dymm. All rights reserved.
//

import RxSwift

class FilterService: FilterServiceProtocol {
    static let shared = FilterService()
    let disposeBag = DisposeBag()
    
    // MARK: GET Services
    var getRoomTypeFilterCodes: () -> [Int]
    var getSellTypeFilterCodes: () -> [Int]
    var getRoomTypes: () -> [FilterModel]
    var getSellTypes: () -> [FilterModel]
    var getPriceTypes: () -> [FilterModel]
    var getSelectedPriceTypeFilter: () -> FilterModel
    
    init() {
        let roomFilterModels = [
            FilterModel(title: "원룸", code: 0, isSelected: true),
            FilterModel(title: "투쓰리룸", code: 1, isSelected: true),
            FilterModel(title: "오피스텔", code: 2, isSelected: true),
            FilterModel(title: "아파트", code: 3, isSelected: true)
        ]
        let sellFilterModels = [
            FilterModel(title: "월세", code: 0, isSelected: true),
            FilterModel(title: "전세", code: 1, isSelected: true),
            FilterModel(title: "매매", code: 2, isSelected: true)
        ]
        let priceFilterModels = [
            FilterModel(title: "오름차순", code: 0, isSelected: true),
            FilterModel(title: "내림차순", code: 1, isSelected: false)
        ]
        
        self.getRoomTypeFilterCodes = {
            return roomFilterModels.map { $0.code }
        }
        
        self.getSellTypeFilterCodes = {
            return sellFilterModels.map { $0.code }
        }
        
        self.getRoomTypes = {
            return roomFilterModels.map { $0 }
        }
        
        self.getSellTypes = {
            return sellFilterModels.map { $0 }
        }
        
        self.getPriceTypes = {
            return priceFilterModels.map { $0 }
        }
        
        self.getSelectedPriceTypeFilter = {
            return priceFilterModels.filter { $0.isSelected }.first!
        }
    }
    
    
    // MARK: UPDATE Services
    func toggleRoomTypeFilter(indexPath: IndexPath) -> Observable<[FilterModel]> {
        return Observable.create { (observer) in
            self.getRoomTypes = {
                let roomTypes = self.getRoomTypes()
                roomTypes[indexPath.row].isSelected.toggle()
                return roomTypes
            }
            observer.onNext(self.getRoomTypes())
            observer.onCompleted()
            return Disposables.create { }
        }
    }
    
    func toggleSellTypeFilter(indexPath: IndexPath) -> Single<[FilterModel]> {
        return Single.create { (single) in
            self.getSellTypes = {
                let sellTypes = self.getRoomTypes()
                sellTypes[indexPath.row].isSelected.toggle()
                return sellTypes
            }
            single(.success(self.getSellTypes()))
            return Disposables.create { }
        }
    }
    
    
    func togglePriceFilter() -> Single<FilterModel> {
        return Single.create { (single) in
            self.getPriceTypes = {
                return self.getPriceTypes().map { (filterModel) in
                    filterModel.isSelected.toggle()
                    return filterModel
                }
            }
            
            self.getSelectedPriceTypeFilter = {
                return self.getPriceTypes().filter { $0.isSelected }.first!
            }
            
            single(.success(self.getSelectedPriceTypeFilter()))
            
            return Disposables.create { }
        }
    }
}
