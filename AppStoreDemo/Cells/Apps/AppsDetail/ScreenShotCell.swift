//
//  ScreenShotCell.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 21.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
import SDWebImage

class ScreenShotCell: BaseCollectionViewCell {
    
    var screenshotUrl: String? {
        didSet {
            guard let screenshotUrl = URL(string: screenshotUrl ?? "") else { return}
            imageView.sd_setImage(with: screenshotUrl, completed: nil)
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        return iv
    }()
    
    override func setupLayout() {
        super.setupLayout()
        
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    
}
