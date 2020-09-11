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

extension HomeViewController {
    // MARK: Private
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
        
        // MARK: Setup UI Hierarchy
        
        // MARK: Dependency injection
        
        // MARK: Setup constraints
    }
}
