//
//  TodayController.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 24.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class TodayController: BaseViewController, UIGestureRecognizerDelegate {
    
    //MARK: - PROPERTIES
    let topPadding: CGFloat = 32
    let minLineSpacing: CGFloat = 32
    
    var anchoredConstraint: AnchoredContraints?
    var startingFrame: CGRect?
    var tabBarOffsetY: CGFloat = 100
    var detailTodayController: DetailTodayController!
    var detailView: UIView!
    static let cellHeight: CGFloat = 500
    var detailFullscreenbeginOffset: CGFloat = 0
    
   
    var items = [TodayItem]()
    
    //MARK: - UI ELEMENTS
    
    let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.tintColor = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    //MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(blurVisualEffectView)
        view.addSubview(activityIndicatorView)
        blurVisualEffectView.alpha = 0
        blurVisualEffectView.fillSuperview()
        activityIndicatorView.fillSuperview()
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppsCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
        collectionView.contentInset.top = topPadding
        navigationController?.isNavigationBarHidden = true
        fetchData()
    }
    
    deinit {
        print("tabBarController.tabBar")
    }
    
    //MARK: - COLLECTION VIEW METHODS
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellId = items[indexPath.item].cellType.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
        cell.todayItem = items[indexPath.item]
        
        (cell as? TodayMultipleAppsCell)?.multipleAppsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch items[indexPath.item].cellType {
        case .multiple:
            showDailyListFullScreen(indexPath)
        case .single:
            showingSingleAppFullScreen(indexPath)
        }
    }
    
    //MARK: - USER INTERECTIONS
    
    @objc func handleMultipleAppsTap(gesture: UITapGestureRecognizer) {
        
        guard let indexPath = collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {return}
        let apps = items[indexPath.row].apps
        
        let fullController = TodayMultipleAppsController(mode: .fullscreen)
        fullController.results = apps
        let fullScreenNavController = BackEnabledNavigationController(rootViewController: fullController)
        fullScreenNavController.modalPresentationStyle = .fullScreen
        
        present(fullScreenNavController, animated: true, completion: nil)
        
    }
    
    //MARK: - CUSTOM METHOS
    
    fileprivate func showDailyListFullScreen(_ indexPath: IndexPath) {
        let fullController = TodayMultipleAppsController(mode: .fullscreen)
        fullController.results = items[indexPath.item].apps
        let todayNavController = BackEnabledNavigationController(rootViewController: fullController)
        todayNavController.modalPresentationStyle = .fullScreen
        present(todayNavController, animated: true, completion: nil)
    }
    
    fileprivate func fetchData() {
        
        let dispachGroup = DispatchGroup()
        var topGrossingGroup: AppsGroup?
        var gamesGroup: AppsGroup?
        
        dispachGroup.enter()
        Service.shared.fetchTopGrossing { (appGroup, error) in
            dispachGroup.leave()
            if let error = error {
                print(error.localizedDescription)
            }
            topGrossingGroup = appGroup
        }
        
        dispachGroup.enter()
        Service.shared.fetchGames { (appGroup, error) in
            dispachGroup.leave()
            if let error = error {
                print(error.localizedDescription)
            }
            gamesGroup = appGroup
        }
        
        dispachGroup.notify(queue: .main) {
            
            self.items = [
                TodayItem(category: "LIFE HACK", title: "Utilizing your Time", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white, apps: [], cellType: .single),
                TodayItem(category: "THE DAILY LIST", title: topGrossingGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, apps: topGrossingGroup?.feed.results ?? [], cellType: .multiple),
                TodayItem(category: "THE DAILY LIST", title: gamesGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, apps: gamesGroup?.feed.results  ?? [], cellType: .multiple),
                
                TodayItem(category: "HOLIDAYS", title: "Travel on a Budget", image: #imageLiteral(resourceName: "holiday"), description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: #colorLiteral(red: 0.9859884381, green: 0.9637209773, blue: 0.727026701, alpha: 1), apps: [], cellType: .single)
            ]
            
            self.activityIndicatorView.stopAnimating()
            self.collectionView.reloadData()
        }
    }
      var isOpening = true
}

//MARK: - EXTENSIONS

extension TodayController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.frame.width * 0.8
        let height: CGFloat = TodayController.cellHeight
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: topPadding, left: 0, bottom: topPadding, right: 0)
    }
    
}

//MARK: - ANIMATION

extension TodayController {
    
