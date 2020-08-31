//
//  NewsClient.swift
//  NewsApp
//
//  Created by Максим Семений on 29.08.2020.
//  Copyright © 2020 Максим Семений. All rights reserved.
//

import Foundation

class NewsClient: NSObject {
    func fetchNews(from string: String, completed: @escaping((News) -> ())) {
        guard let url = URL(string: string) else {
            print("Invalid url link")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                let json = try JSONDecoder().decode(News.self, from: data)
                completed(json)
            } catch {
                fatalError()
            }
        }.resume()
    }
}
