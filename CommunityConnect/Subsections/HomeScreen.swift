//
//  HomeScreen.swift
//  CommunityConnect
//
//  Created by Achraf Zemzami on 10/26/23.
//
import SwiftUI

class EventStore: ObservableObject {
    @Published var events: [Event] = []

    func addEvent(_ event: Event) {
        events.append(event)
    }
}

struct HomeScreen: View {
    @StateObject var eventStore = EventStore()
    @State private var isAddingEvent = false
    @State private var userDonationAmount: Double = 0.0

    var body: some View {
        NavigationView {
            VStack {
                Text("Newark Events")
                    .font(.title)
                    .foregroundColor(Color.black)
                    .padding()

                Spacer()

                DonationSuggestionsView(userDonationAmount: $userDonationAmount)
                
                Spacer()
                
                List(eventStore.events, id: \.name) { event in
                    EventRow(event: event)
                }

                Button("Create Event") {
                    isAddingEvent.toggle()
                }
                .padding()
            }
        }
        .background(Color.green)
        .sheet(isPresented: $isAddingEvent) {
            CreateEventView(eventStore: eventStore)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}

struct DonationSuggestionsView: View {
    @Binding var userDonationAmount: Double

    var body: some View {
        Section(header: Text("Donation Suggestions")) {
            Text("Enter your budget:")
            TextField("Budget", value: $userDonationAmount, formatter: NumberFormatter()) // Use NumberFormatter here
                .textFieldStyle(PlainTextFieldStyle()) // Use PlainTextFieldStyle for no lines
                .multilineTextAlignment(.center) // Center-align the text
                .keyboardType(.decimalPad)

            if userDonationAmount >= 20 {
                Text("Suggested Donation: Canned Goods")
            } else if userDonationAmount >= 10 {
                Text("Suggested Donation: Canned Soups")
            } else {
                Text("Suggested Donation: Instant Noodles")
            }
        }
    }
}


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
