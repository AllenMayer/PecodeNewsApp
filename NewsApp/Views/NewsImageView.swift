//
//  NewsImageView.swift
//  NewsApp
//
//  Created by Максим Семений on 29.08.2020.
//  Copyright © 2020 Максим Семений. All rights reserved.
//

import UIKit

class NewsImageView: UIImageView {

    var task: URLSessionDataTask!
    let spinner = UIActivityIndicatorView(style: .gray)
    
    func loadImage(from string: String) {
        image = nil
        addSpinner()
        
        if let task = task {
            task.cancel()
        }
        
        guard let url = URL(string: string) else { return }
        
        if let imageFromCache = Cache.imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            spinner.removeFromSuperview()
            self.image = imageFromCache
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let image = UIImage(data: data) else { return }
            
            Cache.imageCache.setObject(image, forKey: url.absoluteString as AnyObject)
            
            DispatchQueue.main.async {
                self.image = image
                self.spinner.removeFromSuperview()
            }
        }
        task.resume()
    }
    
    private func addSpinner() {
        addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        spinner.startAnimating()
    }
}
