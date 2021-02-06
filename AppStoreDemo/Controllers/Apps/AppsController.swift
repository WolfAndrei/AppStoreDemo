//
//  AppsController.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 20.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit


class AppsController: BaseViewController {
    
    //MARK: - PROPERTIES
    
    let cellId = "cellID"
    let headerId = "headerID"
    var social = [Social]()
    var groups = [AppsGroup]()
    
    let activityIndicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .black
        aiv.hidesWhenStopped = true
        aiv.startAnimating()
        return aiv
    }()
      
    //MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(AppsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        view.addSubview(activityIndicator)
        activityIndicator.fillSuperview()
    }
    
    //MARK: - CUSTOM METHODS
    
    fileprivate func fetchData() {
        
        var group1: AppsGroup?
        var group2: AppsGroup?
        var group3: AppsGroup?
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        
        Service.shared.fetchTopGrossing { (appGroup, error) in
            dispatchGroup.leave()
            if let error = error {
                print(error)
            }
            group1 = appGroup
        }
        
        dispatchGroup.enter()
        Service.shared.fetchGames { (appGroup, error) in
            dispatchGroup.leave()
            if let error = error {
                print(error)
            }
            group2 = appGroup
        }
        
        dispatchGroup.enter()
        Service.shared.fetchFree { (appGroup, error) in
            dispatchGroup.leave()
            if let error = error {
                print(error)
            }
            group3 = appGroup
        }
        
        dispatchGroup.enter()
        Service.shared.fetchSocial { (social, error) in
            dispatchGroup.leave()
            if let error = error {
               print(error)
            }
            self.social = social ?? []
        }
        
        //completion
        dispatchGroup.notify(queue: .main) {
            self.activityIndicator.stopAnimating()
            
            if let group = group1 {
                self.groups.append(group)
            }
            if let group = group2 {
                self.groups.append(group)
            }
            if let group = group3 {
                self.groups.append(group)
            }
            self.collectionView.reloadData()
            
            print("completed dispatch group tasks.....")
        }
        
        
    }
    
    
    //MARK: - TABLE VIEW METHODS
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppsGroupCell
        cell.appGroup = groups[indexPath.item]
        cell.horizontalController.didSelectAppWithID = {[unowned self] feedResultID in
            let selectedAppVC = DetailAppController(appId: feedResultID)
            self.navigationController?.pushViewController(selectedAppVC, animated: true)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppsHeaderView
        header.appHeaderHorizontalController.social = self.social
        header.appHeaderHorizontalController.didSelectAppWithID = {[unowned self] feedResultID in
            let selectedAppVC = DetailAppController(appId: feedResultID)
            self.navigationController?.pushViewController(selectedAppVC, animated: true)
        }
        header.appHeaderHorizontalController.collectionView.reloadData()
        return header
    }
    
}

extension AppsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.bounds.width, height: 340)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.bounds.width, height: 300)
        
    }
    
}

