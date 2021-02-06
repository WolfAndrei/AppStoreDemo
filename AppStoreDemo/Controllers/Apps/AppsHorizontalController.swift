//
//  AppsHorizontalController.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 20.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class AppsHorizontalController: HorizontalSnappingController {
    
    let cellId = "cellid"
    let minimumLineSpacing: CGFloat = 8.0
    let minimumInteritemSpacing: CGFloat = 0.0
    let topBottomPadding: CGFloat = 5.0
    let leadingTrailingPadding: CGFloat = 8.0
    let numberOfItemsInColumn: CGFloat = 3.0
    
    var appGroup: AppsGroup?
    
    var didSelectAppWithID: ((String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .init(top: 0, left: leadingTrailingPadding, bottom: 0, right: leadingTrailingPadding)
    }
    
   
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appGroup?.feed.results.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppRowCell
        cell.appResult = appGroup?.feed.results[indexPath.row]
        return cell
    }
    
}


extension AppsHorizontalController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = (collectionView.bounds.height - (numberOfItemsInColumn - 1) * minimumInteritemSpacing - 2 * topBottomPadding) / numberOfItemsInColumn
        let width = collectionView.bounds.width * 0.9
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: topBottomPadding, left: 0, bottom: topBottomPadding, right: 0)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let selectedApp = appGroup?.feed.results[indexPath.item] {
            didSelectAppWithID?(selectedApp.id)
        }
    }
    
}
