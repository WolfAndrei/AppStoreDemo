//
//  SearchCell.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 19.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
import SDWebImage

class SearchCell: BaseCollectionViewCell {
    
    //MARK: - PROPERTIES
    
    var result: Result? {
        didSet {
            if let result = result {
                appNameLabel.text = result.trackName
                appCategoryLabel.text = result.primaryGenreName
                appRatingsLabel.text = "Rating: " + String(format: "%.1f", result.averageUserRating ?? 0)
                if let appIconUrl = URL(string: result.artworkUrl100) {
                    appImageView.sd_setImage(with: appIconUrl, completed: nil)
                }
                if let screen1URL = URL(string: result.screenshotUrls?[0] ?? "") {
                    screenshot1ImageView.sd_setImage(with: screen1URL, completed: nil)
                }
                if result.screenshotUrls!.count > 1 {
                    if let screen2URL = URL(string: result.screenshotUrls?[1] ?? "") {
                        screenshot2ImageView.sd_setImage(with: screen2URL, completed: nil)
                    }
                }
                if result.screenshotUrls!.count > 2 {
                    if let screen3URL = URL(string: result.screenshotUrls?[2] ?? "") {
                        screenshot3ImageView.sd_setImage(with: screen3URL, completed: nil)
                    }
                }
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
       let label = UILabel()
        label.text = "App Name"
       return label
    }()
    
    let appCategoryLabel: UILabel = {
       let label = UILabel()
        label.text = "Photo & Video"
       return label
    }()
    
    let appRatingsLabel: UILabel = {
       let label = UILabel()
        label.text = "9.2 M"
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
    
    lazy var screenshot1ImageView = createImageView()
    lazy var screenshot2ImageView = createImageView()
    lazy var screenshot3ImageView = createImageView()
    
    fileprivate func createImageView() -> UIImageView {
        
        let iv = UIImageView()
        iv.layer.cornerRadius = 8
        iv.layer.masksToBounds = true
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        iv.contentMode = .scaleAspectFill
        return iv
    }
    
    //MARK: - CUSTOM METHODS
    
    override func setupLayout() {
        super.setupLayout()
        
        let labelsStackView = VerticalStackView(arrangedSubviews: [appNameLabel, appCategoryLabel, appRatingsLabel])
        let topStackView = HorizontalStackView(arrangedSubviews: [appImageView, labelsStackView, getButton], spacing: 12, alignment: .center)
        let screenshotStackView = HorizontalStackView(arrangedSubviews: [screenshot1ImageView, screenshot2ImageView, screenshot3ImageView], spacing: 12, distribution: .fillEqually)
        let overallStackView = VerticalStackView(arrangedSubviews: [topStackView, screenshotStackView], spacing: 16)
        
        appImageView.withSize(.init(width: 64, height: 64))
        getButton.withSize(.init(width: 70, height: 30))
        getButton.layer.cornerRadius = 15
        getButton.layer.masksToBounds = true
        
        addSubview(overallStackView)
        overallStackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
}
