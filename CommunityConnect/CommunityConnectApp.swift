//
//  CommunityConnectApp.swift
//  CommunityConnect
//
//  Created by Achraf Zemzami on 10/26/23.
//

import SwiftUI

@main
struct CommunityConnectApp: App {
    @StateObject private var loginStatus = LoginStatus() // Create LoginStatus as a StateObject
 
    var body: some Scene {
        WindowGroup {
            if loginStatus.isLoggedIn {
                ContentView()
                    .environmentObject(loginStatus) // Provide the LoginStatus object to ContentView
            } else {
                LoginScreen()
                    .environmentObject(loginStatus) // Provide the LoginStatus object to ContentView
            }
        }
    }
}

