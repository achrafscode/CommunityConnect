//
//  ManageScreen.swift
//  CommunityConnect
//
//  Created by Achraf Zemzami on 10/26/23.
//
import SwiftUI
import Foundation

struct ManageScreen: View {
    var body: some View {
        // Code for the Manage screen
            ManageButton()
        }
    }

struct ManageButton: View {
        var body: some View {
            Button(action: {
                // Action for the Manage Account & Resources button
            }) {
                Label("Manage", systemImage: "gear")
                    .font(.custom("YourFontName", size: 15.4))
                    .foregroundColor(Color.green) // Change the color to desired color
            }
            .padding()
        }
    }

