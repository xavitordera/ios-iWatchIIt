//
//  RealmManager.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 22/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import RealmSwift


public class RealmManager {
    
    static var realm: Realm?
    
    static func initWithConfig(configuration: Realm.Configuration?) throws {
        guard let config = configuration else {
            return
        }
        RealmManager.realm = try Realm.init(configuration: config)
    }
    
    static func saveObject<T:Object>(object: T) throws  {
        guard let realm = self.realm else {return}
        try realm.write {
            realm.add(object)
        }
    }
    
    static func getObjects<T:Object>(type: T.Type) throws ->[T] {
        guard let realm = self.realm else {return []}
        let realmResults = realm.objects(type)
        return Array(realmResults)
    }
    
    static func getObjects<T:Object>(type: T.Type, filter:String) throws ->[T]  {
        guard let realm = self.realm else {return []}
        let realmResults = realm.objects(type).filter(filter)
        return Array(realmResults)
    }
    
    static func removeObjects<T:Object>(type: T.Type) throws {
        guard let realm = self.realm else {return}
        let objects = realm.objects(type)

        try realm.write {
            realm.delete(objects)
        }
    }
    static func removeObject<T:Object>(type: T.Type, filter: String) throws {
        guard let realm = self.realm else {return}
        let realmResults = realm.objects(type).filter(filter)

        try realm.write {
            realm.delete(realmResults)
        }
    }
    
    static func initRealm() {
        
        let config = Realm.Configuration(
          // Set the new schema version. This must be greater than the previously used
          // version (if you've never set a schema version before, the version is 0).
          schemaVersion: 4,

          // Set the block which will be called automatically when opening a Realm with
          // a schema version lower than the one set above
          migrationBlock: { migration, oldSchemaVersion in
            // We haven’t migrated anything yet, so oldSchemaVersion == 0
            if (oldSchemaVersion < 1) {
              // Nothing to do!
              // Realm will automatically detect new properties and removed properties
              // And will update the schema on disk automatically
            }
          })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        do {
            try RealmManager.initWithConfig(configuration: config)
        } catch let error {
            debugPrint(error)
        }
    }
}
