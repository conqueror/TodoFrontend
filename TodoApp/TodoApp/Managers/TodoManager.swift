//
//  TodoManager.swift
//  2016-06-01-codelab-frontend
//
//  Created by Fatih Nayebi on 2016-06-01.
//  Copyright © 2016 Swift-Mtl. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift
import Alamofire

class TodoManager {
    
    class func todos(_ completion: @escaping (_ responseData:[TodoModel]?, _ error: Bool?) -> ()) {
        
        let url = URL(string: "http://localhost:8080/todos")!
        WebServiceManger.sendRequest(url: url, requestMethod: .get, responseType: TodoModel.self) {
            (responseData: [TodoModel]?, error: Bool?) -> Void in
            print(responseData!)
            completion(responseData, false)
        }
    }
    
    class func addTodo(_ completion:@escaping (_ responseData:[TodoModel]?, _ error: Bool?) -> ()) {
        
        let url = URL(string: "http://localhost:8080/postTodo")!
        WebServiceManger.sendRequest(url: url, requestMethod: .post, responseType: TodoModel.self) {
            (responseData:[TodoModel]?, error: Bool?) -> Void in
            print(responseData!)
            completion(responseData, false)
        }
    }
    
    class func localTodos(_ completion:@escaping (_ responseData:[TodoModel]?, _ error: Bool?) -> ()) {
        
        readData(TodoModel.self, predicate: nil) {
            (response: Results<TodoModel>) in
            if response.count > 0 {
                completion(response.map { $0 }, false)
            } else {
                completion(nil, true)
            }
        }
    }
}
