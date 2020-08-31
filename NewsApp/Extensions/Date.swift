//
//  Date.swift
//  NewsApp
//
//  Created by Максим Семений on 29.08.2020.
//  Copyright © 2020 Максим Семений. All rights reserved.
//

import Foundation

extension String {
    func convertDateFormat() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatterReturn = DateFormatter()
        dateFormatterReturn.dateFormat = "EEEE, MMM d, yyyy"
        
        let date: Date? = dateFormatterGet.date(from: self)
        return dateFormatterReturn.string(from: date!)
    }
}
