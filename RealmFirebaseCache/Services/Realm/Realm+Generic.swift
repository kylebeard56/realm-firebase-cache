//
//  Realm+Generic.swift
//  RealmFirebaseCache
//
//  Created by Kyle Beard on 12/15/24.
//

import RealmSwift
import SwiftUI

extension RealmService {
    
    // MARK: - READ
    
    func read<T: FirebaseIdentifiable>(of type: T, with id: String) async -> T? {
        if let realm = try? await Realm() {
            return realm.objects(RealmCache.self).where {
                $0.id == id
            }.compactMap {
                $0.data.decoded()
            }.first
        } else {
            print("\(#function) realm missing")
            return nil
        }
    }
    
    func read<T: FirebaseIdentifiable>(of type: T, in collection: String) async -> [T] {
        if let realm = try? await Realm() {
            return realm.objects(RealmCache.self).where {
                $0.collection == collection
            }.compactMap {
                $0.data.decoded()
            }
        } else {
            print("\(#function) realm missing")
            return []
        }
    }
    
    // MARK: - WRITE
    
    func write<T: FirebaseIdentifiable>(_ value: T, to collection: String) async {
        if let realm = try? await Realm() {
            if let data = value.encoded {
                if let realmObject = realm.objects(RealmCache.self).first(where: { $0.id == value.id }) {
                    /// UPDATE
                    do {
                        try realm.write {
                            realmObject.data = data
                        }
                    } catch let error {
                        print("\(#function) update failed, \(error)")
                    }
                } else {
                    /// CREATE
                    let realmObject = RealmCache(id: value.id, data: data, collection: collection)
                    do {
                        try realm.write {
                            realm.add(realmObject)
                        }
                    } catch let error {
                        print("\(#function) create failed, \(error)")
                    }
                }
            } else {
                print("\(#function) encoding to JSON failed")
            }
        } else {
            print("\(#function) realm missing")
        }
    }
    
    // MARK: - DELETE
    
    func delete<T: FirebaseIdentifiable>(_ value: T) async {
        if let realm = try? await Realm() {
            if let realmCache = realm.objects(RealmCache.self).first(where: { $0.id == value.id }) {
                realm.delete(realmCache)
            }
        } else {
            print("\(#function) realm missing")
        }
    }
    
    func nuke() async {
        if let realm = try? await Realm() {
            realm.deleteAll()
        } else {
            print("\(#function) realm missing")
        }
    }
}
