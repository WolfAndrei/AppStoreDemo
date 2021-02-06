//
//  AppHeaderCell.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 20.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
import SDWebImage

class AppHeaderCell: BaseCollectionViewCell {
    
    var socialApp: Social? {
        didSet {
            if let socialApp = socialApp {
                companyLabel.text = socialApp.name
                titleLabel.text = socialApp.tagLine
                if let socialAppURL = URL(string: socialApp.imageUrl) {
                    imageView.sd_setImage(with: socialAppURL, completed: nil)
                }
            }
        }
    }
    
    let companyLabel: UILabel = {
        let label = UILabel(text: "Facebook", font: .boldSystemFont(ofSize: 12))
        label.textColor = .systemBlue
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(text: "Keeping up with friends is faster than ever", font: .systemFont(ofSize: 24))
        label.numberOfLines = 2
        return label
    }()
    
    let imageView: UIImageView = {
       let iv = UIImageView()
        iv.layer.cornerRadius = 12
        iv.layer.masksToBounds = true
        iv.image = #imageLiteral(resourceName: "holiday")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    
    override func setupLayout() {
        super.setupLayout()
        
        let stackView = VerticalStackView(arrangedSubviews: [companyLabel, titleLabel, imageView], spacing: 12, alignment: .fill, distribution: .fill)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 16, left: 0, bottom: 0, right: 0))
    }
    
    
    
    
}
