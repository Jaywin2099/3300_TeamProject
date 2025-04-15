import SwiftUI
import Foundation

struct LoginView: View {
    @Binding var userIsLoggedIn: Bool
    @Binding var userId: String?
    
    private let databaseConnection: DatabaseConnection
    
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirmation = ""
    @State private var showError = false
    @State private var isLogin: Bool = true
    @State private var error: LoginError = .none
    
    private enum LoginError {
        case emptyTextField
        case invalidEmail
        case invalidPassword
        case nonMatchingPasswords
        case signUpFailed
        case loginFailed
        case none
        
        var title: String {
            switch self {
            case .emptyTextField: return "Missing Email/Password"
            case .invalidEmail: return "Invalid Email"
            case .invalidPassword: return "Invalid Password"
            case .nonMatchingPasswords: return "Non-Matching Passwords"
            case .signUpFailed: return "Failed Sign Up"
            case .loginFailed: return "Failed Login"
            case .none: return ""
            }
        }
        
        var description: String {
            switch self {
            case .emptyTextField: return "Please provide an email and password."
            case .invalidEmail: return "Please provide a valid email."
            case .invalidPassword: return "Password must be at least 6 characters."
            case .nonMatchingPasswords: return "Passwords do not match, please try again."
            case .signUpFailed: return "Make sure you don't already have a SwiftLearning account and that the email entered is valid."
            case .loginFailed: return "Make sure you have a valid account and that you correctly entered your email and password."
            case .none: return ""
            }
        }
    }
    
    init(databaseConnection: DatabaseConnection, userIsLoggedIn: Binding<Bool>, userId: Binding<String?>) {
        self.databaseConnection = databaseConnection
        self._userIsLoggedIn = userIsLoggedIn
        self._userId = userId
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            ZStack {
                Color(.blue).ignoresSafeArea()
                
                VStack() {
                    Text("Swift Learning")
                        .foregroundColor(.white)
                        .font(.system(size: width * 0.115, weight: .bold, design: .serif))
                        .padding()
                    
                    TextField("Email", text: $email)
                        .foregroundColor(.white)
                        .tint(.white)
                        .font(.system(size: width * 0.05))
                        .textFieldStyle(.plain)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .overlay(
                            Rectangle()
                                .stroke(Color.white, lineWidth: width * 0.005)
                        )
                        .padding()
                    
                    SecureField("Password", text: $password)
                        .foregroundColor(.white)
                        .tint(.white)
                        .font(.system(size: width * 0.05))
                        .textFieldStyle(.plain)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .overlay(
                            Rectangle()
                                .stroke(Color.white, lineWidth: width * 0.005)
                        )
                        .padding()
                    
                    if !isLogin {
                        SecureField("Please Confirm Your Password", text: $passwordConfirmation)
                            .foregroundColor(.white)
                            .tint(.white)
                            .font(.system(size: width * 0.05))
                            .textFieldStyle(.plain)
                            .textInputAutocapitalization(.never)
                            .padding()
                            .overlay(
                                Rectangle()
                                    .stroke(Color.white, lineWidth: width * 0.005)
                            )
                            .padding()
                    }
                    
                    Button {
                        let validation = validateFields()
                        guard validation == .none else {
                            error = validation
                            showError = true
                            return
                        }
                        Task { await handleAuth() }
                    } label: {
                        Text(isLogin ? "Login" : "Create Account")
                            .foregroundColor(.blue)
                            .font(.system(size: width * 0.04))
                            .frame(width: isLogin ? width * 0.35 : width * 0.45, height: isLogin ? height * 0.05 : height * 0.055)
                            .background(
                                RoundedRectangle(cornerRadius: width * 0.025, style: .circular)
                                    .fill(Color.white)
                            )
                    }
                    .padding()
                    
                    Button {
                        password = ""
                        passwordConfirmation = ""
                        isLogin = !isLogin
                    } label: {
                        Text(isLogin ? "Need to create an account? Sign Up" : "Already have an account? Login")
                            .font(.system(size: width * 0.04))
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding(.top)
                }
            }
            .alert(isPresented: $showError) {
                Alert(
                    title: Text(error.title),
                    message: Text(error.description),
                    dismissButton: .default(Text("OK")) { error = .none },
                )
            }
        }
    }
    
    private func validateFields() -> LoginError {
        guard !email.isEmpty, !password.isEmpty else { return .emptyTextField }
        guard NSPredicate(format: "SELF MATCHES %@", "^.+@.+[.].+$").evaluate(with: email) else { return .invalidEmail }
        
        if !isLogin {
            guard !passwordConfirmation.isEmpty else { return .emptyTextField }
            guard password.count >= 6 else { return .invalidPassword }
            guard password == passwordConfirmation else { return .nonMatchingPasswords }
        }
        
        return .none
    }
    
    private func handleAuth() async {
        await registerUser()
        guard error != .none else {
            await loginUser()
            return
        }
    }
    
    private func loginUser() async {
        let (userId, success) = await databaseConnection.authenticateUser(email: email, password: password)
        guard success else {
            isLogin = true
            error = .loginFailed
            showError = true
            return
        }
        
        print("User logged in successfully!")
        print("UserId: ", userId)
        self.userId = userId
        userIsLoggedIn = true
    }
    
    private func registerUser() async {
        guard !isLogin else { return }
        guard await databaseConnection.createUserAuth(email: email, password: password) else {
            error = LoginError.signUpFailed
            showError = true
            return
        }
    }
}

#Preview {
    LoginView(databaseConnection: DatabaseConnection(), userIsLoggedIn: .constant(false), userId: .constant(nil))
}
