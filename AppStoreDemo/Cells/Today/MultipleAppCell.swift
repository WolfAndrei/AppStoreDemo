//
//  MultipleAppCell.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 25.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
import SDWebImage

class MultipleAppCell: BaseCollectionViewCell {
    
    var result: FeedResult? {
        didSet {
            if let result = result {
                appNameLabel.text = result.name
                appCategoryLabel.text = result.artistName
                guard let url = URL(string: result.artworkUrl100) else {return}
                appImageView.sd_setImage(with: url, completed: nil)
            }
        }
    }
     
        //MARK: - UI
        
        let appImageView: UIImageView = {
            let iv = UIImageView()
            iv.layer.cornerRadius = 12
            iv.layer.masksToBounds = true
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
