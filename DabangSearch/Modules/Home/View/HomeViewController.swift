//
//  HomeHomeViewController.swift
//  DabangSearch
//
//  Created by 9oya on 11/09/2020.
//  Copyright © 2020 Dymm. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, HomeViewInput {
    
    // MARK: Properties
    var searchController: UISearchController!
    
    var roomTableView: UITableView!

    // Presenter
    var output: HomeViewOutput!
    
    // DI
    let configurator = HomeModuleConfigurator()

    // MARK: Life cycle
    override func loadView() {
        super.loadView()
        configurator.configureModuleForViewInput(viewInput: self)
        output.viewIsReady()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions

    // MARK: HomeViewInput
    func setupInitialState() {
        setupLayout()
    }
    
    var reloadRoomCollectionView: (() -> Void)?
    
    var reloadSellCollectionView: (() -> Void)?
    
    var reloadPriceCollectionView: (() -> Void)?
    
    func reloadRoomTableView() {
        roomTableView.reloadData()
    }
    
    // MARK: Private
    private var getCollectionViewType: ((_ collectionView: UICollectionView) -> CollectionType)?
}

extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    // MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text!)
    }
    
    // MARK: UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return output.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.numberOfRooms()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: roomTableHeaderId) as? RoomTableHeader else {
            fatalError()
        }
        view.roomCollectionView.dataSource = self
        view.roomCollectionView.delegate = self
        view.sellCollectionView.dataSource = self
        view.sellCollectionView.delegate = self
        view.priceCollectionView.delegate = self
        view.priceCollectionView.dataSource = self
        
        reloadRoomCollectionView = {
            view.roomCollectionView.reloadData()
        }
        
        reloadSellCollectionView = {
            view.sellCollectionView.reloadData()
        }
        
        reloadPriceCollectionView = {
            view.priceCollectionView.reloadData()
        }
        
        getCollectionViewType = view.getCollectionViewType
        
        view.roomTypeLabel.text = "방 종류"
        view.sellTypeLabel.text = "매물 종류"
        view.priceLabel.text = "가격"
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: roomTableCellId, for: indexPath) as? RoomTableCell else {
            fatalError()
        }
        output.configureRoomTableCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 176
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch getCollectionViewType!(collectionView) {
        case .roomTypeCollection:
            return output.numberOfRoomTypeFilters()
        case .sellTypeCollection:
            return output.numberOfSellTypeFilters()
        case .priceTypeCollection:
            return output.numberOfPriceFilters()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterCollectionCellId, for: indexPath) as? FilterCollectionCell else {
            fatalError()
        }
        
        let getFilterAt: (_ indexPath: IndexPath) -> FilterModel = { indexPath in
            switch self.getCollectionViewType!(collectionView) {
            case .roomTypeCollection:
                return self.output.roomTypeFilterAt(indexPath: indexPath)
            case .sellTypeCollection:
                return self.output.sellTypeFilterAt(indexPath: indexPath)
            case .priceTypeCollection:
                return self.output.getSelectedPriceTypeFilter()
            }
        }
        
        output.configureFilterCollectionCell(cell: cell, indexPath: indexPath, getFilterAt: getFilterAt)
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var text: String = ""
        switch getCollectionViewType!(collectionView) {
        case .roomTypeCollection:
            text = output.roomTypeFilterAt(indexPath: indexPath).title
        case .sellTypeCollection:
            text = output.sellTypeFilterAt(indexPath: indexPath).title
        case .priceTypeCollection:
            text = output.getSelectedPriceTypeFilter().title
        }
        
        return CGSize(width: CGFloat((text.count * 13) + 12), height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension HomeViewController {
    private func setupLayout() {
        // MARK: Setup super-view
        view.backgroundColor = .systemBackground
        
        // MARK: Setup sub-view properties
        searchController = {
            let searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            return searchController
        }()
        navigationItem.searchController = searchController
        
        roomTableView = {
            let tableView = UITableView()
            tableView.backgroundColor = .clear
            tableView.separatorStyle = .none
            tableView.register(RoomTableHeader.self, forHeaderFooterViewReuseIdentifier: roomTableHeaderId)
            tableView.register(RoomTableCell.self, forCellReuseIdentifier: roomTableCellId)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()
        
        // MARK: Setup UI Hierarchy
        view.addSubview(roomTableView)
        
        // MARK: Dependency injection
        roomTableView.dataSource = self
        roomTableView.delegate = self
        
        // MARK: Setup constraints
        roomTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        roomTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        roomTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        roomTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
}
