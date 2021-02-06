//
//  DetailAppHeaderCell.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 24.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class DetailAppHeaderCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let todayCell = TodayCell()

    fileprivate func setupLayout() {
        todayCell.layer.cornerRadius = 0
        addSubview(todayCell)
        todayCell.fillSuperview()

    }
    
}
