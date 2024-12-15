//
//  Firebase+Book.swift
//  RealmFirebaseCache
//
//  Created by Kyle Beard on 12/15/24.
//

import Firebase
import FirebaseFirestoreCombineSwift
import Foundation

extension FirebaseService {
    
    // MARK: - GET
    
    func getBook(by id: String, useCache: Bool = true) async -> Result<Book, Error> {
        print(#function)
        
        let now: String = String(Date().timeIntervalSince1970)
        let queryKey = "cache/individual/\(Collections.books.rawValue)/\(id)"
        let lastQueriedAt = UserDefaults.standard.string(forKey: queryKey)
        let lastQueriedTimestamp: Double = Double(lastQueriedAt ?? "") ?? 0.0
        
        do {
            /// Build query for firebase accordingly
            let query = database
                .collection(Collections.books.rawValue)
                .whereField("id", isEqualTo: id)
                .whereField(useCondition: useCache, "lastUpdatedAt", isGreaterThan: lastQueriedTimestamp)
            
            /// Fetch from API
            let data = try await getOne(of: Book(), with: query).get()

            /// Write to cache and store timestamp
            await RealmService.shared.write(data, to: Collections.books.rawValue)
            UserDefaults.standard.set(now, forKey: queryKey)
            
            print("Book [\(id)] fetched from API")
            return .success(data)
        } catch let error {
            if let e = error as? FirebaseError, e == .documentNotFound, useCache {
                /// Attempt to get from cache since API didn't return results.
                if let data = await RealmService.shared.read(of: Book(), with: id) {
                    print("Book [\(id)] fetched from local cache")
                    return .success(data)
                } else {
                    /// Document not found when we tried cache, try again ignoring cache (maybe timestamp issue).
                    return await getBook(by: id, useCache: false)
                }
            } else {
                return .failure(error)
            }
        }
    }
    
    func getBooks(useCache: Bool = true) async -> Result<[Book], Error> {
        print(#function)
        
        let now: String = String(Date().timeIntervalSince1970)
        let queryKey = "cache/batch/\(Collections.books.rawValue)/all"
        let lastQueriedAt = UserDefaults.standard.string(forKey: queryKey)
        let lastQueriedTimestamp: Double = Double(lastQueriedAt ?? "") ?? 0.0
        
        do {
            /// Build query for firebase accordingly
            let query = database
                .collection(Collections.books.rawValue)
                .whereField(useCondition: useCache, "lastUpdatedAt", isGreaterThan: lastQueriedTimestamp)
            
            /// Fetch from API with the appropriate filters
            let data = try await getMany(of: Book(), with: query).get()
            
            /// Fetch cached posts prior to API call
            let cache = await RealmService.shared.read(of: Book(), in: Collections.books.rawValue)
            
            /// Combine API and cache, sort by most updated first, and then remove duplicates (stale gets dropped)
            let books = (data + cache).sorted(by: { $0.lastUpdatedAt > $1.lastUpdatedAt })
            
            /// Write new data to cache and store timestamp for each
            for d in data {
                await RealmService.shared.write(d, to: Collections.books.rawValue)
                UserDefaults.standard.set(now, forKey: "cache/individual/\(Collections.books.rawValue)/\(d.id)")
            }
            
            /// Store batch timestamp
            UserDefaults.standard.set(now, forKey: queryKey)
            
            print("Books: \(books.count) total, \(data.count) fetched from API, \(cache.count) fetched from cache")
            return .success(books)
        } catch let error {
            return .failure(error)
        }
    }
}
