//
//  ViewModel().swift
//  RealmFirebaseCache
//
//  Created by Kyle Beard on 12/15/24.
//

@MainActor class BookService: ObservableObject {
    init() { }
    deinit { }
    
    func loadBook(by id: String) async {
        do {
            let book = try await FirebaseService.getBook(by: id).get()
            // do something with response
        } catch let error {
            // handle failure
        }
    }
    
    func loadBooks() async {
        do {
            let books = try await FirebaseService.getBooks().get()
            // do something with response
        } catch let error {
            // handle failure
        }
    }
}
