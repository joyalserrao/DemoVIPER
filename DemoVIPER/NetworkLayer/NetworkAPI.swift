//
//  NetworkAPI.swift
//  DemoVIPER
//
//  Created by JOYAL SERRAO on 06/12/19.
//  Copyright © 2019 Joyal Serrao. All rights reserved.

//  oldAPIKey : 16aed06c6ed5458d969b732a72ca3b46
//  newAPIKey : a8fabd9ff4234c82aad08eaaa4ea17a0

import Foundation


protocol QuerryParameters {
    var pageNumer : String   {get }
    var pageSize  : String   {get }
    var country   : Country  {get }
    var category  : Category {get }
    var apiKey    : String   {get }
}
extension QuerryParameters {
    var apiKey      : String    {return "16aed06c6ed5458d969b732a72ca3b46"}
    var pageSize    : String    {return "5" }
    var queryItem : [URLQueryItem]  {
        [URLQueryItem(name: "page", value: pageNumer),
        URLQueryItem(name: "pageSize", value:pageSize),
        URLQueryItem(name: "country", value:country.rawValue),
        URLQueryItem(name: "category", value:category.rawValue),
        URLQueryItem(name: "apiKey", value:apiKey)]
    }
}

struct RequestParm : QuerryParameters{
    var pageNumer: String
    var country: Country
    var category: Category
}

enum Country : String {
    case english = "us"
    case french  = "fr"
}
enum Category : String {
    case entertainment = "entertainment"
    case technology    = "technology"
}

enum RequestType: String {
    case GET
    case POST
}

enum NetworkError: Error {
    case domainError
    case decodingError
    case noDataError
}

enum StatusCode : String {
    case successful = "ok"
}

struct RequestModel  {
    let url : URLScheema
    let typeObj : RequestType = .GET
    var querryItems : [URLQueryItem]?
    let httpBody : [String:Any]? = nil
    let param : [String:Any]? = nil
    var httpHeaderField : [String : String]? = nil
}

enum URLScheema : String   {
    case topHeadlines = "/v2/top-headlines"
}

extension URLScheema : CustomStringConvertible {
    var description: String {
        return "https://newsapi.org"+self.rawValue
    }
}


class NetworkRequestMain {
    
    static func postAction<T:Decodable>(_ requestModel:RequestModel,
                                        _ modelType: T.Type,
                                        completion: @escaping (Result<T,NetworkError>) -> Void) {
        let session = URLSession.shared
        var serviceUrl = URLComponents(string: requestModel.url.description)
        serviceUrl?.queryItems =  requestModel.querryItems
        guard let componentURL = serviceUrl?.url else { return }
        var request = URLRequest(url: componentURL)
        request.httpMethod = requestModel.typeObj.rawValue
        request.allHTTPHeaderFields =  requestModel.httpHeaderField
        
        if let parameterDictionary = requestModel.httpBody  {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
                return
            }
            request.httpBody = httpBody
        }
        
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try jsonDecoder.decode(T.self, from: data)
                    completion(.success(responseModel))
                } catch {
                    //type of failure
                    completion(.failure(.decodingError))
                    print(error)
                }
            } else {
                completion(.failure(.noDataError))
            }
        }.resume()
    }
    
}
