//
//  Persistence.swift
//  NewsApp
//
//  Created by Максим Семений on 29.08.2020.
//  Copyright © 2020 Максим Семений. All rights reserved.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let articles = "articles"
    }
    
    static func updateWith(article: Article, actionType: PersistenceActionType, completed: @escaping (NewsError?) -> Void) {
        retreiveArticles { (result) in
            switch result {
            case .success(var articles):
                switch actionType {
                case .add:
                    guard !articles.contains(article) else {
                        completed(.alreadyInBookmarks)
                        return
                    }
                    articles.append(article)
                    completed(save(articles: articles))
                case .remove:
                    articles.removeAll() { $0.title == article.title}
                    completed(save(articles: articles))
            }
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    
    static func retreiveArticles(completed: @escaping(Result<[Article], NewsError>) -> Void) {
        guard let articlesData = defaults.object(forKey: Keys.articles) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let articles = try decoder.decode([Article].self, from: articlesData)
            completed(.success(articles))
        } catch {
            completed(.failure(.unableToBookmark))
        }
    }
    
    static func save(articles: [Article]) -> NewsError? {
        do {
            let encoder = JSONEncoder()
            let encodedArticles = try encoder.encode(articles)
            defaults.set(encodedArticles, forKey: Keys.articles)
            return nil
        } catch {
            return .unableToBookmark
        }
    }
}
