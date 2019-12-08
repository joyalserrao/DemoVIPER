//
//  Utilities.swift
//  DemoVIPER
//
//  Created by JOYAL SERRAO on 07/12/19.
//  Copyright © 2019 Joyal Serrao. All rights reserved.
//

import Foundation
import UIKit

public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}


extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
            guard let cell = self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as? T else {fatalError()}
            return cell
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            ImageCache.shared.image.setObject(image, forKey: url.absoluteString as NSString)

            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        if let cachedImage = ImageCache.shared.image.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
        }else{
        downloaded(from: url, contentMode: mode)
        }
    }
}

extension UIStoryboard {
    func instantiateVC<T: UIViewController>() -> T? {
        if let name = (NSStringFromClass(T.self).components(separatedBy: ".")).last {
            return instantiateViewController(withIdentifier: name) as? T
        }
        return nil
    }

}

class ImageCache {
    static let shared = ImageCache()
    var image =  NSCache<NSString, UIImage>()
    init(){}
}




