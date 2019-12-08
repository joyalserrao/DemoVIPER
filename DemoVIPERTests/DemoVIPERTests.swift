//
//  DemoVIPERTests.swift
//  DemoVIPERTests
//
//  Created by JOYAL SERRAO on 06/12/19.
//  Copyright © 2019 Joyal Serrao. All rights reserved.
//

import XCTest
@testable import DemoVIPER

class DemoVIPERTests: XCTestCase {

    lazy var view : TodayNewsViewController = {
     return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: TodayNewsViewController.className) as! TodayNewsViewController
    }()
    var presentor : TodayNewsPresenter?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        presentor = TodayNewsPresenter(interactor: TodayNewsInteractor(),
        router: TodayNewsRouter(),
        view: view)
       
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
         
            
        }
    }
    
    func testTitleName() {
        let title = NSLocalizedString("Todays News", comment: "")
        presentor?.view.setScreenTitle(with: title)
        XCTAssertEqual(view.title, "Nouvelles d'aujourd'hui")
    }

}
