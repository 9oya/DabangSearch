//
//  HomeHomeInteractor.swift
//  DabangSearch
//
//  Created by 9oya on 11/09/2020.
//  Copyright © 2020 Dymm. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeInteractor: HomeInteractorInput {
    
    let disposeBag = DisposeBag()

    weak var output: HomeInteractorOutput!
    
    // MARK: Private
    private var rooms: Observable<[Room]>!
    
    // MARK: HomeInteractorInput
    func bind() {
        let roomService = RoomService(coreDataStack: AverageService.shared.coreDataStack)

        rooms = Observable.create({ (observer) in
            if roomService.getRooms()?.isEmpty ?? true {
                FileService.shared.importRoomsJSONSeedData {
                    observer.onNext(roomService.getRooms(
                        roomTypes: FilterService.shared.getRoomTypeFilterCodes(),
                        sellTypes: FilterService.shared.getSellTypeFilterCodes(),
                        isPriceSortAscended: FilterService.shared.getSelectedPriceTypeFilter().code == 0 ? true : false)!
                    )
                }
            }
            return Disposables.create { }
        })
        
        // INPUT
        rooms
            .subscribe(onNext: { (rooms) in
                self.numberOfRooms = {
                    return rooms.count
                }
                
                self.roomAt = { indexPath in
                    return rooms[indexPath.row]
                }
            }).disposed(by: disposeBag)
        
        
    }
    
    func importRoomsIfNeeded() {
        
        rooms.subscribe(onNext: { (rooms) in
                self.numberOfRooms = {
                    return rooms.count
                }
            }).disposed(by: disposeBag)
        
    }
    
    var numberOfRooms: () -> Int
    
    var roomAt: (_ indexPath: IndexPath) -> Room
    
    func searchRooms() {
        
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRoomTypeFilters() -> Int {
        return FilterService.shared.getRoomTypes().count
    }
    
    func numberOfSellTypeFilters() -> Int {
        return FilterService.shared.getSellTypes().count
    }
    
    func numberOfPriceFilters() -> Int {
        return 1
    }
    
    func numberOfTags() -> Int {
        
    }
    
    func roomTypeFilterAt(indexPath: IndexPath) -> FilterModel {
        return FilterService.shared.getRoomTypes()[indexPath.row]
    }
    
    func sellTypeFilterAt(indexPath: IndexPath) -> FilterModel {
        return FilterService.shared.getSellTypes()[indexPath.row]
    }
    
    func getSelectedPriceTypeFilter() -> FilterModel {
        return FilterService.shared.getSelectedPriceTypeFilter()
    }
    
    func didSelectRoomTypeCollectionView(indexPath: IndexPath) {
        FilterService.shared.toggleRoomTypeFilter(indexPath: indexPath)
            .subscribe(onCompleted: {
                self.output.reloadRoomCollectionView()
            }).disposed(by: disposeBag)
    }
    
    func didSelectSellTypeCollectionView(indexPath: IndexPath) {
        FilterService.shared.toggleSellTypeFilter(indexPath: indexPath)
            .subscribe(onSuccess: { _ in
                self.output.reloadSellCollectionView()
            }).disposed(by: disposeBag)
    }
    
    func didSelectPriceTypeCollectionView() {
        FilterService.shared.togglePriceFilter()
            .subscribe(onSuccess: { _ in
                self.output.reloadPriceCollectionView()
            }).disposed(by: disposeBag)
    }
    
    func configureFilterCollectionCell(cell: FilterCollectionCell, indexPath: IndexPath, getFilterAt: (_ indexPath: IndexPath) -> FilterModel) {
        cell.titleLabel.text = getFilterAt(indexPath).title
    }
}
