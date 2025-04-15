import SwiftUI

struct ContentView: View {
    @State private var userIsLoggedIn = false
    @State private var userId: String? = nil
    private let databaseConnection: DatabaseConnection
    
    init(databaseConnection: DatabaseConnection) {
        self.databaseConnection = databaseConnection
    }
    
    var body: some View {
        Group {
            if userIsLoggedIn, let userId = userId {
                CameraView(userId: userId)
            } else {
                LoginView(databaseConnection: self.databaseConnection, userIsLoggedIn: $userIsLoggedIn, userId: $userId)
            }
        }
    }
}


#Preview {
    ContentView(databaseConnection: DatabaseConnection())
}
