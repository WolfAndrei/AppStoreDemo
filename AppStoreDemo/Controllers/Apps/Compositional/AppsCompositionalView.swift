//
//  AppsCompositionalView.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 26.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import SwiftUI

struct AppsWithSection: Hashable {
    let apps: AppsGroup?
    let section: CompositionalController.AppSection?
}

class CompositionalController: UICollectionViewController {
    
    init() {
        
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            
            if sectionNumber == 0 {
                return CompositionalController.topSection()
            } else {
                return CompositionalController.bottomSection()
            }
        }
        
        super.init(collectionViewLayout: layout)
    }
    
    let activityIndicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .black
        aiv.hidesWhenStopped = true
        aiv.startAnimating()
        return aiv
    }()
    
    var socialApps = [Social]()
    var games: AppsGroup?
    var topGrossing: AppsGroup?
    var topFree: AppsGroup?
//    var topFree: AppsWithSection?
    
    fileprivate func fetchApps() {
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        Service.shared.fetchSocial { (social, error) in
            dispatchGroup.leave()
            if let error = error {
                print(error.localizedDescription)
                return
            }
               self.socialApps = social ?? []
        }
        
        dispatchGroup.enter()
        Service.shared.fetchGames { (appGroup, error) in
            dispatchGroup.leave()
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.games = appGroup
        }
        
        dispatchGroup.enter()
        Service.shared.fetchTopGrossing { (appGroup, error) in
            dispatchGroup.leave()
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.topGrossing = appGroup
        }
        
        dispatchGroup.enter()
        Service.shared.fetchFree { (appGroup, error) in
            dispatchGroup.leave()
            if let error = error {
                print(error.localizedDescription)
                return
            }
//            self.topFree = appGroup
        }
        
        
        dispatchGroup.notify(queue: .main) {
            self.activityIndicator.stopAnimating()
            self.collectionView.reloadData()
        }
        
 
    }
    
    static func bottomSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1 / 3)))
        item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 16)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(300)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 16
        section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)]
        
        return section
    }
    
    static func topSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.bottom = 16
        item.contentInsets.trailing = 16
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(300)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 16
        return section
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cellID = "cellId"
    let smallCellId = "smallCellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        collectionView.register(AppHeaderCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: smallCellId)
        collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        navigationItem.title = "Apps"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navAppearance = UINavigationBarAppearance()
        
        navigationController?.navigationBar.standardAppearance = navAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Fetch top free", style: .plain, target: self, action: #selector(handleFetchTopFree))
        
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
//        fetchApps()
        view.addSubview(activityIndicator)
        activityIndicator.fillSuperview()
        
        setupDiffableDataSource()
        
    }
    @objc func handleRefresh() {
        collectionView.refreshControl?.endRefreshing()
        
        var snapshot = diffableDataSource.snapshot()
        
        snapshot.deleteSections([.topFree])
        diffableDataSource.apply(snapshot)
        
    }
    
    enum AppSection {
        case topSocial, grossing, games, topFree
    }
    
    lazy var diffableDataSource = UICollectionViewDiffableDataSource<AppSection, AnyHashable>(collectionView: collectionView) { (collectionView, indexPath, object) -> UICollectionViewCell? in
        
        if let object = object as? Social {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! AppHeaderCell
        
            cell.socialApp = object
            return cell
        } else if let object = object as? FeedResult {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.smallCellId, for: indexPath) as! AppRowCell
            
                cell.appResult = object
                cell.getButton.addTarget(self, action: #selector(self.handleDelete), for: .primaryActionTriggered)
                return cell
        } else if let object = object as? AppsWithSection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.smallCellId, for: indexPath) as! AppRowCell
            
            cell.appResult = object.apps?.feed.results[indexPath.item]
    
            cell.getButton.addTarget(self, action: #selector(self.handleDelete), for: .primaryActionTriggered)
            return cell
        }
        return nil
    }
    
    @objc func handleFetchTopFree() {
        
         Service.shared.fetchFree { (appGroup, error) in
             if let error = error {
                 print(error.localizedDescription)
                 return
             }
            
            var snapshot = self.diffableDataSource.snapshot()
            
            snapshot.insertSections([.topFree], afterSection: .topSocial)
            snapshot.appendItems(appGroup?.feed.results ?? [], toSection: .topFree)
            self.diffableDataSource.apply(snapshot)
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
         }
    }
    
    
    @objc func handleDelete(button: UIButton) {
        
        var superView = button.superview
        while superView != nil {
            if let cell = superView as? UICollectionViewCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else {return}
                guard let selectedObject = diffableDataSource.itemIdentifier(for: indexPath) else {return}
                var snapshot = diffableDataSource.snapshot()
                snapshot.deleteItems([selectedObject])
                diffableDataSource.apply(snapshot)
            }
            superView = superView?.superview
        }
        
       
    }
    
    fileprivate func setupDiffableDataSource () {
        
        collectionView.dataSource = diffableDataSource
        diffableDataSource.supplementaryViewProvider = .some({ (collectionView, kind, indexPath) -> UICollectionReusableView? in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerId, for: indexPath) as! CompositionalHeader
            
            let snapshot = self.diffableDataSource.snapshot()
            let object = self.diffableDataSource.itemIdentifier(for: indexPath)
            
            if let object = object {
                let title: String
                let section = snapshot.sectionIdentifier(containingItem: object as AnyHashable)
                switch section {
                case .games:
                    title = "Games"
                case .grossing:
                    title = "Top Grossing"
                case .topFree:
                    title = "Top Free"
                default:
                    title = ""
                }
                header.title = title
            }
            
            
            return header
            
        })
        
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        Service.shared.fetchSocial { (social, error) in
            dispatchGroup.leave()
            if let error = error {
                print(error.localizedDescription)
                return
            }
               self.socialApps = social ?? []
        }
        
        dispatchGroup.enter()
        Service.shared.fetchGames { (appGroup, error) in
            dispatchGroup.leave()
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.games = appGroup
        }
        
        dispatchGroup.enter()
        Service.shared.fetchTopGrossing { (appGroup, error) in
            dispatchGroup.leave()
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.topGrossing = appGroup
        }
        
        dispatchGroup.enter()
        Service.shared.fetchFree { (appGroup, error) in
            dispatchGroup.leave()
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.topFree = appGroup
        }
        
        
        dispatchGroup.notify(queue: .main) {
            self.activityIndicator.stopAnimating()
            
            var snapshot = self.diffableDataSource.snapshot()
            snapshot.appendSections([.topSocial, .grossing, .games, .topFree])
            snapshot.appendItems(self.socialApps, toSection: .topSocial)
            snapshot.appendItems(self.topGrossing?.feed.results ?? [], toSection: .grossing)
            snapshot.appendItems(self.games?.feed.results ?? [], toSection: .games)
            snapshot.appendItems(self.topFree?.feed.results ?? [], toSection: .topFree)
            self.diffableDataSource.apply(snapshot)
            
        }
        

    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = diffableDataSource.itemIdentifier(for: indexPath)
        let appId: String
        if let object = object as? Social {
            appId = object.id
        } else if let object  = object as? FeedResult {
            appId = object.id
        } else {
            appId = ""
        }
        
        let appDetailController = DetailAppController(appId: appId)
        navigationController?.pushViewController(appDetailController, animated: true)
    }
    
    
    
