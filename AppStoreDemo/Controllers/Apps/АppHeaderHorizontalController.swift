//
//  АppHeaderHorizontalController.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 20.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class AppHeaderHorizontalController: HorizontalSnappingController {
    
    let cellId = "cellId"
    let minimumLineSpacing: CGFloat = 8.0
    let minimumInteritemSpacing: CGFloat = 0.0
    let topBottomPadding: CGFloat = 5.0
    let leadingTrailingPadding: CGFloat = 8.0
    
    var didSelectAppWithID: ((String)->())?
    var social = [Social]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(AppHeaderCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = .init(top: 0, left: leadingTrailingPadding, bottom: 0, right: leadingTrailingPadding)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return social.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppHeaderCell
        cell.socialApp = social[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedApp = social[indexPath.item]
        didSelectAppWithID?(selectedApp.id)
        
    }
    
}


extension AppHeaderHorizontalController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height - 2 * topBottomPadding
        let width = collectionView.bounds.width * 0.9
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: topBottomPadding, left: 0, bottom: topBottomPadding, right: 0)
    }
}
