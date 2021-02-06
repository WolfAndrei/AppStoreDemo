//
//  SearchResult.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 19.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import Foundation

struct SearchResult: Codable {
    let resultCount: Int
    let results: [Result]
}

struct Result: Codable {
    let trackId: Int
    let trackName: String
    let primaryGenreName: String
    var averageUserRating: Double?
    let artworkUrl100: String
    var screenshotUrls: [String]?
    var formattedPrice: String?
    var version: String?
    var description: String?
    var releaseNotes: String?
    let artistName: String
    var artworkUrl512: String?
    var collectionName: String?
}

