//
//  Test Downloading Post.swift
//  Unsocial Media
//
//  Created by  Sadi on 20/4/24.
//

import SwiftUI
import Observation
import SwiftfulFirestore
import FirebaseFirestore
import FirebaseFirestoreSwift

private struct model : IdentifiableByString, Codable, Hashable {
    var id = UUID().uuidString
    let index: Int

}


@Observable
private class StorageFile {
    
    static let shared = StorageFile()
    
    let collection = Firestore.firestore().collection("document")
    
    func add(m: model) async throws {
        do {
            try collection.addDocument(from: m)
        } catch let error { throw error }
    }
    
    func download() async throws -> [model] {
        do {
            return try await collection.limit(to: 10).getDocuments(as: model.self)
        } catch let error { throw error }
    }
    
    
    
    
    
}






struct Test_Downloading_Post: View {
    
    @State private var m : [model] = []
    
    
    var body: some View {
        VStack {
            _button_Upload
            _m_info
        }
    }
    
    
    private var _m_info: some View {
        ScrollView {
            VStack {
                List {
                    ForEach(m) { model in
                        Text("\(model.index)")
                    }
                }
            }
        }
        
        
    }
    
    
    private var _button_Upload: some View {
        Button("Upload Button") {
            Task {
                try await uploadDocument()
            }
            
        }
        .buttonStyle(BorderedButtonStyle())
    }
    
    
    private func uploadDocument() async throws {
        for i in 1..<81 {
            do {
                try await StorageFile.shared.add(m: model(index: i))
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    
    private func downloadDocument() async throws {
        do {
            self.m = try await StorageFile.shared.download()
        } catch let error { throw error }
    }
    
    
}

#Preview {
    Test_Downloading_Post()
}
