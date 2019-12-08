//
//  Localized.swift
//  DemoVIPER
//
//  Created by JOYAL SERRAO on 07/12/19.
//  Copyright © 2019 Joyal Serrao. All rights reserved.
//

import Foundation
import UIKit

enum Localized : Int,CustomStringConvertible {
    case English = 0
    case French  = 1

    var description: String {
        switch self {
        case .English:
            return "en"
        case .French:
            return "fr"
        }
    }
}

class LocalizedManager {
    static let shared = LocalizedManager()
    init(){
        Bundle.swizzleLocalization()
    }
    var lang : Localized = .English
}


extension Bundle {
    static func swizzleLocalization() {
        let orginalSelector = #selector(localizedString(forKey:value:table:))
        guard let orginalMethod = class_getInstanceMethod(self, orginalSelector) else { return }

        let mySelector = #selector(myLocaLizedString(forKey:value:table:))
        guard let myMethod = class_getInstanceMethod(self, mySelector) else { return }

        if class_addMethod(self, orginalSelector, method_getImplementation(myMethod), method_getTypeEncoding(myMethod)) {
            class_replaceMethod(self, mySelector, method_getImplementation(orginalMethod), method_getTypeEncoding(orginalMethod))
        } else {
            method_exchangeImplementations(orginalMethod, myMethod)
        }
    }
    
    @objc private func myLocaLizedString(forKey key: String,value: String?, table: String?) -> String {
        guard let bundlePath = Bundle.main.path(forResource: LocalizedManager.shared.lang.description, ofType: "lproj"),
               let bundle = Bundle(path: bundlePath) else {
                   return Bundle.main.myLocaLizedString(forKey: key, value: value, table: table)
           }
           return bundle.myLocaLizedString(forKey: key, value: value, table: table)
       }
}
