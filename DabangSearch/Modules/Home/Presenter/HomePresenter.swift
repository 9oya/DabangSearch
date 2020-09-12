//
//  HomeHomePresenter.swift
//  DabangSearch
//
//  Created by 9oya on 11/09/2020.
//  Copyright © 2020 Dymm. All rights reserved.
//

import UIKit

class HomePresenter: HomeModuleInput, HomeViewOutput, HomeInteractorOutput {

    weak var view: HomeViewInput!
    var interactor: HomeInteractorInput!
    var router: HomeRouterInput!

    // MARK: HomeViewOutput
    func viewIsReady() {
        view.setupInitialState()
    }
    
    func numberOfSections() -> Int {
        return interactor.numberOfSections()
    }
    
    func numberOfRoomTypeFilters() -> Int {
        return interactor.numberOfRoomTypeFilters()
    }
    
    func numberOfSellTypeFilters() -> Int {
        return interactor.numberOfSellTypeFilters()
    }
    
    func numberOfPriceFilters() -> Int {
        return interactor.numberOfPriceFilters()
    }
    
    func numberOfRooms() -> Int {
        return interactor.numberOfRooms()
    }
    
    func numberOfTags() -> Int {
        return interactor.numberOfTags()
    }
    
    func roomTypeFilterAt(indexPath: IndexPath) -> FilterModel {
        return interactor.roomTypeFilterAt(indexPath: indexPath)
    }
    
    func sellTypeFilterAt(indexPath: IndexPath) -> FilterModel {
        return interactor.sellTypeFilterAt(indexPath: indexPath)
    }
    
    func getSelectedPriceTypeFilter() -> FilterModel {
        return interactor.getSelectedPriceTypeFilter()
    }
    
    func didSelectRoomTypeCollectionView(indexPath: IndexPath) {
        interactor.didSelectRoomTypeCollectionView(indexPath: indexPath)
    }
    
    func didSelectSellTypeCollectionView(indexPath: IndexPath) {
        interactor.didSelectSellTypeCollectionView(indexPath: indexPath)
    }
    
    func didSelectPriceTypeCollectionView() {
        interactor.didSelectPriceTypeCollectionView()
    }
    
    func configureFilterCollectionCell(cell: FilterCollectionCell, indexPath: IndexPath, getFilterAt: (IndexPath) -> FilterModel) {
        interactor.configureFilterCollectionCell(cell: cell, indexPath: indexPath, getFilterAt: getFilterAt)
    }
    
    
    // MARK: HomeInteractorOutput
    func reloadRoomCollectionView() {
        view.reloadRoomCollectionView!()
    }
    
    func reloadSellCollectionView() {
        view.reloadSellCollectionView!()
    }
    
    func reloadPriceCollectionView() {
        view.reloadPriceCollectionView!()
    }
    
    func reloadRoomTableView() {
        view.reloadRoomTableView()
    }
}
