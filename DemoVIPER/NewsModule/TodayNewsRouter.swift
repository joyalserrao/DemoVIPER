//
//  TodayNewsRouter.swift
//  CIViperGenerator
//
//  Created by Joyal on 06.12.2019.
//  Copyright © 2019 Joyal. All rights reserved.
//

import Foundation
import UIKit

protocol TodayNewsRouterInterface: class {}

class TodayNewsRouter: NSObject {

    weak var presenter: TodayNewsPresenterInterface?

    static func setupModule() -> TodayNewsViewController {
        let router = TodayNewsRouter()
        let interactor = TodayNewsInteractor()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: TodayNewsViewController.className) as! TodayNewsViewController
        let presenter = TodayNewsPresenter(interactor: interactor, router: router, view: vc)
        
        vc.presenter = presenter
        router.presenter = presenter
        interactor.presenter = presenter
        return vc
    }
}

extension TodayNewsRouter: TodayNewsRouterInterface {}

