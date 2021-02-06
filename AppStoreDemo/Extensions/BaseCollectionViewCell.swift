//
//  BaseCollectionViewCell.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 20.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit


class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {}
}
