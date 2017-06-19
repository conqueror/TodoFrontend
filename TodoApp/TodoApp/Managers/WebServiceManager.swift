//
//  WebServiceManager.swift
//  2016-06-01-codelab-frontend
//
//  Created by Fatih Nayebi on 2016-06-01.
//  Copyright © 2016 Swift-Mtl. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class WebServiceManger {
    
    class func sendRequest<T: Mappable>(_ requestParameters: [String: AnyObject]? = nil, url: URL, requestMethod: Alamofire.HTTPMethod, responseType: T.Type, completion: @escaping (_ responseData: [T]?, _ error: Bool?) -> Void) {
        
        // To execute in a different thread than main thread:
        let queue = DispatchQueue(label: "manager-response-queue", attributes: DispatchQueue.Attributes.concurrent)
        
        // Alamofire web service call:
        
        Alamofire.request(url, method: requestMethod, parameters: requestParameters)
            .responseArray(queue: queue, completionHandler: {
                (response: DataResponse<[T]>) in
                
                print(response.request!)  // original URL request
                print(response.response!) // URL response
                print(response.result)   // result of response serialization
                
                if let mappedModel = response.result.value {
                    DispatchQueue.main.async(execute: {
                        // Save the data to DB:
                        
                        saveData(mappedModel)
                        print("Mapped Model: \(mappedModel)")
                        // callback with the data
                        completion(mappedModel, nil)
                    })
                }
            })
    }
    
    class func sendRequest<T: Mappable>(requestHeaders: HTTPHeaders? = nil,
                                        url: URL,
                                        requestMethod: Alamofire.HTTPMethod,
                                        responseType: T.Type,
                                        completion: @escaping (_ responseData: T?,
                                                               _ error: Bool?) -> Void) {
        
        let queue = DispatchQueue(label: "manager-response-queue", attributes: DispatchQueue.Attributes.concurrent)
        
        // Alamofire web service call:
        Alamofire.request(url,
                          method: requestMethod,
                          parameters: nil,
                          encoding: URLEncoding.default,
                          headers: requestHeaders)
            .responseObject(queue: queue) {
            (response: DataResponse<T>) in
                print(response.request!)  // original URL request
                print(response.response!) // URL response
                print(response.result)   // result of response serialization
                
                if let mappedModel = response.result.value {
                    DispatchQueue.main.async(execute: {
                        // Save the data to DB:
                        // saveData(mappedModel)
                        print("Mapped Model: \(mappedModel)")
                        // callback with the data
                        completion(mappedModel, false)
                    })
                } else {
                    completion(nil, true)
                }
            }
    }
}
