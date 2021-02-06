//
//  AppRowCell.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 20.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
import SDWebImage

class AppRowCell: BaseCollectionViewCell {
    
    //MARK: - PROPERTIES
    
    var appResult: FeedResult? {
        didSet {
            if let appResult = appResult {
                if let appResultURL = URL(string: appResult.artworkUrl100) {
                    appImageView.sd_setImage(with: appResultURL, completed: nil)
                }
                appNameLabel.text = appResult.name
                appCategoryLabel.text = appResult.artistName
            }
        }
    }
    
    //MARK: - UI
    
    let appImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 12
        iv.layer.masksToBounds = true
        iv.backgroundColor = .blue
        return iv
    }()
    
    let appNameLabel: UILabel = {
       let label = UILabel(text: "App\nName", font: .systemFont(ofSize: 19))
        label.numberOfLines = 0
        return label
    }()
    
    let appCategoryLabel: UILabel = {
       let label = UILabel(text: "Photo & Video", font: .systemFont(ofSize: 12))
        label.textColor = .lightGray
        return label
    }()
    
    let getButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("GET", for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .init(white: 0.95, alpha: 1)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        return button
    }()
    
    let separatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = .init(white: 0.95, alpha: 1)
        return separator
    }()
    
    //MARK: - CUSTOM METHODS
    
    override func setupLayout() {
        super.setupLayout()
        
        let labelsStackView = VerticalStackView(arrangedSubviews: [appNameLabel, appCategoryLabel], spacing: 4)
        let labelsButtonStackView = HorizontalStackView(arrangedSubviews: [labelsStackView, getButton.withSize(.init(width: 70, height: 30))], spacing: 12, alignment: .center)
        
        let separatorStackView = VerticalStackView(arrangedSubviews: [labelsButtonStackView, separatorView.withHeight(0.5)], spacing: 10)
        
        let imageStackView = VerticalStackView(arrangedSubviews: [appImageView.withSize(.init(width: 64, height: 64)), UIView().withHeight(0.5)], spacing: 10)
        
        let overallStackView = HorizontalStackView(arrangedSubviews: [imageStackView, separatorStackView], spacing: 20, alignment: .center)
        
        getButton.layer.cornerRadius = 15
        getButton.layer.masksToBounds = true
        
        addSubview(overallStackView)
        overallStackView.fillSuperview()
    }
    
}
