//
//  RealmService.swift
//  RealmFirebaseCache
//
//  Created by Kyle Beard on 12/15/24.
//

import RealmSwift
import SwiftUI

@MainActor class RealmService: ObservableObject {
    static let shared = RealmService()
    init() { print("init RealmService") }
    deinit { print("deinit RealmService") }
}

class RealmCache: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var data: String = ""
    @Persisted var collection: String = ""
    
    convenience init(id: String, data: String, collection: String) {
        self.init()
        self.id = id
        self.data = data
        self.collection = collection
    }
}
