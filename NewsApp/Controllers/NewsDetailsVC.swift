//
//  NewsDetailsVC.swift
//  NewsApp
//
//  Created by Максим Семений on 29.08.2020.
//  Copyright © 2020 Максим Семений. All rights reserved.
//

import UIKit
import SafariServices

class NewsDetailsVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
        
    static let storyboardID = "NewsDetailsVC"
        
    var article: Article? = nil
    
    weak var updateDelegate: NewsDetailsVCDelegate?
    
    let imageView = NewsImageView()
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let descriptionLabel = UILabel()
    let authorLabel = UILabel()
    let linkLabel = UILabel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
        configureImage()
        configureTitle()
        configureDateLabel()
        configureDescriptionLabel()
        configureAuthorLabel()
        configureLinkLabel()
        configureNavigationButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentHeight.constant = linkLabel.frame.maxY + 50
    }
    
    private func configureContentView() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(linkLabel)
        
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 3/5),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding*1.5),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -padding),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: padding*2),
            descriptionLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            authorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: padding*2),
            authorLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            
            linkLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: padding*2),
            linkLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            linkLabel.trailingAnchor.constraint(equalTo: authorLabel.trailingAnchor),
        ])
    }

    private func configureImage() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.loadImage(from: article?.urlToImage ?? "")
        imageView.contentMode = .scaleToFill
    }
    
    private func configureTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        titleLabel.text = article?.title ?? ""
    }
    
    private func configureDateLabel() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        dateLabel.textColor = .lightGray
        dateLabel.text = article?.publishedAt?.convertDateFormat() ?? ""
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        descriptionLabel.text = article?.description ?? ""
        descriptionLabel.numberOfLines = 0
    }
    
    private func configureAuthorLabel() {
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        authorLabel.textColor = .darkText
        authorLabel.text = "Source: \(article?.author ?? "Anonymous")"
        authorLabel.numberOfLines = 0
    }
    
    private func configureLinkLabel() {
        linkLabel.translatesAutoresizingMaskIntoConstraints = false
        linkLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        linkLabel.textColor = .systemBlue
        linkLabel.numberOfLines = 0
        linkLabel.text = "Visit for more: \(article?.url ?? "")"
        linkLabel.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(getInfo))
        tap.numberOfTouchesRequired = 1
        linkLabel.addGestureRecognizer(tap)
    }
    
    @objc func getInfo() {
        guard let url = URL(string: article!.url!) else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    private func configureNavigationButton() {
        PersistenceManager.retreiveArticles { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let articles):
                let matchedArticle = articles.filter { $0.title == self.article!.title }
                if matchedArticle.isEmpty {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.saveArticle))
                } else {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(self.deleteArticle))
                    self.navigationItem.rightBarButtonItem?.tintColor = .red
                }
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    @objc func saveArticle() {
        guard let article = self.article else { return }
        PersistenceManager.updateWith(article: article, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.configureNavigationButton()
                print("saved!")
                return
            }
            print(error.rawValue)
        }
    }
    
    @objc func deleteArticle() {
        guard let article = self.article else { return }
        PersistenceManager.updateWith(article: article, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.configureNavigationButton()
                self.updateDelegate?.didTapDeleteButton()
                print("deleted!")
                return
            }
            print(error.rawValue)
        }
    }
}

protocol NewsDetailsVCDelegate: AnyObject {
    func didTapDeleteButton()
}
