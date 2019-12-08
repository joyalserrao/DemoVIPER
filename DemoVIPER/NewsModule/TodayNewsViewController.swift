//
//  TodayNewsViewController.swift
//  CIViperGenerator
//
//  Created by Joyal on 06.12.2019.
//  Copyright © 2019 Joyal. All rights reserved.
//

import UIKit

protocol TodayNewsViewControllerInterface: class {
    func showLoading()
    func hideLoading()
    func reloadData()
    func setScreenTitle(with title:String)}

class TodayNewsViewController: UIViewController {
    var presenter: TodayNewsPresenterInterface?
    @IBOutlet weak var newsListTableView: UITableView!
    
    lazy var refreshView : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        spinner.color = UIColor.darkGray
        spinner.hidesWhenStopped = true
        newsListTableView.tableFooterView = spinner
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.notifyViewLoaded()
    }
    
    @IBAction func segmentSwitchAction(_ sender: UISegmentedControl) {
        self.presenter?.localizedUpdate(index: sender.selectedSegmentIndex)
    }
}

extension TodayNewsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let newsCount =  presenter?.newsArticles?.count else {return 0}
        return newsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: TodayNewsCell.self, for: indexPath)
        let articleModel = presenter?.newsArticles?[indexPath.row]
        cell.updateView(model: articleModel!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension TodayNewsViewController : UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.newsListTableView{
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                self.presenter?.scrollViewDidEndDragging()
            }
        }
    }
}

extension TodayNewsViewController: TodayNewsViewControllerInterface {
    func showLoading() {
        DispatchQueue.main.async {
            self.refreshView.startAnimating()
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.refreshView.stopAnimating()
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.newsListTableView.reloadData()
        }
    }
    
    func setScreenTitle(with title: String) {
        self.title = title
    }
}


