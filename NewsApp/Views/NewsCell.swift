//
//  NewsCell.swift
//  NewsApp
//
//  Created by Максим Семений on 29.08.2020.
//  Copyright © 2020 Максим Семений. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    let imageview = NewsImageView()
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    
    static let identifier = "NewsCell"
    
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
            imageview.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -padding*2),
            imageview.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imageview.widthAnchor.constraint(equalTo: contentView.heightAnchor, constant: padding*2),
            
            titleLabel.leadingAnchor.constraint(equalTo: imageview.trailingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding/2),
            titleLabel.topAnchor.constraint(equalTo: imageview.topAnchor),
            titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 3/5),
            
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            dateLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/5)
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
        titleLabel.numberOfLines = 3
        titleLabel.font = UIFont.systemFont(ofSize: self.frame.height / 3, weight: .medium)
       }
    
    private func configureDate() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: self.frame.height / 3.5, weight: .regular)
        dateLabel.textColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
