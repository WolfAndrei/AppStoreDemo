//
//  AppDetailCell.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 21.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
import SDWebImage

class AppDetailCell: BaseCollectionViewCell {
    
    var appInfo: Result? {
        didSet {
            if let appInfo = appInfo {
                nameLabel.text = appInfo.trackName
                artistLabel.text = appInfo.artistName
                priceButton.setTitle(appInfo.formattedPrice, for: .normal)
                releaseNotesLabel.text = appInfo.releaseNotes
                versionlabel.text = appInfo.version
                guard let url = URL(string: appInfo.artworkUrl512 ?? "") else {return}
                appImageView.imageView.sd_setImage(with: url, completed: nil)
            }
        }
    }

    lazy var appImageView: ShadowImageView = {
        let iv = ShadowImageView(cornerRadius: 16, shadowOffset: .init(width: 4, height: 3), shadowColor: .black, shadowRadius: 2, shadowOpacity: 0.4, borderColor: .init(white: 0.3, alpha: 1), borderWidth: 0.1)
        return iv
    }()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.text = "App Name"
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        return label
    }()
    
    let artistLabel: UILabel = {
       let label = UILabel()
        label.text = "Artist Label"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    let priceButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemBackground
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        return button
    }()
    
    let whatsNewLabel: UILabel = {
         let label = UILabel()
          label.text = "What's New"
          label.font = .boldSystemFont(ofSize: 20)
          return label
    }()
    
    let versionlabel: UILabel = {
       let label = UILabel()
        label.text = "1.0.0"
        label.numberOfLines = 1
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    let releaseNotesLabel: UILabel = {
       let label = UILabel()
        label.text = "ReleaseNote"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    let separatorView: UIView = {
       let view = UIView()
        view.backgroundColor = .init(white: 0.95, alpha: 1)
        return view
    }()
    
    override func setupLayout() {
        super.setupLayout()
        
        let verticalStackView = VerticalStackView(arrangedSubviews: [
            nameLabel,
            artistLabel,
            HorizontalStackView(arrangedSubviews: [
                priceButton.withSize(.init(width: 80, height: 36)),
                UIView()
            ], spacing: 12)
        ], spacing: 16, alignment: .fill, distribution: .fill)
        
        let horizontalStackView = HorizontalStackView(arrangedSubviews: [appImageView.withSize(.init(width: 140, height: 140)), verticalStackView], spacing: 20, alignment: .fill, distribution: .fill)
        
        let overallStackView = VerticalStackView(arrangedSubviews: [horizontalStackView, whatsNewLabel, versionlabel, releaseNotesLabel, separatorView.withHeight(1)], spacing: 12, alignment: .fill, distribution: .fill)
        
        addSubview(overallStackView)
        overallStackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 0, right: 0))
        
    }
    
    
}
