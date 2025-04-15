//
//  DatabaseConnection.swift
//  SwiftLearning
//

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct DatabaseConnection {
    private static var isConfigured : Bool = false // Prevents previews from not making a ton of .configure calls
    private var userIsAuthenticated : Bool = false
    private let db: Firestore
    
    private enum Collection {
        static let facts = "facts"
        static let images = "images"
        static let users = "users"
    }

    init() {
        if !DatabaseConnection.isConfigured {
            FirebaseApp.configure()
            DatabaseConnection.isConfigured = true
        }
        db = Firestore.firestore()
    }
    
    private func createUserInDatabase (userId: String, userEmail: String) async -> String {
        do {
            let user = try await db.collection(Collection.users).document(userId).getDocument()
            
            // Note: if user already exists the .setData will override
            try await db.collection("users").document(userId).setData([
                    "email": userEmail,
                ])
            print("User created successfully!")
            
            return user.documentID
        } catch {
            print("Error creating user: \(error)")
            return ""
        }
    }
    
    func authenticateUser(email: String, password: String) async -> (userId: String, success: Bool) {
        var userID: String = ""
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            
            if let userEmail = result.user.email {
                userID = await createUserInDatabase(userId: result.user.uid, userEmail: userEmail)
                
                if userID.isEmpty {
                    return ("", false)
                }
            } else {
                print("Error with Firebase fetching user email: user email doesn't exist")
                return (userID, false)
            }
            
            return (userID, true)
        } catch {
            print(error.localizedDescription)
            return ("", false)
        }
    }
    
    
    
    func createUserAuth(email: String, password: String) async -> Bool {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
