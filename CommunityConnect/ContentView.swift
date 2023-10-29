//
//  ContentView.swift
//  CommunityConnect
//
//  Created by Achraf Zemzami on 10/26/23.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeScreen()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            ResourcesScreen()
                .tabItem {
                    Label("Resources", systemImage: "person.3")
                }

            ManageScreen()
                .tabItem {
                    Label("Manage", systemImage: "gear")
                }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}
