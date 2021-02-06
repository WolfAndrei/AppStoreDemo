//
//  AppsGroupCell.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 20.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class AppsGroupCell: BaseCollectionViewCell {
    
    var appGroup: AppsGroup? {
        didSet {
            if let appGroup = appGroup {
                titleLabel.text = appGroup.feed.title
                horizontalController.appGroup = appGroup
                horizontalController.collectionView.reloadData()
            }
        }
    }
    
    let titleLabel = UILabel(text: "", font: .boldSystemFont(ofSize: 30))
    
    let horizontalController = AppsHorizontalController()
    
    override func setupLayout() {
        super.setupLayout()
        
        addSubview(titleLabel)
        addSubview(horizontalController.view)
        
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        horizontalController.view.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
}
