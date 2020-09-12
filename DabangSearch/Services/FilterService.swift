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
    
    let roomTypeFilters: BehaviorSubject<[FilterModel]>
    let sellTypeFilters: BehaviorSubject<[FilterModel]>
    let priceFilters: BehaviorSubject<[FilterModel]>
    
    let roomTypeFilterCodes: BehaviorSubject<[Int]>
    let sellTypeFilterCodes: BehaviorSubject<[Int]>
    
    // MARK: GET Services
    var getRoomTypeFilterCodes: () -> [Int]
    var getSellTypeFilterCodes: () -> [Int]
    var getRoomTypes: () -> [FilterModel]
    var getSellTypes: () -> [FilterModel]
    var getPriceTypes: () -> [FilterModel]
    var getSelectedPriceTypeFilter: () -> FilterModel
    
    init() {
        self.roomTypeFilters = BehaviorSubject(value: [
            FilterModel(title: "원룸", code: 0, isSelected: true),
            FilterModel(title: "투쓰리룸", code: 1, isSelected: true),
            FilterModel(title: "오피스텔", code: 2, isSelected: true),
            FilterModel(title: "아파트", code: 3, isSelected: true)
        ])
        self.sellTypeFilters = BehaviorSubject(value: [
            FilterModel(title: "월세", code: 0, isSelected: true),
            FilterModel(title: "전세", code: 1, isSelected: true),
            FilterModel(title: "매매", code: 2, isSelected: true)
        ])
        self.priceFilters = BehaviorSubject(value: [
            FilterModel(title: "오름차순", code: 0, isSelected: true),
            FilterModel(title: "내림차순", code: 1, isSelected: false)
        ])
        
        // INPUT
        roomTypeFilters
            .map { $0.map { $0.code } }
            .bind(to: roomTypeFilterCodes)
            .disposed(by: disposeBag)
        sellTypeFilters
            .map { $0.map { $0.code } }
            .bind(to: sellTypeFilterCodes)
            .disposed(by: disposeBag)
        
        // OUTPUT
        roomTypeFilterCodes
            .subscribe(onNext: { (codes) in
                self.getRoomTypeFilterCodes = {
                    return codes
                }
            }).disposed(by: disposeBag)
        sellTypeFilterCodes
            .subscribe(onNext: { (codes) in
                self.getSellTypeFilterCodes = {
                    return codes
                }
            }).disposed(by: disposeBag)
        
        roomTypeFilters
            .subscribe(onNext: { (filterModels) in
                self.getRoomTypes = {
                    return filterModels
                }
            }).disposed(by: disposeBag)
        sellTypeFilters
            .subscribe(onNext: { (filterModels) in
                self.getSellTypes = {
                    return filterModels
                }
            }).disposed(by: disposeBag)
        priceFilters
            .subscribe(onNext: { (filterModels) in
                self.getPriceTypes = {
                    return filterModels
                }
                self.getSelectedPriceTypeFilter = {
                    return filterModels.filter { $0.isSelected }.first!
                }
            }).disposed(by: disposeBag)
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
