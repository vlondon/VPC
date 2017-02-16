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
            if let jsonObject = response.result.value {
                let json = JSON(jsonObject)
                callback?(json, nil)
            }
        }
        
    }
    
    static func postData(toUrl url: String, parameters: Parameters, callback: ((JSON?, NSError?) -> Void)?) {
        
        Alamofire.request("\(AppConfig.apiBaseURL)\(url)", method: .post, parameters: parameters, encoding: URLEncoding.queryString).responseJSON { response in
            
            if let jsonObject = response.result.value {
                let json = JSON(jsonObject)
                callback?(json, nil)
            }
        }
    }
}
