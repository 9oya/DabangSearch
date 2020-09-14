//
//  HomeHomeInteractorInput.swift
//  DabangSearch
//
//  Created by 9oya on 11/09/2020.
//  Copyright © 2020 Dymm. All rights reserved.
//

import UIKit
import RxSwift

protocol HomeInteractorInput {
    
    func importRoomsIfNeeded()
    
    func loadRooms()
    
    var numberOfRooms: (() -> Int)? { get set }
    
    var roomAt: ((_ indexPath: IndexPath) -> Room?)? { get set }
    
    func searchRooms()
    
    func numberOfSections() -> Int
    
    func numberOfRoomTypeFilters() -> Int
    
    func numberOfSellTypeFilters() -> Int
    
    func numberOfPriceFilters() -> Int
    
    func roomTypeFilterAt(indexPath: IndexPath) -> FilterModel
    
    func sellTypeFilterAt(indexPath: IndexPath) -> FilterModel
    
    func getSelectedPriceTypeFilter() -> FilterModel
    
    func didSelectRoomTypeCollectionView(indexPath: IndexPath)
    
    func didSelectSellTypeCollectionView(indexPath: IndexPath)
    
    func didSelectPriceTypeCollectionView()
    
    func configureFilterCollectionCell(cell: FilterCollectionCell, indexPath: IndexPath, getFilterAt: (_ indexPath: IndexPath) -> FilterModel)
    
    func configureRoomTableCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}
