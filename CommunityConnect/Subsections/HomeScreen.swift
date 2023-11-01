//
//  HomeScreen.swift
//  CommunityConnect
//
//  Created by Achraf Zemzami on 10/26/23.
//
import SwiftUI
import Foundation

class EventStore: ObservableObject {
    @Published var events: [Event] = []

    func addEvent(_ event: Event) {
        events.append(event)
    }
}

struct HomeScreen: View {
    @StateObject var eventStore = EventStore()
    @State private var isAddingEvent = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Newark Events")
                    .font(.title)
                    .foregroundColor(Color.black)
                    .padding()

                Spacer()

                Button("Create Event") {
                    isAddingEvent.toggle()
                }
                .padding()
                
                List(eventStore.events, id: \.name) { event in
                    EventRow(event: event)
                }
            }
        }
        .background(Color.green)
        .sheet(isPresented: $isAddingEvent) {
            CreateEventView(eventStore: eventStore)
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

/*struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
*/
struct CreateEventView: View {
    @ObservedObject var eventStore: EventStore

    @State private var name = ""
    @State private var description = ""
    @State private var location = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Information")) {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                    TextField("Location", text: $location)
                }
            }
            .navigationBarTitle("Create Event")
            .navigationBarItems(trailing: Button("Create") {
                let event = Event(name: name, description: description, location: location)
                eventStore.addEvent(event)
            })
        }
    }
}

struct Event: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let location: String
}

struct EventRow: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.name)
                .font(.headline)
            Text(event.description)
                .font(.body)
            Text(event.location)
                .font(.body)
        }
    }
}
