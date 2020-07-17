//
//  APIManager.swift
//  Cocktail DB
//
//  Created by Mac on 16.07.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation

import Alamofire
import Kingfisher

class APIManager: NSObject {
    override init() {
        super.init()
    }
}

// Singleton Extension
extension APIManager {
    static let shared = APIManager()
}

extension APIManager {
    func sendRequest(url: String, method: Alamofire.HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, success: ((Data)->Void)?, failure: ((AFError)->Void)?) {
            
        guard let correctedURLString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        print("*** REQUEST: \(correctedURLString)")
        Alamofire.Session.default.session.configuration.httpCookieStorage = HTTPCookieStorage.shared
        
        Alamofire.Session.default.session.configuration.timeoutIntervalForRequest = 60
        
        Alamofire.Session.default.request(correctedURLString, method: method, parameters: parameters, encoding: encoding, headers: nil).responseJSON { (responseData) in
            switch responseData.result {
            case .success(let anyResponse):
                
                if let value = responseData.metrics?.taskInterval.duration {
                    let fvalue = Float(value)
                    let roundedValue = roundf(fvalue * 100) / 100
                    print("\(responseData.request?.url) : \(roundedValue) sec")
                }
                
                print(anyResponse)
                
                if let data = responseData.data {
                    success?(data)
                }
            case .failure(let error):
                
                print("!!!!!!!!!!!!!!!!!!!!")
                print("~ ERROR \(responseData.response?.statusCode ?? 0): " + "\(responseData.request?.url)")
                print("!!!!!!!!!!!!!!!!!!!!")
                failure?(error)
            }
        }
    }
}

extension APIManager {
    func getDrinks(filter: String, success: ((Data)->Void)?, failure: ((AFError)->Void)?) {
        let url = URLs.Base + URLs.Drinks + filter
        
        sendRequest(url: url, method: .get, parameters: nil, encoding: JSONEncoding.prettyPrinted, success: { (response) in
            success?(response)
        }, failure: { (error) in
            print(error.localizedDescription)
            failure?(error)
        })
    }
    
    func getFilters(success: ((Data)->Void)?, failure: ((AFError)->Void)?) {
        let url = URLs.Base + URLs.AllFilters
    
        sendRequest(url: url, method: .get, parameters: nil, encoding: JSONEncoding.prettyPrinted, success: { (response) in
            success?(response)
        }, failure: { (error) in
            print(error.localizedDescription)
            failure?(error)
        })
    }
}
