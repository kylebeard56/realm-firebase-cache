//
//  ContentView.swift
//  RealmFirebaseCache
//
//  Created by Kyle Beard on 12/15/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var bookService = BookService()
    
    var body: some View {
        ZStack {
            Color.blue
            Text("Built by Kyle Beard")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
