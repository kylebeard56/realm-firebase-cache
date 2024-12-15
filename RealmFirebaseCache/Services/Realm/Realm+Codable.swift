//
//  Realm+Codable.swift
//  RealmFirebaseCache
//
//  Created by Kyle Beard on 12/15/24.
//

import Foundation

extension FirebaseIdentifiable {
    var encoded: String? {
        if let data = try? JSONEncoder().encode(self), let string = String(data: data, encoding: .utf8) {
            return string
        } else {
            return nil
        }
    }
}

extension String {
    func decoded<T: FirebaseIdentifiable>() -> T? {
        if let data = self.data(using: .utf8), let obj = try? JSONDecoder().decode(T.self, from: data) {
            return obj
        } else {
            return nil
        }
    }
}
