//
//  ViewModel().swift
//  RealmFirebaseCache
//
//  Created by Kyle Beard on 12/15/24.
//

import SwiftUI

@MainActor class BookService: ObservableObject {
    init() { }
    deinit { }
    
    func loadBook(by id: String) async {
        do {
            let book = try await FirebaseService.shared.getBook(by: id).get()
            // do something with response
        } catch let error {
            // handle failure
        }
    }
    
    func loadBooks() async {
        do {
            let books = try await FirebaseService.shared.getBooks().get()
            // do something with response
        } catch let error {
            // handle failure
        }
    }
}