//
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! CompositionalHeader
//        let title: String
//        switch indexPath.section {
//        case 1:
//            title = games?.feed.title ?? ""
//        case 2:
//            title = topGrossing?.feed.title ?? ""
//        case 3:
//            title = topFree?.feed.title ?? ""
//        default:
//            title = ""
//        }
//        header.title = title
//        return header
//    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return socialApps.count
//        case 1:
//            return games?.feed.results.count ?? 0
//        case 2:
//            return topGrossing?.feed.results.count ?? 0
//        case 3:
//            return topFree?.feed.results.count ?? 0
//        default:
//            return 0
//        }
//
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        var appId: String
//
//        switch indexPath.section {
//        case 0:
//            appId = socialApps[indexPath.item].id
//        case 1:
//            appId = games?.feed.results[indexPath.item].id ?? ""
//        case 2:
//            appId = topGrossing?.feed.results[indexPath.item].id ?? ""
//        case 3:
//            appId = topFree?.feed.results[indexPath.item].id ?? ""
//        default:
//            appId = ""
//        }
//
//        let appDetailController = DetailAppController(appId: appId)
//        navigationController?.pushViewController(appDetailController, animated: true)
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        switch indexPath.section {
//        case 0:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AppHeaderCell
//            cell.socialApp = socialApps[indexPath.item]
//            return cell
//        case 1:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: smallCellId, for: indexPath) as! AppRowCell
//            cell.appResult = games?.feed.results[indexPath.item]
//            return cell
//        case 2:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: smallCellId, for: indexPath) as! AppRowCell
//            cell.appResult = topGrossing?.feed.results[indexPath.item]
//            return cell
//        case 3:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: smallCellId, for: indexPath) as! AppRowCell
//            cell.appResult = topFree?.feed.results[indexPath.item]
//            return cell
//        default :
//            return UICollectionViewCell()
//        }
//    }
    
    
}


class CompositionalHeader: UICollectionReusableView {
    
    var title: String! {
        didSet {
            titleLabel.text = title
        }
    }
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.font = .boldSystemFont(ofSize: 32)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



struct AppsView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = CompositionalController()
        return UINavigationController(rootViewController: controller)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = UIViewController
    
    
    
    
}

struct AppsCompositionalView_Previews: PreviewProvider {
    static var previews: some View {
        AppsView()
            .edgesIgnoringSafeArea(.all)
            .colorScheme(.dark)
    }
}
