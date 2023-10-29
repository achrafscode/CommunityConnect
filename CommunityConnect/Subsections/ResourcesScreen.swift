//
//  ResourcesScreen.swift
//  CommunityConnect
//
//  Created by Achraf Zemzami on 10/26/23.
//
import SwiftUI
import MapKit
import Foundation

// Map parts
struct MapAnnotationItem: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let facilityType: FacilityType
    let contactInfo: String
    let address: String
    let needs: String
}

enum FacilityType: String, CaseIterable {
    case animalShelter = "Animal Shelter"
    case soupKitchen = "Soup Kitchen"
    case foodBank = "Food Bank"
}

struct ResourcesScreen: View {
    @State private var searchText = ""
    @State private var selectedFacility = FacilityType.allCases.first!
    @State private var locations: [MapAnnotationItem] = [] // Add your location data

    @State private var selectedLocation: MapAnnotationItem?
    @State private var isLocationInfoVisible = false

    var body: some View {
        ResourcesButton()
        NavigationView {
            VStack {
                TextField("Search Location", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Picker("Facility Type", selection: $selectedFacility) {
                    ForEach(FacilityType.allCases, id: \.self) { facility in
                        Text(facility.rawValue).tag(facility)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                MapView(locations: locations, selectedFacility: $selectedFacility, selectedLocation: $selectedLocation, isLocationInfoVisible: $isLocationInfoVisible)
            }
            .navigationBarTitle("Resources")
        }
    }
}

struct ResourcesButton: View {
    var body: some View {
        Button(action: {
            // Action for the Community Resources button
        }) {
            Label("Resources", systemImage: "person.3")
                .font(.custom("YourFontName", size: 15.4)) // Change "YourFontName" to the desired font name and adjust the size as needed
                .foregroundColor(Color.green) // Change the color to desired color
        }
        .padding()
    }
}

struct MapView: View {
    var locations: [MapAnnotationItem]
    @Binding var selectedFacility: FacilityType
    @Binding var selectedLocation: MapAnnotationItem?
    @Binding var isLocationInfoVisible: Bool

    var body: some View {
        Map(coordinateRegion: $selectedLocation != nil ? coordinateRegionForLocation(selectedLocation!) : initialRegion,
            showsUserLocation: true,
            userTrackingMode: .constant(selectedFacility == .animalShelter ? .follow : .none),
            annotationItems: filteredLocations) { location in
            Marker(coordinate: location.coordinate, tint: .blue) {
                MapPin(coordinate: location.coordinate, tint: .blue)
            }
            .onTapGesture {
                selectedLocation = location
                isLocationInfoVisible = true
            }
        }
        .overlay(
            ForEach(filteredLocations) { location in
                Button(action: {
                    selectedLocation = location
                    isLocationInfoVisible = true
                }) {
                    Circle()
                        .stroke(Color.blue, lineWidth: 2)
                        .frame(width: 24, height: 24)
                }
                .offset(x: 0, y: -12)
                .opacity(0.5)
            }
        )
        .background(
            LocationInfoPopup(location: $selectedLocation, isLocationInfoVisible: $isLocationInfoVisible)
        )
    }

    private var filteredLocations: [MapAnnotationItem] {
        return locations.filter { $0.facilityType == selectedFacility }
    }

    private var initialRegion: MKCoordinateRegion {
        // Set an initial region for your map
        let center = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // Example coordinates (San Francisco)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) // Example span
        return MKCoordinateRegion(center: center, span: span)
    }

    private func coordinateRegionForLocation(_ location: MapAnnotationItem) -> MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        return MKCoordinateRegion(center: location.coordinate, span: span)
    }
}

struct LocationInfoPopup: View {
    @Binding var location: MapAnnotationItem?
    @Binding var isLocationInfoVisible: Bool

    var body: some View {
        if let location = location {
            VStack {
                Text(location.name)
                    .font(.headline)

                Text("Facility Type: \(location.facilityType.rawValue)")
                Text("Needs: \(location.needs)")
                Text("Contact: \(location.contactInfo)")
                Text("Address: \(location.address)")

                Button("Close") {
                    isLocationInfoVisible = false
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}
