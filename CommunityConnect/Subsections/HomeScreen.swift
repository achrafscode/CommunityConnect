//
//  HomeScreen.swift
//  CommunityConnect
//
//  Created by Achraf Zemzami on 10/26/23.
//
import SwiftUI
import Foundation

struct HomeScreen: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                //HomeButton()
                //ResourcesButton()
                //ManageButton()
            }
            Text("Hello") // Add this Text view
                .font(.title)
            Spacer()
        }
    }
}

struct HomeButton: View {
    var body: some View {
        Button(action: {
            // Action for the Home button
        }) {
            Label("Home", systemImage: "house")
                .font(.custom("YourFontName", size: 15.4))
                .foregroundColor(Color.green) // Change color to desired color

        }
        .padding()
    }
}
