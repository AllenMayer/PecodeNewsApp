//
//  UITableView.swift
//  NewsApp
//
//  Created by Максим Семений on 29.08.2020.
//  Copyright © 2020 Максим Семений. All rights reserved.
//

import UIKit

extension UITableView {
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
