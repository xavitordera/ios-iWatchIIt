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
}

protocol FirebaseDatabaseProviderProtocol {
    func fetchParameter<T>(parent: String, name: String, ofType: T.Type, _ completion: @escaping (T?) -> Void)
}

struct FirebaseDatabaseProvider: FirebaseDatabaseProviderProtocol {
    let ref = Database.database().reference()
    
    func fetchParameter<T>(parent: String = DatabaseFields.adManager, name: String = DatabaseFields.interstitialFrequency, ofType: T.Type, _ completion: @escaping (T?) -> Void) {
        
        ref.child(parent).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let parameter = value?[name] as? T
            completion(parameter)
        })
        
    }
}