    fileprivate func setupAppFullscreenController(_ indexPath: IndexPath) {
        let detailTodayController = DetailTodayController()
        detailTodayController.todayItem = items[indexPath.item]
        detailTodayController.handleDismiss = {
            self.handleTap()
        }
        detailTodayController.view.layer.cornerRadius = 16
        detailTodayController.view.layer.masksToBounds = true
        
        self.detailTodayController = detailTodayController
        
        //gesture
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        gesture.delegate = self
        detailTodayController.tableView.addGestureRecognizer(gesture)
    }

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        if detailTodayController.tableView.contentOffset.y > 0 {
            return
        }
        
        let translationY = gesture.translation(in: detailTodayController.tableView).y
        
        let trueOffset = translationY - detailFullscreenbeginOffset
        let scale = max(0.3, min(1, 1 - trueOffset / 1000))
        
        switch gesture.state {
        case .began:
            detailFullscreenbeginOffset = detailTodayController.tableView.contentOffset.y
        case .changed:
            if translationY > 0 {
                let transform = CGAffineTransform(scaleX: scale, y: scale)
                detailTodayController.view.transform = transform
                blurVisualEffectView.alpha = max(1, translationY / 1000)
                detailTodayController.view.layer.cornerRadius = 16 / scale
            }
        case .ended:
            fallthrough
        case .failed:
            fallthrough
        case .cancelled:
            if scale < 0.6 {
                handleTap()
            } else {
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    self.detailTodayController.view.transform = .identity
                }, completion: nil)
            }
        default:
            ()
        }
        
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    fileprivate func startingCellFrame(_ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {return}
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else {return}
        self.startingFrame = startingFrame
    }
    
    
    fileprivate func setupAppFullScreenStartingPosition(_ indexPath: IndexPath) {
        detailView = detailTodayController.view!
        
        self.collectionView.isUserInteractionEnabled = false
        view.addSubview(detailView)
        addChild(detailTodayController)
        
        startingCellFrame(indexPath)
        
        guard let startingFrame = startingFrame else {return}
        
        self.anchoredConstraint = detailView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, size: .init(width: startingFrame.width, height: startingFrame.height), padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0))
        
        view.layoutIfNeeded()
    }

    
    fileprivate func beginAnimationAppFullscreen() {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            self.anchoredConstraint?.top?.constant = 0
            self.anchoredConstraint?.leading?.constant = 0
            self.anchoredConstraint?.width?.constant = self.view.frame.width
            self.anchoredConstraint?.height?.constant = self.view.frame.height
            
            self.view.layoutIfNeeded()
            
            self.tabBarController?.tabBar.frame = self.tabBarController!.tabBar.frame.offsetBy(dx: 0, dy: self.tabBarOffsetY)
            
            self.detailView.layer.cornerRadius = 0
            
            guard let cell = self.detailTodayController.tableView.cellForRow(at: [0, 0]) as? DetailAppHeaderCell else {return}
            cell.todayCell.topConstraint?.constant = 48
            cell.layoutIfNeeded()
        })
    }
    
    
    fileprivate func showingSingleAppFullScreen(_ indexPath: IndexPath) {
        setupAppFullscreenController(indexPath)
        setupAppFullScreenStartingPosition(indexPath)
        beginAnimationAppFullscreen()
    }
    
    fileprivate func handleTap() {
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            guard let startingFrame = self.startingFrame else {return}
            
            self.detailTodayController.view.transform = .identity
            self.blurVisualEffectView.alpha = 0
            self.anchoredConstraint?.top?.constant = startingFrame.origin.y
            self.anchoredConstraint?.leading?.constant = startingFrame.origin.x
            self.anchoredConstraint?.width?.constant = startingFrame.width
            self.anchoredConstraint?.height?.constant = startingFrame.height
            
            self.view.layoutIfNeeded()
            
            self.tabBarController?.tabBar.frame = self.tabBarController!.tabBar.frame.offsetBy(dx: 0, dy: -self.tabBarOffsetY)
            
            self.detailTodayController.view.layer.cornerRadius = 16
            
            self.detailTodayController.tableView.contentOffset = .zero
            self.detailTodayController.dismissButton.alpha = 0
            
            guard let cell = self.detailTodayController.tableView.cellForRow(at: [0,0]) as? DetailAppHeaderCell else {return}
            cell.todayCell.topConstraint?.constant = 24
            cell.layoutIfNeeded()
        }) { (_) in
            self.detailTodayController.view.removeFromSuperview()
            self.detailTodayController.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        }
    }
}









