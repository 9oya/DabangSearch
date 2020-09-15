//
//  HomeHomeInteractorOutput.swift
//  DabangSearch
//
//  Created by 9oya on 11/09/2020.
//  Copyright © 2020 Dymm. All rights reserved.
//

import UIKit

protocol HomeInteractorOutput: class {
    
    func reloadRoomCollectionView()
    
    func reloadSellCollectionView()
    
    func reloadPriceCollectionView()
    
    func reloadRoomTableView()
    
    func scrollToTopTableView()
    
    func toggleIsScrollToLoading()
}
