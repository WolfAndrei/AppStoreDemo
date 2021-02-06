//
//  TodayMultipleAppsController.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 25.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit


class TodayMultipleAppsController: BaseViewController {
   
    enum Mode {
         case small, fullscreen
     }
     
     init(mode: Mode) {
         self.mode = mode
         super.init()
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    fileprivate let cellID = "cellID"
    fileprivate let spacing: CGFloat = 5
    fileprivate let numberOfItemsInRow: CGFloat = 4
    fileprivate let mode: Mode
    
    var results = [FeedResult]()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: cellID)
        if mode == .fullscreen {
            navigationController?.isNavigationBarHidden = true
//or just use another approach with standard UINavigationController
//navigationController?.navigationBar.isHidden = true
            
           setupLayout()
        } else {
            collectionView.isScrollEnabled = false
        }
    }
    
    override var prefersStatusBarHidden: Bool {return true}
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if mode == .fullscreen {
            return results.count
        }
        return min(4, results.count)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MultipleAppCell
        cell.result = results[indexPath.item]
        return cell
    }
    
    fileprivate func setupLayout() {
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 44, height: 44), padding: .init(top: 0, left: 0, bottom: 0, right: 8))
    }
    
}

extension TodayMultipleAppsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat
        var width: CGFloat
        if mode == .small {
            height = (collectionView.bounds.height - spacing * (numberOfItemsInRow - 1)) / numberOfItemsInRow
            width = view.frame.width
        } else {
            height = 76
            width = view.frame.width - 48
        }
        return .init(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if mode == .fullscreen {
            return .init(top: 40, left: 24, bottom: 12, right: 24)
        }
        return .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let appId = results[indexPath.item].id
        let detailAppController = DetailAppController(appId: appId)
        navigationController?.pushViewController(detailAppController, animated: true)
    }
    
    
}
