//
//  ReviewHorizontalController.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 23.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class ReviewHorizontalController: HorizontalSnappingController {
    
    let cellId = "cellId"
    let leadingTrailingPadding: CGFloat = 8.0
    let topBottomPadding: CGFloat = 8.0
    var reviews: Reviews? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ReviewDetailCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = .init(top: 0, left: leadingTrailingPadding, bottom: 0, right: leadingTrailingPadding)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews?.feed.entry.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ReviewDetailCell
        cell.entry = reviews?.feed.entry[indexPath.item]
        return cell
    }
}

extension ReviewHorizontalController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width * 0.95
        let height = view.frame.height
        return .init(width: width, height: height)
    }
    
}
