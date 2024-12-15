//
//  Firebase+Generic.swift
//  RealmFirebaseCache
//
//  Created by Kyle Beard on 12/15/24.
//

import Firebase
import FirebaseFirestoreCombineSwift
import Foundation

extension FirebaseService {
    
    // MARK: - GET
    
    @discardableResult
    func getOne<T: Decodable>(of type: T, with query: Query) async -> Result<T, Error> {
        print(#function)
        do {
            let querySnapshot = try await query.getDocuments()
            
            if let document = querySnapshot.documents.first {
                let data = try document.data(as: T.self)
                return .success(data)
            } else {
                print("Warning: \(#function) document not found")
                return .failure(FirebaseError.documentNotFound)
            }
        } catch let error {
            print("Error: \(#function) couldn't access snapshot documents, \(error)")
            return .failure(error)
        }
    }
    
    @discardableResult
    func getMany<T: Decodable>(of type: T, with query: Query) async -> Result<[T], Error> {
        print(#function)
        do {
            var response: [T] = []
            let querySnapshot = try await query.getDocuments()
            
            for document in querySnapshot.documents {
                do {
                    let data = try document.data(as: T.self)
                    response.append(data)
                } catch let error {
                    print("Error: \(#function) document not decoded from data, \(error)")
                    return .failure(error)
                }
            }
            return .success(response)
        } catch let error {
            print("Error: couldn't access snapshot documents, \(error)")
            return .failure(error)
        }
    }
    
    // MARK: - POST

    @discardableResult
    func post<T: FirebaseIdentifiable>(
        _ value: T,
        to collection: String
    ) async -> Result<T, Error> {
        print(#function)
        let ref = database.collection(collection).document()
        var newValue: T = value
        newValue.id = ref.documentID
        do {
            try ref.setData(from: newValue)
            return .success(newValue)
        } catch let error {
            print("Error: \(#function) in collection: \(collection), \(error)")
            return .failure(error)
        }
    }
    
    // MARK: - PUT
    
    @discardableResult
    func put<T: FirebaseIdentifiable>(
        _ value: T,
        to collection: String
    ) async -> Result<T, Error> {
        print(#function)
        let ref = database.collection(collection).document(value.id)
        do {
            try ref.setData(from: value)
            return .success(value)
        } catch let error {
            print("Error: \(#function) in \(collection) for id: \(value.id), \(error)")
            return .failure(error)
        }
    }
    
    // MARK: - DELETE
    
    @discardableResult
    func delete<T: FirebaseIdentifiable>(
        _ value: T,
        in collection: String
    ) async -> Result<Bool, Error> {
        print(#function)
        let ref = database.collection(collection).document(value.id)
        do {
            try await ref.delete()
            return .success(true)
        } catch let error {
            print("Error: \(#function) in \(collection) for id: \(value.id), \(error)")
            return .failure(error)
        }
    }
}
