//
//  BookmarksVC.swift
//  NewsApp
//
//  Created by Максим Семений on 29.08.2020.
//  Copyright © 2020 Максим Семений. All rights reserved.
//

import UIKit

class BookmarksVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var bookmarkViewModel: BookmarkViewModel!
    
    var articles = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBookmarks()
    }
    
    private func getBookmarks() {
        PersistenceManager.retreiveArticles { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let articles):
                if articles.isEmpty {
                    print("Bookmarks are empty")
                }
                self.articles = articles
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.view.bringSubviewToFront(self.tableView)
                }
            case .failure(let error):
                print("something went wrong while retrieving bookmarks, \(error.rawValue)")
            }
        }
    }
    
    private func configureVC() {
        title = "Bookmarks"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier)
        tableView.removeExcessCells()
    }
}

extension BookmarksVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as! NewsCell
        bookmarkViewModel.configureBookmarkCell(cell: cell, articles: articles, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let destVC = storyboard?.instantiateViewController(withIdentifier: NewsDetailsVC.storyboardID) as! NewsDetailsVC
        bookmarkViewModel.configureDetailsVCfromBookmarks(newsDetailsVC: destVC, articles: articles, indexPath: indexPath)
        destVC.updateDelegate = self
        let nav = UINavigationController(rootViewController: destVC)
        navigationController?.present(nav, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completion) in
            guard let self = self else { return }
            let article = self.articles[indexPath.row]
            PersistenceManager.updateWith(article: article, actionType: .remove) { error in
                guard let error = error else {
                    print("deleted!")
                    self.articles.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    return
                }
                print(error.rawValue)
            }
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension BookmarksVC: NewsDetailsVCDelegate {
    func didTapDeleteButton() {
        getBookmarks()
    }
}
