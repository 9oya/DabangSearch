//
//  HomeHomeViewOutput.swift
//  DabangSearch
//
//  Created by 9oya on 11/09/2020.
//  Copyright © 2020 Dymm. All rights reserved.
//

import UIKit

protocol HomeViewOutput {

    /**
        @author 9oya
        Notify presenter that view is ready
    */

    func viewIsReady()
    
    func searchRooms(keyword: String?, fetchStart: Int, fetchSize: Int)
    
    func numberOfRooms() -> Int
    
    func roomAt(indexPath: IndexPath) -> Room?
    
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
    
    func getRoomTableCellHeight(indexPath: IndexPath) -> CGFloat
    
    func configureRoomTableCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}
