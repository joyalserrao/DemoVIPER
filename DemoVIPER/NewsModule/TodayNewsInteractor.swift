//
//  TodayNewsInteractor.swift
//  
//
//  Created by Joyal on 06.12.2019.
//  Copyright © 2019 Joyal. All rights reserved.
//

import Foundation

protocol TodayNewsInteractorInterface: class {
    func getNewsArticle(page:String)
}

class TodayNewsInteractor {
    weak var presenter: TodayNewsPresenterInterface?
}

extension TodayNewsInteractor: TodayNewsInteractorInterface {
    func getNewsArticle(page:String) {
        print("page \(page)")
        let parm = RequestParm(pageNumer: page, country: .english, category: .entertainment)
        let request = RequestModel(url: .topHeadlines,querryItems: parm.queryItem)
        NetworkRequestMain.postAction(request, TodaysNews.self) {[weak self] result in
            switch result {
            case .success(let model):
                if (model.status! == StatusCode.successful.rawValue) {
                    self?.presenter?.todaysNewsArticles(articles: model.articles)
                }else{
                    self?.presenter?.errorDispay(articles: .noDataError)
                }
            case .failure(let error):
                self?.presenter?.errorDispay(articles: error)
            }
        }
    }
}




