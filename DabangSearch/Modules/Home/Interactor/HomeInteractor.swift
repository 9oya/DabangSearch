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
    private let roomService = RoomService(coreDataStack: AverageService.shared.coreDataStack)
    private var rooms: Observable<[Room]>!
    
    private func setupRooms() {
        rooms
            .subscribe(onNext: { (rooms) in
                self.numberOfRooms = {
                    return rooms.count
                }
                
                self.roomAt = { indexPath in
                    return rooms[indexPath.row]
                }
            }, onCompleted: {
                self.output.reloadRoomTableView()
            }).disposed(by: disposeBag)
    }
    
    private func numberOfHashTags(indexPath: IndexPath) -> Int {
        return roomAt!(indexPath)!.hashTags!.allObjects.count
    }
    
    private func hashTagAt(room: Room, indexPath: IndexPath) -> HashTag {
        return room.hashTags!.allObjects[indexPath.item] as! HashTag
    }
    
    private func configureTagCollectionCell(room: Room, cell: TagCollectionCell, indexPath: IndexPath) {
        let hashTag = hashTagAt(room: room, indexPath: indexPath)
        cell.tagLabel.text = hashTag.title
    }
    
    // MARK: HomeInteractorInput
    func bind() {
        
        // INPUT
        rooms = Observable.create({ (observer) in
            observer.onNext(self.roomService.getRooms(
                roomTypes: FilterService.shared.getRoomTypeFilterCodes(),
                sellTypes: FilterService.shared.getSellTypeFilterCodes(),
                isPriceSortAscended: FilterService.shared.getSelectedPriceTypeFilter().code == 0 ? true : false)!
            )
            return Disposables.create { }
        })
        
        // OUTPUT
        
    }
    
    func importRoomsIfNeeded() {
        Observable.just(self.roomService.getRooms())
            .subscribe(onNext: { (rooms) in
                if rooms?.isEmpty ?? true {
                    FileService.shared.importRoomsJSONSeedData {
                        self.importRoomsIfNeeded()
                    }
                } else {
                    self.numberOfRooms = {
                        return rooms!.count
                    }
                    
                    self.roomAt = { indexPath in
                        return rooms![indexPath.row]
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    var numberOfRooms: (() -> Int)?
    
    var roomAt: ((_ indexPath: IndexPath) -> Room?)?
    
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
                self.setupRooms()
            }).disposed(by: disposeBag)
    }
    
    func didSelectSellTypeCollectionView(indexPath: IndexPath) {
        FilterService.shared.toggleSellTypeFilter(indexPath: indexPath)
            .subscribe(onSuccess: { _ in
                self.output.reloadSellCollectionView()
                self.setupRooms()
            }).disposed(by: disposeBag)
    }
    
    func didSelectPriceTypeCollectionView() {
        FilterService.shared.togglePriceFilter()
            .subscribe(onSuccess: { _ in
                self.output.reloadPriceCollectionView()
                self.setupRooms()
            }).disposed(by: disposeBag)
    }
    
    func configureFilterCollectionCell(cell: FilterCollectionCell, indexPath: IndexPath, getFilterAt: (_ indexPath: IndexPath) -> FilterModel) {
        cell.titleLabel.text = getFilterAt(indexPath).title
    }
    
    func configureRoomTableCell(cell: RoomTableCell, indexPath: IndexPath) {
        
        let room = roomAt!(indexPath)!
        
        cell.room = room
        
        cell.numberOfItemsInSection = numberOfHashTags(indexPath: indexPath)
        
        cell.configureTagCollectionCell = { room, cell, indexPath in
            self.configureTagCollectionCell(room: room, cell: cell, indexPath: indexPath)
        }
        
        cell.sizeForItem = { indexPath in
            return CGSize(
                width: CGFloat((self.hashTagAt(room: room, indexPath: indexPath).title!.count * 13) + 12),
                height: 32
            )
        }
        
        cell.titleLabel.text = room.priceTitle!
    }
}
