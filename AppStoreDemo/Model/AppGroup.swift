//
//  AppGroup.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 20.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import Foundation

struct AppsGroup: Codable, Hashable {
    let feed: Feed
}

struct Feed: Codable, Hashable {
    let title: String
    let results: [FeedResult]
}

struct FeedResult: Codable, Hashable {
    let artistName: String
    let name: String
    let artworkUrl100: String
    var id: String
}


/*
 -feed {
    -title: "",
    -results: [
 
        {
        -artistName: "",
        -name: "",
        -artworkUrl100: ""
        },
 
        {...}
    ]
 }
 */
