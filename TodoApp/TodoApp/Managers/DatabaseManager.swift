//
//  DatabaseManager.swift
//  2016-06-01-codelab-frontend
//
//  Created by Fatih Nayebi on 2016-06-01.
//  Copyright © 2016 Swift-Mtl. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - Save Data

/// #### Save array of data to Realm DB
/// This method is used when we have array of object models that we want to persist it in Realm DB
/// - Parameter response: Array of Model Objects - parsed from JSON and is a subclass of Object
/// - Returns: Void
public func saveData<T>(_ response: [T], isUpdate: Bool = true) {
    let realm = try! Realm()
    var realmObject: [Object] = []
    for obj in response {
        realmObject.append(obj as! Object)
    }
    try! realm.write {
        realm.add(realmObject, update: isUpdate)
    }
}

// MARK: - Read Data

/// #### Read Data from Realm DB
/// This method reads data from Realm DB and returns with completion block
/// - Parameter: model - Type of model to be read from Realm DB
/// - Parameter: predicate - predicate string such as "color = 'tan' AND name BEGINSWITH 'B'"
/// - Parameter: completion: completion handler closure to return data
/// - Returns: It is Void since it uses completion for call backs
public func readData<T:Object>(_ model: T.Type, predicate: String?, completion: (_ responseData:Results<T>) -> Void) {
    
    let realm = try! Realm()
    let result: Results<T>
    if let predicateString = predicate {
        result = realm.objects(model).filter(predicateString)
    } else {
        result = realm.objects(model)
    }
    completion(result)
    
}

// MARK: - Delete

/// #### Delete a model from Realm DB
/// This method deletes a specific model from Realm DB
/// - Parameter: model - type of the model that is subclass of a Object and will be deleted
public func delete<T:Object>(_ model: T) {
    let realm = try! Realm()
    try! realm.write {
        realm.delete(model)
    }
}

/// #### Delete All
/// This method deletes all objects from Realm DB
/// - Important: Be cautious when using it, data will not be recoverable!
public func deleteAll() {
    let realm = try! Realm()
    try! realm.write {
        realm.deleteAll()
    }
    
}
