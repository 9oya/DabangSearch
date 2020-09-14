//
//  TagCollectionCell.swift
//  DabangSearch
//
//  Created by Eido Goya on 2020/09/11.
//  Copyright © 2020 Dymm. All rights reserved.
//

import UIKit

let tagCollectionCellId = "TagCollectionCell"

class TagCollectionCell: UICollectionViewCell {
    var tagContainer: UIView!
    var tagLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TagCollectionCell {
    private func setupLayout() {
        backgroundColor = .systemBackground
        
        tagContainer = {
            let view = UIView()
            view.layer.cornerRadius = 3.0
            view.backgroundColor = .systemGray6
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        tagLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 11, weight: .regular)
            label.textColor = .systemGray
            label.textAlignment = .left
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        addSubview(tagContainer)
        
        tagContainer.addSubview(tagLabel)
        
        tagContainer.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        tagContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        tagContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        tagContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        tagLabel.centerYAnchor.constraint(equalTo: tagContainer.centerYAnchor, constant: 0).isActive = true
        tagLabel.centerXAnchor.constraint(equalTo: tagContainer.centerXAnchor, constant: 0).isActive = true
    }
}
