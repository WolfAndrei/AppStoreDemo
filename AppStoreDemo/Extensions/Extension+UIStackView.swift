//
//  Extension+UIStackView.swift
//  CoreDataTraining
//
//  Created by Andrei Volkau on 14.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class VerticalStackView: UIStackView {
    
    init(arrangedSubviews: [UIView], spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) {
        super.init(frame: .zero)
        
        arrangedSubviews.forEach{self.addArrangedSubview($0)}
        
        self.axis = .vertical
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class HorizontalStackView: UIStackView {
    
    init(arrangedSubviews: [UIView], spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) {
        super.init(frame: .zero)
        
        arrangedSubviews.forEach{self.addArrangedSubview($0)}
        
        self.axis = .horizontal
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension UIStackView {
    
    @discardableResult
    func withMargins(_ margins: UIEdgeInsets) -> UIStackView {
        
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = margins
        return self
    }
    
    @discardableResult
    func padTop(_ top: CGFloat) -> UIStackView {
        
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins.top = top
        return self
    }
    
    @discardableResult
    func padLeft(_ left: CGFloat) -> UIStackView {
        
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins.left = left
        return self
    }
    
    @discardableResult
    func padRight(_ right: CGFloat) -> UIStackView {
        
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins.right = right
        return self
    }
    
    @discardableResult
    func padBottom(_ bottom: CGFloat) -> UIStackView {
        
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins.bottom = bottom
        return self
    }
}
