//
//  ContentView.swift
//  CommunityConnect
//
//  Created by Achraf Zemzami on 10/26/23.
//
import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @State private var username: String = "" // Initialize with empty string
    @State private var password: String = "" // Initialize with empty string

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeScreen()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(Tab.home)

            ResourcesScreen()
                .tabItem {
                    Label("Resources", systemImage: "person.3")
                }
                .tag(Tab.resources)

            ManageScreen(username: $username, password: $password)
                .tabItem {
                    Label("Manage", systemImage: "gear")
                }
                .tag(Tab.manage)
        }
    }
}

enum Tab {
    case home, resources, manage
}
