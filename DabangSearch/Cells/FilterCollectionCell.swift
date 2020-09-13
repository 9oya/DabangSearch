//
//  FilterCollectionCell.swift
//  DabangSearch
//
//  Created by Eido Goya on 2020/09/11.
//  Copyright © 2020 Dymm. All rights reserved.
//

import UIKit

let filterCollectionCellId = "FilterCollectionCell"

class FilterCollectionCell: UICollectionViewCell {
    var titleContainer: UIView!
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FilterCollectionCell {
    private func setupLayout() {
        backgroundColor = .systemBackground
        
        titleContainer = {
            let view = UIView()
            view.layer.cornerRadius = 5.0
            view.backgroundColor = .systemBlue
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        titleLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14, weight: .regular)
            label.textColor = .white
            label.textAlignment = .left
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        addSubview(titleContainer)
        
        titleContainer.addSubview(titleLabel)
        
        titleContainer.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        titleContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        titleContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        titleContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        titleLabel.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor, constant: 0).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: titleContainer.centerXAnchor, constant: 0).isActive = true
    }
}
