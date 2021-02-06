//
//  DetailAppController.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 21.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class DetailAppController: BaseViewController {
    
    fileprivate let appId: String
    
    init(appId: String) {
        self.appId = appId
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var appInfo: Result?
    var reviews: Reviews?
    let cellId = "Cellid"
    let previewCellId = "previewCellId"
    let reviewCellId = "reviewCellId"
    let topBottomPadding: CGFloat = 16.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        navigationItem.largeTitleDisplayMode = .never
        collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: previewCellId)
        collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: reviewCellId)
        fetchData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppDetailCell
            cell.appInfo = appInfo
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewCellId, for: indexPath) as! PreviewCell
            cell.previewScreenshotsController.appInfo = appInfo
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellId, for: indexPath) as! ReviewCell
            cell.reviewHorizontalController.reviews = reviews
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}


extension DetailAppController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.item {
        case 0:
            let width = view.frame.width
            
            let cell = AppDetailCell(frame: CGRect(x: 0, y: 0, width: width, height: 1000))
            cell.appInfo = appInfo
            cell.layoutIfNeeded()
            
            let targetSize = CGSize(width: width, height: 1000)
            let estSize = cell.systemLayoutSizeFitting(targetSize)
            let height = estSize.height
            
            return .init(width: width, height: height)
        case 1:
            return .init(width: view.frame.width, height: 500)
        case 2:
            return .init(width: view.frame.width, height: 300)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return . init(top: 0, left: 0, bottom: topBottomPadding, right: 0)
    }
    
}

//MARK: - FETCHING THE DATA FROM JSON

extension DetailAppController {
    
    fileprivate func fetchData() {
        let dispatchGroup = DispatchGroup()
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(appId)") else {return}
        dispatchGroup.enter()
        Service.shared.fetchGenericGroup(url: url) { (appInfo: SearchResult?, error) in
            dispatchGroup.leave()
            if let error = error {
                print(error.localizedDescription)
            }
            self.appInfo = appInfo?.results.first
        }
        guard let reviewUrl = URL(string: "https://itunes.apple.com/us/rss/customerreviews/page=1/id=\(appId)/sortby=mostrecent/json") else {return}
        dispatchGroup.enter()
        Service.shared.fetchGenericGroup(url: reviewUrl) { (reviews: Reviews?, error) in
            dispatchGroup.leave()
            if let error = error {
                print(error.localizedDescription)
            }
            self.reviews = reviews
        }
        
        dispatchGroup.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }
}
