//
//  HeadNewsCell.swift
//  NewsApp
//
//  Created by Максим Семений on 29.08.2020.
//  Copyright © 2020 Максим Семений. All rights reserved.
//

import UIKit

class HeadNewsCell: UITableViewCell {
    
    let imageview = NewsImageView()
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    
    static let identifier = "HeadNewsCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        configureImage()
        configureTitle()
        configureDate()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageview.image = nil
        titleLabel.text = nil
        dateLabel.text = nil
    }
    
    private func configureCell() {
        contentView.addSubview(imageview)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 2/8),
            
            imageview.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            imageview.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            imageview.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -padding),
            imageview.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 5/8),
            
            dateLabel.leadingAnchor.constraint(equalTo: imageview.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: imageview.bottomAnchor),
            dateLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/8)
        ])
    }
    
    private func configureImage() {
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFill
        imageview.layer.masksToBounds = true
        imageview.layer.cornerRadius = 15
    }
    
    private func configureTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: self.frame.height / 2.5, weight: .semibold)
    }
    
    private func configureDate() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: self.frame.height / 3, weight: .medium)
        dateLabel.textColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
