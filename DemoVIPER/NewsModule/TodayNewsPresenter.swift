//
//  TodayNewsPresenter.swift
//  
//
//  Created by Joyal on 06.12.2019.
//  Copyright © 2019 Joyal. All rights reserved.
//

import Foundation

protocol TodayNewsPresenterInterface: class {
    // View -> Presenter
    var newsArticles : [Articles]? {get}
    func notifyViewLoaded()
    func scrollViewDidEndDragging()
    func localizedUpdate(index: Int)
    // Interactor -> Presenter
    func todaysNewsArticles(articles: [Articles]?)
    func errorDispay(articles: NetworkError)
}

class TodayNewsPresenter {
    
    unowned var view: TodayNewsViewControllerInterface
    let router: TodayNewsRouterInterface?
    let interactor: TodayNewsInteractorInterface?
    
    fileprivate var newsByPage: [Articles]?
    fileprivate var isDataLoading = false
    fileprivate var pageCount = 1
    
    init(interactor: TodayNewsInteractorInterface, router: TodayNewsRouterInterface, view: TodayNewsViewControllerInterface) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension TodayNewsPresenter: TodayNewsPresenterInterface {
    func localizedUpdate(index: Int) {
        LocalizedManager.shared.lang = index == 0 ? .English : .French
        self.view.reloadData()
        self.headerTitleUpdate()
    }
    
    var newsArticles: [Articles]? {
        get {
            return self.newsByPage ?? []
        }
    }
    
    func scrollViewDidEndDragging() {
        if !isDataLoading {
            isDataLoading = true
            pageCount = pageCount+1
            interactor?.getNewsArticle(page: String(pageCount))
            self.view.showLoading()
        }
    }
    
    func notifyViewLoaded() {
        self.headerTitleUpdate()
        interactor?.getNewsArticle(page: Constant.initialPage)
    }
    
    func errorDispay(articles: NetworkError) {
        self.view.hideLoading()
    }
    
    func todaysNewsArticles(articles: [Articles]?) {
        DispatchQueue.global(qos: .background).async {
            self.loadMoreData(articles: articles)
            self.view.reloadData()
        }
    }
    
    private func loadMoreData(articles: [Articles]?) {
        guard let article = articles else {return}
        if (self.newsByPage?.count ?? 0 > 0) {
            self.isDataLoading = false
            self.newsByPage! += article
            self.view.hideLoading()
        }else{
            self.newsByPage = article
        }
    }
    
    func headerTitleUpdate()  {
        let headerTitle =  NSLocalizedString(Constant.homePageTitle,comment:Constant.empty)
        self.view.setScreenTitle(with: headerTitle)
    }
}
