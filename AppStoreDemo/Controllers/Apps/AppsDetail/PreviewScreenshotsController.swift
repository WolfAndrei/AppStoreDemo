//
//  PreviewScreenshotsController.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 21.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class PreviewScreenshotsController: HorizontalSnappingController {
    
    let cellID = "cellid"
    let leadingTrailingPadding: CGFloat = 8.0
    let topBottomPadding: CGFloat = 8.0
    
    var appInfo: Result? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ScreenShotCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.contentInset = .init(top: 0, left: leadingTrailingPadding, bottom: 0, right: leadingTrailingPadding)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appInfo?.screenshotUrls?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ScreenShotCell
        cell.screenshotUrl = appInfo?.screenshotUrls?[indexPath.row]
        return cell
    }
    
}

extension PreviewScreenshotsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 250, height: view.frame.height)
    }
    
    
}
