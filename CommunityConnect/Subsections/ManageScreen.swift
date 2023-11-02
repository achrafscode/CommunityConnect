//
//  ManageScreen.swift
//  CommunityConnect
//
//  Created by Achraf Zemzami on 10/26/23.
//
import SwiftUI
import Foundation

struct ManageScreen: View {
    @Binding var username: String
    @Binding var password: String

    let organizationAccountURL = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSc5jreN_3pcSi-e401tVWTFJV_WmJymplvdtMmlSn_Kcpo95Q/viewform?usp=sf_link")!

    var body: some View {
        NavigationView {
            VStack {
                Text("Username:")
                    .font(.custom("YourFontName", size: 15.4))
                    .foregroundColor(Color.green)
                TextField("Enter your username", text: $username)
                    .padding()

                Text("Password:")
                    .font(.custom("YourFontName", size: 15.4))
                    .foregroundColor(Color.green)
                SecureField("Enter your password", text: $password)
                    .padding()

                Button(action: {
                    // Action to update user details
                }) {
                    Text("Update")
                        .font(.custom("YourFontName", size: 15.4))
                        .foregroundColor(Color.green)
                }
                .padding()

                // "Request Organization Account" button to open the URL
                Link("Request Organization Account", destination: organizationAccountURL)
                    .font(.custom("YourFontName", size: 15.4))
                    .foregroundColor(Color.green)
                    .padding()
            }
            .padding()
        }
    }
}
