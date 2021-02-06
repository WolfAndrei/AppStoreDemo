//
//  BaseTodayCell.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 25.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class BaseTodayCell: BaseCollectionViewCell {
    
    var todayItem: TodayItem?
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.transform = self.isHighlighted ? .init(scaleX: 0.9, y: 0.9) : .identity
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: 10)
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
