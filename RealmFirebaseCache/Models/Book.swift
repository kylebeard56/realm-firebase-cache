//
//  Book.swift
//  RealmFirebaseCache
//
//  Created by Kyle Beard on 12/15/24.
//

import Foundation

struct Book: FirebaseIdentifiable {
    var id: String
    var libraryID: String
    var name: String
    var author: String
    var pages: Int
    var isCheckedOut: Bool
    var lastUpdatedAt: Double

    init(
        id: String = UUID().uuidString,
        libraryID: String = "",
        name: String = "",
        author: String = "",
        pages: Int = 0,
        isCheckedOut: Bool = false,
        lastUpdatedAt: Double = Date().timeIntervalSince1970
    ) {
        self.id = id
        self.libraryID = libraryID
        self.name = name
        self.author = author
        self.pages = pages
        self.isCheckedOut = isCheckedOut
        self.lastUpdatedAt = lastUpdatedAt
    }
}
