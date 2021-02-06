//
//  MusicController.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 26.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class MusicController: BaseViewController {
    
    let cellID = "cellid"
    let footerID = "footerID"
    var results = [Result]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MusicCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(MusicFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerID)
        fetchData(offset: offset) { (results) in
            self.results = results
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var offset = 0
    var limit = 20
    let searchTerm = "taylor"
    
    fileprivate func fetchData(offset: Int, completion: @escaping ([Result])->()) {
        
        let stringURL = "https://itunes.apple.com/search?term=\(searchTerm)&offset=\(offset)&limit=\(limit)"
        guard let url = URL(string: stringURL) else {return}
        Service.shared.fetchGenericGroup(url: url) { (musicResult: SearchResult?, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let results = musicResult?.results {
              completion(results)
            }
        }
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    var isPaginating = false
    var isDonePaginating = false
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MusicCell
        cell.result = results[indexPath.item]
        
        if indexPath.item == results.count - 1 && !isPaginating {
            isPaginating = true
            fetchData(offset: results.count) { results in
                if results.count == 0 {
                    self.isDonePaginating = true
                }
                sleep(2)
                self.results += results
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                self.isPaginating = false
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerID, for: indexPath) as! MusicFooterView
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: isDonePaginating ? 0 : 100)
    }
    
}

extension MusicController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 90)
    }
    
    
}
