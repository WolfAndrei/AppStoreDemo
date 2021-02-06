//
//  DetailTodayController.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 24.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
let statusBarHeight = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

class DetailTodayController: UIViewController {
    
    var handleDismiss: (()->())?
    var todayItem: TodayItem?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset.bottom = statusBarHeight
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        setupFloatingView()
    }
    
    deinit {
        print("deinit")
    }
    
    let floatView = UIView()
    var anchoredConstraints: AnchoredContraints?
    
    fileprivate func setupFloatingView() {
        floatView.layer.cornerRadius = 15
        floatView.layer.masksToBounds = true
        
        view.addSubview(floatView)
        
//        let height = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame.height
        
        anchoredConstraints = floatView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 90), padding: .init(top: 0, left: 20, bottom: -90, right: 20))
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.image = todayItem?.image
        
        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.text = todayItem?.category.capitalized
        
        let categoryLabel = UILabel()
        categoryLabel.font = .systemFont(ofSize: 16)
        categoryLabel.text = todayItem?.title
        
        let getButton = UIButton(type: .system)
        getButton.setTitle("GET", for: .normal)
        getButton.tintColor = .white
        getButton.backgroundColor = .darkGray
        getButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        getButton.layer.cornerRadius = 15
        getButton.layer.masksToBounds = true
        
        let stackView = HorizontalStackView(
            arrangedSubviews: [
                imageView.withSize(.init(width: 70, height: 70)),
                VerticalStackView(arrangedSubviews: [titleLabel, categoryLabel], spacing: 12),
                getButton.withSize(.init(width: 70, height: 30))
            ], spacing: 12, alignment: .center, distribution: .fill)

        floatView.addSubview(blurView)
        floatView.addSubview(stackView)
        blurView.fillSuperview()
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            let translationY = -90 - statusBarHeight
            self.floatView.transform = scrollView.contentOffset.y > 100 ? CGAffineTransform(translationX: 0, y: translationY) : .identity
        }, completion: nil)
        
    }
    
    @objc func handleTap(button: UIButton) {
        handleDismiss?()
    }
    

    
    fileprivate func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(dismissButton)
        tableView.fillSuperview()
        dismissButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 80, height: 38), padding: .init(top: 40, left: 0, bottom: 0, right: 12))
    }
}


extension DetailTodayController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = DetailAppHeaderCell()
            cell.todayCell.todayItem = todayItem
            cell.clipsToBounds = true
            return cell
        default:
            let cell = DetailTodayCell()
            cell.backgroundColor = todayItem?.backgroundColor
            tableView.backgroundColor = todayItem?.backgroundColor
            view.backgroundColor = todayItem?.backgroundColor
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return TodayController.cellHeight
        default:
            return UITableView.automaticDimension
        }
    }
    
}
