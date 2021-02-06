//
//  MusicFooterView.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 26.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class MusicFooterView: UICollectionReusableView {
    
    let activityIndicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.tintColor = .darkGray
        aiv.startAnimating()
        return aiv
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout() {
        
        let stackView = VerticalStackView(arrangedSubviews: [activityIndicator, label], spacing: 8).withWidth(frame.width)
        
        addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    
}
