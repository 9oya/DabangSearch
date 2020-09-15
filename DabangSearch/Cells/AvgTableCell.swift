//
//  AvgTableCell.swift
//  DabangSearch
//
//  Created by Eido Goya on 2020/09/15.
//  Copyright © 2020 Dymm. All rights reserved.
//

import UIKit

let avgTableCellId = "AvgTableCell"

class AvgTableCell: UITableViewCell {
    var titleLabel: UILabel!
    var addressLabel: UILabel!
    var avgMonthGuideLabel: UILabel!
    var avgYearGuideLabel: UILabel!
    var avgMonthPriceLabel: UILabel!
    var avgYearPriceLabel: UILabel!
    
    var verticalLineView: UIView!
    var underLineView: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AvgTableCell {
    private func setupLayout() {
        // MARK: Setup super-view
        selectionStyle = .none
        backgroundColor = UIColor(hex: "#F1F8FF")
        
        // MARK: Setup sub-view properties
        titleLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 12, weight: .bold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        addressLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 12, weight: .bold)
            label.textColor = .systemGray
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        avgMonthGuideLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 11, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        avgYearGuideLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 11, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        avgMonthPriceLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 16, weight: .bold)
            label.textColor = .systemBlue
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        avgYearPriceLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 16, weight: .bold)
            label.textColor = .systemOrange
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        verticalLineView = {
            let view = UIView()
            view.backgroundColor = .systemGray4
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        underLineView = {
            let view = UIView()
            view.backgroundColor = .systemGray5
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        // MARK: Setup UI Hierarchy
        addSubview(titleLabel)
        addSubview(addressLabel)
        addSubview(avgMonthGuideLabel)
        addSubview(avgYearGuideLabel)
        addSubview(avgMonthPriceLabel)
        addSubview(avgYearPriceLabel)
        addSubview(verticalLineView)
        addSubview(underLineView)
        
        // MARK: Setup constraints
        let topMargin: CGFloat = 10
        let leftMargin: CGFloat = 15
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: topMargin).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftMargin).isActive = true
        
        addressLabel.topAnchor.constraint(equalTo: topAnchor, constant: topMargin).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: leftMargin).isActive = true
        
        avgMonthGuideLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: topMargin).isActive = true
        avgMonthGuideLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftMargin).isActive = true
        
        avgMonthPriceLabel.topAnchor.constraint(equalTo: avgMonthGuideLabel.bottomAnchor, constant: 5).isActive = true
        avgMonthPriceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftMargin).isActive = true
        
        verticalLineView.leadingAnchor.constraint(equalTo: addressLabel.leadingAnchor, constant: 0).isActive = true
        verticalLineView.topAnchor.constraint(equalTo: avgMonthGuideLabel.topAnchor, constant: 0).isActive = true
        verticalLineView.bottomAnchor.constraint(equalTo: avgMonthPriceLabel.bottomAnchor, constant: 0).isActive = true
        verticalLineView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        avgYearGuideLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: topMargin).isActive = true
        avgYearGuideLabel.leadingAnchor.constraint(equalTo: verticalLineView.trailingAnchor, constant: leftMargin).isActive = true
        
        avgYearPriceLabel.topAnchor.constraint(equalTo: avgYearGuideLabel.bottomAnchor, constant: 5).isActive = true
        avgYearPriceLabel.leadingAnchor.constraint(equalTo: verticalLineView.trailingAnchor, constant: leftMargin).isActive = true
        
        underLineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        underLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        underLineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        underLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
