//
//  Service.swift
//  AppStoreDemo
//
//  Created by Andrei Volkau on 19.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import Foundation

class Service {
    
    static let shared = Service()
    
    func fetchGenericGroup<T: Codable>(url: URL, completion: @escaping (T?, Error?)->()) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
            }
            let jsonDecoder = JSONDecoder()
            guard let data = data else {return}
            
            do {
                let result = try jsonDecoder.decode(T.self, from: data)
                completion(result, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    //MARK: - SEARCH CONTROLLER
    func fetchApps(searchTerm: String, completion: @escaping (SearchResult?, Error?)->()) {
        let searchUrl = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        if let encodedURL = searchUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedURL) {
            print("valid url")
            fetchGenericGroup(url: url, completion: completion)
        } else {
           print("invalid url ")
        }
        
        
        
    }
    
    //MARK: - APPS CONTROLLER
    func fetchTopGrossing(completion: @escaping (AppsGroup?, Error?)->()) {
        guard let url = URL(string: "https://rss.itunes.apple.com/api/v1/by/ios-apps/top-grossing/all/25/explicit.json") else {return}
        fetchGenericGroup(url: url, completion: completion)
    }
    
    func fetchGames(completion: @escaping (AppsGroup?, Error?)->()) {
        guard let url = URL(string: "https://rss.itunes.apple.com/api/v1/by/ios-apps/new-games-we-love/all/25/explicit.json") else {return}
        fetchGenericGroup(url: url, completion: completion)
    }
    
    func fetchFree(completion: @escaping (AppsGroup?, Error?)->()) {
        guard let url = URL(string: "https://rss.itunes.apple.com/api/v1/by/ios-apps/top-free/all/25/explicit.json") else {return}
        fetchGenericGroup(url: url, completion: completion)
    }
    
    
    func fetchSocial(completion: @escaping ([Social]?, Error?)->()) {
        guard let socialURL = Bundle.main.url(forResource: "Social", withExtension: "json") else {return}
        fetchGenericGroup(url: socialURL, completion: completion)
    }
    
    
    
}




