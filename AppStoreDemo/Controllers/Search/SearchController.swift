//
//  SearchController.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 19.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit


class SearchController: BaseViewController {
    
    //MARK: - PROPERTIES
    fileprivate var timer: Timer?
    fileprivate let cellId = "Cellid"
    fileprivate var appResults = [Result]()
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.keyboardDismissMode = .interactive
        setupLayout()
        setupSearchBar()
    }
    
    //MARK: - UI
    
    let enterSearchLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter search term above..."
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    //MARK: - CUSTOM METHODS

    fileprivate func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    fileprivate func setupLayout() {
        collectionView.addSubview(enterSearchLabel)
        enterSearchLabel.fillSuperview(padding: .init(top: 100, left: 50, bottom: 0, right: 50))   
    }
    
    //MARK: - TABLE VIEW METHODS
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        enterSearchLabel.isHidden = appResults.count == 0 ? false : true
        return appResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCell
        let result = appResults[indexPath.item]
        cell.result = result
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appId = String(appResults[indexPath.item].trackId)
        let detailVC = DetailAppController(appId: appId)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}


//MARK: - EXTENSIONS

extension SearchController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.bounds.width, height: 350)
    }
    
}


extension SearchController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            Service.shared.fetchApps(searchTerm: searchText) { (searchResult, error) in
                if let error = error {
                    print("Failed to fetch apps:", error.localizedDescription)
                }
                guard let searchResult = searchResult else {return}
                self.appResults = searchResult.results
                DispatchQueue.main.async {
                    
                    self.collectionView.reloadData()
                    
                    self.collectionView.setContentOffset(CGPoint(x: 0, y: -(self.navigationController?.navigationBar.bounds.height)! - self.searchController.searchBar.bounds.height), animated: false)
                    
                }
            }
        })
    }
    
    
}


//
//fileprivate func fetchApps() {
//    Service.shared.fetchApps(searchTerm: "twitter") {[unowned self] (searchResult, error) in
//        if let error = error {
//            print(error.localizedDescription)
//        }
//        guard let searchResult = searchResult else {return}
//        self.appResults = searchResult.results
//        DispatchQueue.main.async {
//            self.collectionView.reloadData()
//        }
//    }
//}
//
