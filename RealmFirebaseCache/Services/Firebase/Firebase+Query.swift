//
//  Firebase+Query.swift
//  RealmFirebaseCache
//
//  Created by Kyle Beard on 12/15/24.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

extension Query {
    func whereField(useCondition: Bool, _ field: String, isGreaterThan: Any) -> Query {
        if useCondition {
            return self.whereField(field, isGreaterThan: isGreaterThan)
        } else {
            return self
        }
    }
}
