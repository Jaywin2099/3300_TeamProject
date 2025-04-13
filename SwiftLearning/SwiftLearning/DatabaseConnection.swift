//
//  DatabaseConnection.swift
//  SwiftLearning
//

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct DatabaseConnection {
    private static var isConfigured : Bool = false
    private let db : Firestore

    init() {
        if !DatabaseConnection.isConfigured {
            FirebaseApp.configure()
            DatabaseConnection.isConfigured = true
        }
        
        Auth.auth().signIn(withEmail: "", password: "") { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
        
        db = Firestore.firestore()
    }
    
    func getDatabase() -> Firestore {
        return db
    }
}
