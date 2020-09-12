//
//  HomeHomeInteractor.swift
//  DabangSearch
//
//  Created by 9oya on 11/09/2020.
//  Copyright © 2020 Dymm. All rights reserved.
//

import UIKit

class HomeInteractor: HomeInteractorInput {

    weak var output: HomeInteractorOutput!
    
    // MARK: HomeInteractorInput
    func importRoomsIfNeeded() {
        if RoomService.shared.getRooms()?.isEmpty ?? true {
            FileService.shared.importRoomsJSONSeedData()
        }
    }
    
    func numberOfRoomTypeFilters() -> Int {
        
    }
    
    func numberOfSellTypeFilters() -> Int {
        
    }
    
    func numberOfPriceFilters() -> Int {
        
    }
    
    func numberOfRooms() -> Int {
        
    }
    
    func numberOfTags() -> Int {
        
    }
    
    
    func configureRoomHeaderView(view: RoomTableHeader) {
        view.roomCollectionView.reloadData()
        view.sellCollectionView.reloadData()
        view.priceCollectionView.reloadData()
    }
}
