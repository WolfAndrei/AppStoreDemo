//
//  TodayItem.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 25.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit


struct TodayItem {
    let category: String
    let title: String
    let image: UIImage
    let description: String
    let backgroundColor: UIColor
    
    //enum
    
    let apps: [FeedResult]
    
    let cellType: CellType
    
    enum CellType: String {
        case single, multiple
    }
    
    
}
