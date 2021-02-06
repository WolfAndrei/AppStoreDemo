//
//  PreviewCell.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 21.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit


class PreviewCell: BaseCollectionViewCell {
    
    let previewScreenshotsController = PreviewScreenshotsController()
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Preview"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    override func setupLayout() {
        super.setupLayout()
        addSubview(titleLabel)
        addSubview(previewScreenshotsController.view)
        
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))

        previewScreenshotsController.view.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
    }
    
    
}
