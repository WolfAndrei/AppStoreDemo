//
//  MainTabController.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 19.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit


class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let todayVC = create(TodayController(), title: "Today", image: #imageLiteral(resourceName: "today_icon"))
        let appsVC = create(AppsController(), title: "Apps", image: #imageLiteral(resourceName: "apps"))
//        let appsVC = create(CompositionalController(), title: "Apps", image: #imageLiteral(resourceName: "apps"))
        let searchVC = create(SearchController(), title: "Search", image: #imageLiteral(resourceName: "search"))
        let musicVC = create(MusicController(), title: "Music", image: #imageLiteral(resourceName: "music"))
        viewControllers = [todayVC, musicVC, appsVC, searchVC]
        
    }

    fileprivate func create(_ viewController: UIViewController, title: String?, image: UIImage?) -> UINavigationController {
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        
        navigationController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.title = title
        
        setupNavBarAppearance(for: navigationController)
        return navigationController
    }
    
    
    fileprivate func setupNavBarAppearance(for navigationController: UINavigationController) {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navigationController.navigationBar.standardAppearance = navBarAppearance
            navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
    
    
}
