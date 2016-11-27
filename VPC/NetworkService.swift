//
//  NetworkService.swift
//  VPC
//
//  Created by Vladimirs Matusevics on 27/11/2016.
//  Copyright © 2016 vmatusevic. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkService {
    
    static func fetchData(fromUrl url: String, callback: ((JSON?, NSError?) -> Void)?) {
        
        Alamofire.request("\(AppConfig.apiBaseURL)\(url)").responseJSON { response in
            
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let jsonObject = response.result.value {
//                print("JSON: \(JSON)")
//                var json = JSON(_json!)
//                callback?(json, nil)
                let json = JSON(jsonObject)
                callback?(json, nil)
            }
        }
        
//        Alamofire.request(.GET, url).responseJSON { (_, _, _json, _error) -> Void in
//            if let error = _error {
//                callback?(nil, error)
//            } else {
//                var json = JSON(_json!)
//                callback?(json, nil)
//            }
//        }
    }
    
    static func postData(toUrl url: String, parameters: Parameters, callback: ((JSON?, NSError?) -> Void)?) {
        
//        let encoding = Alamofire.ParameterEncoding.URLEncodedInURL
        Alamofire.request("\(AppConfig.apiBaseURL)\(url)", method: .post, parameters: parameters, encoding: URLEncoding.queryString).responseJSON { response in
            
            print("postData request: \(response.request)")  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let jsonObject = response.result.value {
                let json = JSON(jsonObject)
                callback?(json, nil)
            }
        }
    }
}
