//
//  FirebaseService.swift
//  RealmFirebaseCache
//
//  Created by Kyle Beard on 12/15/24.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation
import SwiftUI

protocol FirebaseIdentifiable: Hashable, Codable {
    var id: String { get set }
    var lastUpdatedAt: Double { get set }
}

extension FirebaseIdentifiable {
    /// POST to Firebase
    func post(to collection: String) async -> Result<Self, Error> {
        return await FirebaseService.shared.post(self, to: collection)
    }

    /// PUT to Firebase
    func put(to collection: String) async -> Result<Self, Error> {
        var data = self
        data.lastUpdatedAt = Date().timeIntervalSince1970
        return await FirebaseService.shared.put(data, to: collection)
    }

    /// DELETE from Firebase
    func delete(from collection: String) async -> Result<Void, Error> {
        var data = self
        data.lastUpdatedAt = Date().timeIntervalSince1970
        return await FirebaseService.shared.delete(data, in: collection)
    }
}

enum Collections: String {
    case books = "books-v1"
    case cards = "cards-v1"
    case libraries = "libraries-v1"
}

class FirebaseService {
    static let shared = FirebaseService()
    
    let database = Firestore.firestore()
    
    init() {
        print("init FirebaseService")
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
        database.settings = settings
    }
    
    deinit { print("deinit FirebaseService") }
}
