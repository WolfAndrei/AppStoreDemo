//
//  Reviews.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 23.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import Foundation

struct Reviews: Codable {
    let feed: ReviewFeed
}

struct ReviewFeed: Codable {
    let entry: [Entry]
}

struct Entry: Codable {
    let title: Label
    let content: Label
    let author: Author
    let rating: Label
    
    private enum CodingKeys: String, CodingKey {
        case author, title, content
        case rating = "im:rating"
    }
}

struct Label: Codable {
    let label: String
}

struct Author: Codable {
    let name: Label
}
