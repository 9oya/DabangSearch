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
    
    // ScrollToLoading
    var searchText: String?
    var lastContentOffset: CGFloat = 0.0
    var isScrollToLoading: Bool = false
    let fetchSize = 12
    var fetchStart: Int = 12

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
    @objc func dismissKeyboard() {
        searchController.searchBar.endEditing(true)
    }

    // MARK: HomeViewInput
    func setupInitialState() {
        setupLayout()
    }
    
    var reloadRoomCollectionView: (() -> Void)?
    
    var reloadSellCollectionView: (() -> Void)?
    
    var reloadPriceCollectionView: (() -> Void)?
    
    func reloadRoomTableView() {
        roomTableView.reloadData()
        view.hideSpinner()
    }
    
    func scrollToTopTableView() {
        let indexPath = IndexPath(row: 0, section: 0)
        roomTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func toggleIsScrollToLoading() {
        self.isScrollToLoading.toggle()
    }
    
    // MARK: Private
    private var getCollectionViewType: ((_ collectionView: UICollectionView) -> CollectionType)?
}

extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    // MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text?.isEmpty ?? true {
            return
        }
        
        fetchStart = fetchSize
        lastContentOffset = 0.0
        isScrollToLoading = false
        
        self.view.showSpinner()
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            self.searchText = searchController.searchBar.text!
            self.output.searchRooms(keyword: searchController.searchBar.text!, fetchStart: 0, fetchSize: 11)
        }
    }
    
    // MARK: UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.output.searchRooms(keyword: nil, fetchStart: 0, fetchSize: 11)
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
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.customBackView.addGestureRecognizer(gestureRecognizer)
        view.customBackView.isUserInteractionEnabled = true
        
        view.roomCollectionView.dataSource = self
        view.roomCollectionView.delegate = self
        view.sellCollectionView.dataSource = self
        view.sellCollectionView.delegate = self
        view.priceCollectionView.delegate = self
        view.priceCollectionView.dataSource = self
        
        reloadRoomCollectionView = {
            self.view.showSpinner()
            view.roomCollectionView.reloadData()
        }
        
        reloadSellCollectionView = {
            self.view.showSpinner()
            view.sellCollectionView.reloadData()
        }
        
        reloadPriceCollectionView = {
            self.view.showSpinner()
            view.priceCollectionView.reloadData()
        }
        
        getCollectionViewType = view.getCollectionViewType
        
        view.roomTypeLabel.text = "방 종류"
        view.sellTypeLabel.text = "매물 종류"
        view.priceLabel.text = "가격"
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return output.configureRoomTableCell(tableView: tableView, indexPath: indexPath)
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissKeyboard()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 176
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return output.getRoomTableCellHeight(indexPath: indexPath)
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dismissKeyboard()
        
        if lastContentOffset > scrollView.contentOffset.y {
            // Case scolled up
            return
        }
        if scrollView.contentSize.height < 0 || scrollView.contentSize.height == 556.0 {
            // Case view did initialized
            return
        } else {
            lastContentOffset = scrollView.contentOffset.y
        }
        if (scrollView.frame.size.height + scrollView.contentOffset.y) > (scrollView.contentSize.height - 200) {
            print(output.numberOfRooms())
            print(fetchStart)
            print(scrollView.contentSize.height)
            if output.numberOfRooms() == fetchStart {
                // Case searched result count is equal to fetchStart that means probably theres more...
                isScrollToLoading = true
                fetchStart += fetchSize
                
                output.searchRooms(keyword: searchText ?? nil, fetchStart: fetchStart - 1, fetchSize: fetchSize)
            }
        }
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
        fetchStart = fetchSize
        lastContentOffset = 0.0
        isScrollToLoading = false
        switch getCollectionViewType!(collectionView) {
        case .roomTypeCollection:
            output.didSelectRoomTypeCollectionView(indexPath: indexPath)
        case .sellTypeCollection:
            output.didSelectSellTypeCollectionView(indexPath: indexPath)
        case .priceTypeCollection:
            output.didSelectPriceTypeCollectionView()
        }
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
        
        // Remove navigationBar border
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
        
        // MARK: Setup sub-view properties
        searchController = {
            let searchController = UISearchController(searchResultsController: nil)
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            return searchController
        }()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        roomTableView = {
            let tableView = UITableView()
            tableView.backgroundColor = .clear
            tableView.separatorStyle = .none
            tableView.register(RoomTableHeader.self, forHeaderFooterViewReuseIdentifier: roomTableHeaderId)
            tableView.register(RoomRightTableCell.self, forCellReuseIdentifier: roomRightTableCellId)
            tableView.register(RoomLeftTableCell.self, forCellReuseIdentifier: roomLeftTableCellId)
            tableView.register(AvgTableCell.self, forCellReuseIdentifier: avgTableCellId)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()
        
        // MARK: Setup UI Hierarchy
        view.addSubview(roomTableView)
        
        // MARK: Dependency injection
        searchController.searchBar.delegate = self
        roomTableView.dataSource = self
        roomTableView.delegate = self
        
        // MARK: Setup constraints
        roomTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        roomTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        roomTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        roomTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
}
