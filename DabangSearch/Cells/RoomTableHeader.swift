//
//  RoomTableHeader.swift
//  DabangSearch
//
//  Created by Eido Goya on 2020/09/12.
//  Copyright © 2020 Dymm. All rights reserved.
//

import UIKit

let roomTableHeaderId = "RoomTableHeader"

class RoomTableHeader: UITableViewHeaderFooterView {
    
    // MARK: Properties
    var roomCollectionView: UICollectionView!
    var sellCollectionView: UICollectionView!
    var priceCollectionView: UICollectionView!
    
    var roomTypeLabel: UILabel!
    var sellTypeLabel: UILabel!
    var priceLabel: UILabel!
    
    var underLineView: UIView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCollectionViewType(_ collectionView: UICollectionView) -> CollectionType {
        if collectionView == roomCollectionView {
            return .roomTypeCollection
        } else if collectionView == sellCollectionView {
            return .sellTypeCollection
        } else {
            return .priceTypeCollection
        }
    }
}

enum CollectionType {
    case roomTypeCollection, sellTypeCollection, priceTypeCollection
}

extension RoomTableHeader {
    private func configureContents() {
        // MARK: Setup super-view
        backgroundColor = .systemBackground
        contentView.backgroundColor = .systemBackground
        
        // MARK: Setup sub-view properties
        roomCollectionView = {
            let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
            collectionView.backgroundColor = .systemBackground
            
            collectionView.collectionViewLayout = CustomCollectionViewFlowLayout()
            
            collectionView.register(FilterCollectionCell.self, forCellWithReuseIdentifier: filterCollectionCellId)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        }()
        sellCollectionView = {
            let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
            collectionView.backgroundColor = .systemBackground
            
            collectionView.collectionViewLayout = CustomCollectionViewFlowLayout()
            
            collectionView.register(FilterCollectionCell.self, forCellWithReuseIdentifier: filterCollectionCellId)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        }()
        priceCollectionView = {
            let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
            collectionView.backgroundColor = .systemBackground
            
            collectionView.collectionViewLayout = CustomCollectionViewFlowLayout()
            
            collectionView.register(FilterCollectionCell.self, forCellWithReuseIdentifier: filterCollectionCellId)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        }()
        roomTypeLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14, weight: .bold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        sellTypeLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14, weight: .bold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        priceLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14, weight: .bold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        underLineView = {
            let view = UIView()
            view.backgroundColor = .systemGray6
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        // MARK: Setup UI Hierarchy
        contentView.addSubview(roomTypeLabel)
        contentView.addSubview(roomCollectionView)
        contentView.addSubview(sellTypeLabel)
        contentView.addSubview(sellCollectionView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(priceCollectionView)
        contentView.addSubview(underLineView)
        
        // MARK: Setup constraints
        let collectionViewHeight: CGFloat = 36.0
        let margin: CGFloat = 15.0
        let linePerSpacing: CGFloat = 10.0
        roomTypeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        roomTypeLabel.topAnchor.constraint(equalTo: topAnchor, constant: linePerSpacing).isActive = true
        
        roomCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        roomCollectionView.topAnchor.constraint(equalTo: roomTypeLabel.bottomAnchor, constant: linePerSpacing).isActive = true
        roomCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight).isActive = true
        roomCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin).isActive = true
        
        sellTypeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        sellTypeLabel.topAnchor.constraint(equalTo: roomCollectionView.bottomAnchor, constant: 14).isActive = true
        
        sellCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        sellCollectionView.topAnchor.constraint(equalTo: sellTypeLabel.bottomAnchor, constant: linePerSpacing).isActive = true
        sellCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight).isActive = true
        sellCollectionView.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: 20).isActive = true
        
        priceLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 30).isActive = true
        priceLabel.topAnchor.constraint(equalTo: roomCollectionView.bottomAnchor, constant: 14).isActive = true
        
        priceCollectionView.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: 0).isActive = true
        priceCollectionView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: linePerSpacing).isActive = true
        priceCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight).isActive = true
        priceCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin).isActive = true
        
        underLineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        underLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        underLineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        underLineView.heightAnchor.constraint(equalToConstant: 8).isActive = true
    }
}
