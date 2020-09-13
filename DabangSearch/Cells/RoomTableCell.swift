//
//  RoomTableCell.swift
//  DabangSearch
//
//  Created by Eido Goya on 2020/09/12.
//  Copyright © 2020 Dymm. All rights reserved.
//

import UIKit

let roomTableCellId = "RoomTableCell"

class RoomTableCell: UITableViewCell {
    
    // MARK: Properties
    var tagCollectionView: UICollectionView!
    
    var titleLabel: UILabel!
    var roomTypeLabel: UILabel!
    var descLabel: UILabel!
    
    var roomImgView: UIImageView!
    
    var bookmarkButton: UIButton!
    
    var underLineView: UIView!
    
    var output: HomeViewOutput!
    
    var numberOfItemsInSection: Int?
    
    var sizeForItem: ((_ indexPath: IndexPath) -> CGSize)?
    
    var room: Room?
    
    var configureTagCollectionCell: ((_ room: Room, _ cell: TagCollectionCell, _ indexPath: IndexPath) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RoomTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInSection ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCollectionCellId, for: indexPath) as? TagCollectionCell else {
            fatalError()
        }
        configureTagCollectionCell!(room!, cell, indexPath)
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItem!(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension RoomTableCell {
    private func setupLayout() {
        // MARK: Setup super-view
        selectionStyle = .none
        backgroundColor = .clear
        
        // MARK: Setup sub-view properties
        tagCollectionView = {
            let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
            
            collectionView.collectionViewLayout = CustomCollectionViewFlowLayout()
            
            collectionView.register(TagCollectionCell.self, forCellWithReuseIdentifier: tagCollectionCellId)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        }()
        titleLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 18, weight: .bold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        roomTypeLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 13, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        descLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 13, weight: .regular)
            label.textColor = .systemGray
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        roomImgView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleToFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        bookmarkButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        underLineView = {
            let view = UIView()
            view.backgroundColor = .systemGray5
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        // MARK: Setup UI Hierarchy
        addSubview(titleLabel)
        addSubview(roomTypeLabel)
        addSubview(descLabel)
        addSubview(tagCollectionView)
        addSubview(roomImgView)
        addSubview(bookmarkButton)
        addSubview(underLineView)
        
        // MARK: DI
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        
        // MARK: Setup constraints
        let margin: CGFloat = 15.0
        roomImgView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        roomImgView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin).isActive = true
        roomImgView.widthAnchor.constraint(equalToConstant: 126).isActive = true
        roomImgView.heightAnchor.constraint(equalToConstant: 84).isActive = true
        
        bookmarkButton.topAnchor.constraint(equalTo: roomImgView.topAnchor, constant: 5).isActive = true
        bookmarkButton.trailingAnchor.constraint(equalTo: roomImgView.trailingAnchor, constant: -5).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: roomImgView.topAnchor, constant: 0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: roomImgView.leadingAnchor, constant: -30).isActive = true
        
        roomTypeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3).isActive = true
        roomTypeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        roomTypeLabel.trailingAnchor.constraint(equalTo: roomImgView.leadingAnchor, constant: -30).isActive = true
        
        descLabel.topAnchor.constraint(equalTo: roomTypeLabel.bottomAnchor, constant: 0).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: roomImgView.leadingAnchor, constant: -30).isActive = true
        
        tagCollectionView.bottomAnchor.constraint(equalTo: roomImgView.bottomAnchor, constant: 0).isActive = true
        tagCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        tagCollectionView.trailingAnchor.constraint(equalTo: roomImgView.leadingAnchor, constant: -30).isActive = true
    }
}
