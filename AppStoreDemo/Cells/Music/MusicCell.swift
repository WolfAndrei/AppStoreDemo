//
//  MusicCell.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 26.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
import SDWebImage

class MusicCell: BaseCollectionViewCell {
    
    var result: Result? {
        didSet {
            if let result = result {
                if let url = URL(string: result.artworkUrl100) {
                    artistImageView.sd_setImage(with: url, completed: nil)
                }
                
                trackLabel.text = result.trackName
                overallLabel.text = "\(result.artistName) • \(result.collectionName?.capitalized ?? "No album") • \(result.primaryGenreName.capitalized)"
                
            }
        }
    }
    
    let artistImageView: UIImageView = {
       let iv = UIImageView()
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemPink
        return iv
    }()
    
    let trackLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Shake it off"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    let overallLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.text = "Taylor Swift • 1989 • Pop"
        return label
    }()
    
    let separatorView: UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    override func setupLayout() {
        super.setupLayout()
        
        
        let stackView = HorizontalStackView(
            arrangedSubviews: [
                artistImageView.withSize(.init(width: 80, height: 80)),
                VerticalStackView(arrangedSubviews: [trackLabel, overallLabel], spacing: 4, alignment: .fill, distribution: .fill)
        ], spacing: 16, alignment: .center, distribution: .fill)
        
        addSubview(stackView)
        addSubview(separatorView)
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        separatorView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, size: .init(width: 0, height: 0.5), padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        
    }
    
    
    
}

