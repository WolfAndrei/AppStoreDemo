//
//  ReviewDetailCell.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 23.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class ReviewDetailCell: BaseCollectionViewCell {
    
    var entry: Entry? {
        didSet {
            if let entry = entry {
                titleLabel.text = entry.title.label
                authorLabel.text = entry.author.name.label
                reviewTextView.text = entry.content.label
                
                count = Int(entry.rating.label)!
                for (index, starView) in starStackView.arrangedSubviews.enumerated() {
                    if let ratingInt = Int(entry.rating.label) {
                        starView.alpha = ratingInt > index ? 1 : 0
                    }
                }
            }
        }
    }
    
    
    var count = 0
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Review title"
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    lazy var authorLabel: UILabel = {
       let label = UILabel()
        label.text = "Author name"
        label.font = .systemFont(ofSize: 16)
        if traitCollection.userInterfaceStyle == .dark {
            label.textColor = .black
        } else {
           label.textColor = .lightGray
        }
        return label
    }()
    
    lazy var starStackView: HorizontalStackView = {
        var stars = [UIImageView]()
        for _ in 0..<5 {
            let iv = UIImageView(image: #imageLiteral(resourceName: "star"))
            iv.contentMode = .scaleAspectFit
            iv.withWidth(24)
            stars.append(iv)
        }
        let stackView = HorizontalStackView(arrangedSubviews: stars, spacing: 0, alignment: .fill, distribution: .fillEqually).withHeight(24)
        return stackView as! HorizontalStackView
    }()
    
    let reviewTextView: UITextView = {
       let tv = UITextView()
        tv.text = "Review body\nNew line"
        tv.isEditable = false
        tv.backgroundColor = .clear
        tv.isSelectable = false
        tv.textColor = .black
        tv.font = .systemFont(ofSize: 16)
        return tv
    }()
    
    let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func setupLayout() {
        super.setupLayout()
        
        backgroundColor = .init(white: 0.95, alpha: 1)
        layer.cornerRadius = 15
        clipsToBounds = true
        
        let stackView = VerticalStackView(arrangedSubviews:
            [HorizontalStackView(arrangedSubviews: [titleLabel, authorLabel], spacing: 8, alignment: .fill, distribution: .fill),
             HorizontalStackView(arrangedSubviews: [starStackView, UIView()]),
             containerView
            ],spacing: 12, alignment: .fill, distribution: .fill)
        
        containerView.addSubview(reviewTextView)
        reviewTextView.fillSuperview()
        stackView.withHeight(self.frame.height - 30)
        
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        authorLabel.textAlignment = .right
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
    }
    
    
}
