//
//  NewsError.swift
//  NewsApp
//
//  Created by Максим Семений on 29.08.2020.
//  Copyright © 2020 Максим Семений. All rights reserved.
//

import Foundation

enum NewsError : String, Error {
    case unableToBookmark = "There was an error adding this article. Please try again."
    case alreadyInBookmarks = "You've already added this article."
}
