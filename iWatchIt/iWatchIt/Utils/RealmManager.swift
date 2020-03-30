//
//  RealmManager.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 22/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import RealmSwift


final class RealmManager {
    static func saveObject<T:Object>(object: T) throws  {
        let realm = try Realm()
        try realm.write {
            realm.add(object)
        }
    }
    static func getObjects<T:Object>(type: T.Type) throws ->[T] {
        let realm = try Realm()
        let realmResults = realm.objects(type)
        return Array(realmResults)
    }
    static func getObjects<T:Object>(type: T.Type, filter:String) throws ->[T]  {
        let realm = try Realm()
        let realmResults = realm.objects(type).filter(filter)
        return Array(realmResults)
    }
    static func removeObjects<T:Object>(type: T.Type) throws {
        let realm = try Realm()
        let objects = realm.objects(type)

        try realm.write {
            realm.delete(objects)
        }
    }
}
