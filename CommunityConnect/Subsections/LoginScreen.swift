//
//  LoginScreen.swift
//  CommunityConnect
//
//  Created by Achraf Zemzami on 10/26/23.
//
import SwiftUI
import Foundation

class LoginStatus: ObservableObject {
    @Published var isLoggedIn: Bool = false
}

struct LoginScreen: View {
    @EnvironmentObject var loginStatus: LoginStatus // Access the LoginStatus object
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggingIn: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to CommunityConnect")
                    .font(.largeTitle)
                    .padding()

                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Sign In", action: {
                    // Implement sign-in logic here (e.g., check credentials with a database)
                    if performLogin() {
                        loginStatus.isLoggedIn = true // Update the login status using LoginStatus
                    } else {
                        // Handle incorrect credentials or other login failures
                    }
                })
                .padding()
                .disabled(isLoggingIn)

                // Add a "Sign Up" button that leads to the RegistrationScreen
                NavigationLink("Sign Up", destination: RegistrationScreen(isLoggedIn: $loginStatus.isLoggedIn))
                    .padding()
                
                NavigationLink("Continue as Guest", destination: ContentView())
                    .padding()
                
            }
            .padding()
            .navigationTitle("Login")
        }
    }
    
    
    struct User {
        var firstName: String
        var lastName: String
        var email: String
        var password: String
        var zipCode: String
    }
    

/*    class LoginStatus: ObservableObject {
        @Published var isLoggedIn: Bool

        init(isLoggedIn: Binding<Bool>) {
            self.isLoggedIn = isLoggedIn.wrappedValue
        }
    }

    */
    // In your RegistrationScreen, create text fields to capture user information and a sign-up button
    struct RegistrationScreen: View {
        @Binding var isLoggedIn: Bool
        @State private var newUser: User = User(firstName: "", lastName: "", email: "", password: "", zipCode: "")
        
        var body: some View {
            Form { // Use Form for a nice, organized layout
                Section(header: Text("User Information")) {
                    TextField("First Name", text: $newUser.firstName)
                    TextField("Last Name", text: $newUser.lastName)
                    TextField("Email", text: $newUser.email)
                    SecureField("Password", text: $newUser.password)
                    TextField("ZIP Code", text: $newUser.zipCode)
                }
                
                Section {
                    Button("Sign Up", action: {
                        // Implement the logic to store the newUser in your database
                        // Once the user is registered, set isLoggedIn to true
                        isLoggedIn = true
                    })
                }
            }
            .navigationBarTitle("Sign Up") // Optional, for setting the title
        }
    }
    
    struct MainScreen: View {
        var body: some View {
            Text("Main Screen")
        }
    }
    
    // Function to get a user from soon to be database
    /*func getUserFromDatabase(username: String, password: String) -> User? {
        // Implement the logic to retrieve the user based on the username and password
        // from your database
        // If found, return the user; otherwise, return nil
    }
    */
    // Simulate a login attempt, replace with actual login logic
    private func performLogin() -> Bool {
        // Implement your login logic here
        // For now, return true to simulate a successful login
        return true
    }
}
