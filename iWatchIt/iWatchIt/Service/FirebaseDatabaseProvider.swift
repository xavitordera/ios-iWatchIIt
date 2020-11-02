//
//  FirebaseDatabaseProvider.swift
//  iWatchIt
//
//  Created by Xavier Tordera on 27/10/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import Firebase

enum DatabaseFields {
    static let adManager = "AdManager"
    static let interstitialFrequency = "IntersitialFrequency"
    static let utellyKeys = "UtellyKeys"
}

protocol FirebaseDatabaseProviderProtocol {
    func fetchParameter<T>(parent: String, name: String, ofType: T.Type, _ completion: @escaping (T?) -> Void)
    func fetchObject(name: String, _ completion: @escaping (NSDictionary?) -> Void)
}

struct FirebaseDatabaseProvider {
    lazy var ref = Database.database().reference()
    
    static let shared = FirebaseDatabaseProvider()
}


extension FirebaseDatabaseProvider: FirebaseDatabaseProviderProtocol {
    func fetchObject<T>(name: String, _ completion: @escaping (T?) -> Void) {
        ref.observeSingleEvent(of: .value) { snapshot in
            if let value = snapshot.value as? NSDictionary {
                let object = value[name] as? T
                completion(object)
                return
            }
            completion(nil)
        }
    }
    
    func fetchParameter<T>(parent: String = DatabaseFields.adManager, name: String, ofType: T.Type, _ completion: @escaping (T?) -> Void) {
        
        ref.child(parent).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let parameter = value?[name] as? T
            completion(parameter)
        }
    }
    
    
}
