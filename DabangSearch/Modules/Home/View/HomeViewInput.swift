//
//  HomeHomeViewInput.swift
//  DabangSearch
//
//  Created by 9oya on 11/09/2020.
//  Copyright © 2020 Dymm. All rights reserved.
//

protocol HomeViewInput: class {

    /**
        @author 9oya
        Setup initial state of the view
    */

    func setupInitialState()
    
    var reloadRoomCollectionView: (() -> Void)? { get set }
    
    var reloadSellCollectionView: (() -> Void)? { get set }
    
    var reloadPriceCollectionView: (() -> Void)? { get set }
    
    func reloadRoomTableView()
}
