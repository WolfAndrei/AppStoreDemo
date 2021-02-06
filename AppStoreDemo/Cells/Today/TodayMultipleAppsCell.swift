//
//  TodayMultipleAppsCell.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 25.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class TodayMultipleAppsCell: BaseTodayCell {
    
    override var todayItem: TodayItem? {
        didSet {
            if let todayItem = todayItem {
                categoryLabel.text = todayItem.category
                titleLabel.text = todayItem.title
                multipleAppsController.results = todayItem.apps
                multipleAppsController.collectionView.reloadData()
            }
        }
    }
    
    
    let categoryLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 32)
        label.numberOfLines = 0
        return label
    }()
    
    let multipleAppsController = TodayMultipleAppsController(mode: .small)
    
    
    override func setupLayout() {
        super.setupLayout()
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        
        
        let stackView = VerticalStackView(arrangedSubviews: [categoryLabel, titleLabel, multipleAppsController.view], spacing: 12)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
        
    }
    
}
