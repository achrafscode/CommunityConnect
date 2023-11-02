//
//  ResourcesScreen.swift
//  CommunityConnect
//
//  Created by Achraf Zemzami on 10/26/23.
//

import SwiftUI
import MapKit
import Alamofire
import SwiftyJSON

struct ResourceItem: Identifiable {
    let id = UUID()
    let name: String
    let location: CoordinateWrapper
    let type: ResourceType
}

struct CoordinateWrapper: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

enum ResourceType: String {
    case foodBank
    case soupKitchen
    case animalShelter
}

struct ResourcesScreen: View {
    @State private var searchQuery = ""
    @State private var filterExpanded = false
    @State private var selectedResourceTypes: [ResourceType] = []
    @State private var userLocation = CLLocationCoordinate2D(latitude: 40.735657, longitude: -74.172363)
    @State private var nearbyResources: [ResourceItem] = []
    let apiKey = "APIKEY" // Replace with actual API key when not on Github
    
    var body: some View {
        VStack {
            ZipCodeSearchBar(text: $searchQuery, onSearch: searchResources)
                .padding()
            
            MapView(userLocation: $userLocation, annotations: nearbyResources.map { $0.location })
            
            if filterExpanded {
                FilterOptions(selectedResourceTypes: $selectedResourceTypes)
            }
        }
        .gesture(DragGesture().onEnded { value in
            if value.translation.height > 100 {
                withAnimation {
                    filterExpanded.toggle()
                }
            }
        })
    }
    
    private func searchResources() {
        guard !searchQuery.isEmpty else {
            // Handle the case when the search query is empty
            return
        }
        
        for resourceType in selectedResourceTypes {
            fetchNearbyResources(resourceType: resourceType)
        }
    }
    
    private func fetchNearbyResources(resourceType: ResourceType) {
        let radius = 5000 // Radius in meters (adjust as needed)
        
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(userLocation.latitude),\(userLocation.longitude)&radius=\(radius)&type=\(resourceType.rawValue)&key=\(apiKey)"
        
        AF.request(urlString).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                if let results = json["results"].array {
                    for result in results {
                        let name = result["name"].stringValue
                        let latitude = result["geometry"]["location"]["lat"].doubleValue
                        let longitude = result["geometry"]["location"]["lng"].doubleValue
                        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        let resource = ResourceItem(name: name, location: CoordinateWrapper(coordinate: coordinate), type: resourceType)
                        nearbyResources.append(resource)
                    }
                }
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

struct ZipCodeSearchBar: View {
    @Binding var text: String
    var onSearch: () -> Void
    
    var body: some View {
        HStack {
            TextField("Enter Zip Code...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                onSearch()
            }) {
                Image(systemName: "magnifyingglass")
            }
        }
    }
}

struct MapView: View {
    @Binding var userLocation: CLLocationCoordinate2D
    let annotations: [CoordinateWrapper]
    
    var body: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))), annotationItems: annotations) { annotation in
            // Add map annotation for each resource location
            MapAnnotation(coordinate: annotation.coordinate) {
                Image(systemName: "pin")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FilterOptions: View {
    @Binding var selectedResourceTypes: [ResourceType]
    
    var body: some View {
        VStack {
            Toggle("Food Banks", isOn: binding(for: .foodBank))
            Toggle("Soup Kitchens", isOn: binding(for: .soupKitchen))
            Toggle("Animal Shelters", isOn: binding(for: .animalShelter))
        }
        .padding()
    }
    
    private func binding(for resourceType: ResourceType) -> Binding<Bool> {
        .init(
            get: { selectedResourceTypes.contains(resourceType) },
            set: { isSelected in
                if isSelected {
                    selectedResourceTypes.append(resourceType)
                } else {
                    selectedResourceTypes.removeAll { $0 == resourceType }
                }
            }
        )
    }
}
