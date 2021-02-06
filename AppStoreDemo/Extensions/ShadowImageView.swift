//
//  ShadowImageView.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 21.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class ShadowImageView: UIView {
    
    convenience init(cornerRadius: CGFloat = 0, shadowOffset: CGSize = .zero, shadowColor: UIColor = .black, shadowRadius: CGFloat = 0, shadowOpacity: Float = 0, borderColor: UIColor = .black, borderWidth: CGFloat = 0) {
        self.init(frame: .zero)
        self.cornerRadius = cornerRadius
        self.shadowOffset = shadowOffset
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.shadowRadius = shadowRadius
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cornerRadius: CGFloat!
    var shadowOffset: CGSize!
    var shadowColor: UIColor!
    var shadowOpacity: Float!
    var borderColor: UIColor!
    var borderWidth: CGFloat!
    var shadowRadius: CGFloat!
    
    
    let imageView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        clipsToBounds = false
        backgroundColor = .clear
        
        self.layer.insertSublayer(shadowLayer, at: 0)
        
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.masksToBounds = true
        
        imageView.layer.borderWidth = borderWidth
        imageView.layer.borderColor = borderColor.cgColor
        
        shadowLayer.shadowPath = shapeAsPath
        shadowLayer.shadowOffset = shadowOffset
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowRadius
    }
    
    var shapeAsPath: CGPath {
        return UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath }
    
    lazy var shadowLayer: CALayer = {
        let shadowLayer = CALayer()
        guard let imageView = imageView.image else {return shadowLayer}

        
        return shadowLayer
    }()
    
    
}
