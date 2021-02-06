//
//  TodayCell.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 24.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class TodayCell: BaseTodayCell {
    
    override var todayItem: TodayItem? {
        didSet {
            if let todayItem = todayItem {
                imageView.image = todayItem.image
                categoryLabel.text = todayItem.category
                titleLabel.text = todayItem.title
                descriptionLabel.text = todayItem.description
                backgroundColor = todayItem.backgroundColor
                backgroundView?.backgroundColor = todayItem.backgroundColor
            }
        }
    }
    
    
    let imageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let categoryLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 26)
        label.textColor = .black
        return label
    }()
    
    let descriptionLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    var topConstraint: NSLayoutConstraint?
    
    override func setupLayout() {
        super.setupLayout()
        
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        imageView.clipsToBounds = true
        
        let imageContainerView = UIView()
        imageContainerView.addSubview(imageView.withSize(.init(width: 240, height: 240)))
        imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor).isActive = true
        
        let stackView = VerticalStackView(arrangedSubviews: [categoryLabel, titleLabel, imageContainerView, descriptionLabel], spacing: 8)
        addSubview(stackView)
        stackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 24, bottom: 24, right: 24))
        self.topConstraint = stackView.topAnchor.constraint(equalTo: topAnchor, constant: 24)
        topConstraint?.isActive = true
    }
    
}
