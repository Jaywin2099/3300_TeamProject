//
//  DatabaseConnection.swift
//  SwiftLearning
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct DatabaseConnection {
    private static var isConfigured : Bool = false
    let db : Firestore
    
    init() {
        if !DatabaseConnection.isConfigured {
            FirebaseApp.configure()
            DatabaseConnection.isConfigured = true
        }
        
        db = Firestore.firestore()
    }
}
