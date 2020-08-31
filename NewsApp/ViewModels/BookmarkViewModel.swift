//
//  BookmarkViewModel.swift
//  NewsApp
//
//  Created by Максим Семений on 29.08.2020.
//  Copyright © 2020 Максим Семений. All rights reserved.
//

import UIKit

class BookmarkViewModel: NSObject {
    
    func configureBookmarkCell(cell: NewsCell, articles: [Article], indexPath: IndexPath) {
        cell.imageview.loadImage(from: articles[indexPath.row].urlToImage ?? "")
        cell.titleLabel.text = articles[indexPath.row].title ?? ""
        cell.dateLabel.text = articles[indexPath.row].publishedAt?.convertDateFormat() ?? ""
    }
    
    func configureDetailsVCfromBookmarks(newsDetailsVC: NewsDetailsVC, articles:[Article], indexPath: IndexPath) {
        newsDetailsVC.article = articles[indexPath.row]
    }
}
