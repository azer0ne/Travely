📄 Product Requirements Document (PRD)
Travely - Travel Planner App 

1. Overview
Product Name: Travely Platform: iOS (SwiftUI) Goal: Enable users to search for destinations, view place details, and build a simple itinerary by scheduling places with date and time.
Core Value:
* Fast place discovery
* Simple itinerary creation
* Clean day-by-day planning
* Lightweight and offline-capable (for saved trips)

2. Objectives
Primary Objectives
* Allow users to search places by text
* Display place details with map
* Allow users to create trips
* Allow users to add places into itinerary with date & time
* Show itinerary grouped by day
* Provide navigation via Apple Maps / Google Maps
Secondary Objectives
* Persist trips locally
* Support current location-based search
* Provide smooth UX with async loading

3. Target Users
* Casual travelers
* Weekend planners
* Users who want simple itinerary without complexity
* No login required (MVP)

4. Core Features

4.1 Place Search
Description:User can search for places using text input.
Functional Requirements:
* Search input field
* Autocomplete suggestions (as user types)
* Search results list
* Optional: map preview
Input Example:
* “Coffee shop near Dago”
* “Tokyo Tower”
Output:
* List of places with:
    * Name
    * Address
    * Distance (optional)
    * Category (if available)
Technical Notes:
* Use MapKit:
    * MKLocalSearchCompleter
    * MKLocalSearch

4.2 Place Detail
Description: User views detailed information about a selected place.
Functional Requirements:
* Display:
    * Place name
    * Address
    * Map with pin
    * Category/type
* Actions:
    * "Add to Trip"
    * "Open in Maps"
External Navigation:
* Open Apple Maps (default)
* Optional: Google Maps via URL scheme

4.3 Trip Management
Description: User can create and manage trips.
Functional Requirements:
* Create new trip:
    * Name
    * Start date (optional)
    * End date (optional)
* View list of trips
* Delete trip

4.4 Itinerary Planning
Description: User can add places into a trip and schedule them.
Functional Requirements:
* Add place to trip
* Select:
    * Day (or date)
    * Time
* Store as itinerary item
Display:
* Group by day
* Ordered by time
Example:
Day 1:
- 09:00 Coffee Shop A
- 13:00 Museum B

Day 2:
- 10:00 Park C

4.5 Itinerary Detail
Description: User views and manages itinerary.
Functional Requirements:
* List by day
* Show:
    * Place name
    * Time
* Tap item -> go to place detail
* Delete item
Optional (nice-to-have but still MVP-safe):
* Reorder items (drag & drop)

4.6 Map View (Trip Visualization)
Description: Show all itinerary locations on a map.
Functional Requirements:
* Pins for each place
* Zoom to fit all locations
* Tap pin -> show place preview

4.7 Navigation Integration
Description: User can navigate to a place using external maps.
Functional Requirements:
* Button: "Navigate"
* Opens:
    * Apple Maps (default)
    * Google Maps (if installed, optional)

4.8 Local Persistence
Description: All data stored locally.
Data to Persist:
* Trips
* Itinerary items
* Saved places (optional)
* Recent searches (optional)
Technology:
* SwiftData

5. User Flow

Flow 1: Search -> Add to Trip
Home
-> Search
-> Select Place
-> Place Detail
-> Add to Trip
-> Select Trip + Time
-> Saved

Flow 2: Create Trip -> Add Places
Home
-> Create Trip
-> Open Trip
-> Add Place
-> Search
-> Select Place
-> Schedule

Flow 3: View Trip
Home
-> Trip List
-> Trip Detail
-> Day Sections
-> Tap Item -> Place Detail

Flow 4: Navigate
Place Detail
-> Tap "Open in Maps"
-> External Maps App

6. Screens

6.1 Home Screen
* Search bar
* List of trips
* "Create Trip" button

6.2 Search Screen
* Search input
* Autocomplete suggestions
* Results list

6.3 Place Detail Screen
* Map preview
* Place info
* Buttons:
    * Add to Trip
    * Open in Maps

6.4 Trip List Screen
* List of trips
* Create / Delete

6.5 Trip Detail Screen
* Trip name
* Day tabs or sections
* Itinerary list
* Map button

6.6 Add to Trip Modal
* Select trip
* Select date/day
* Select time
* Save button

6.7 Map Screen
* Map with pins
* Optional route lines

7. Data Models (High-Level)

Trip
* id
* name
* startDate (optional)
* endDate (optional)

Place
* id
* name
* latitude
* longitude
* address
* category (optional)

ItineraryItem
* id
* tripId
* place
* date
* time

8. Non-Functional Requirements
* Smooth UI (no blocking main thread)
* Use async/await for all async work
* Offline access to saved trips
* Fast search response
* Minimal crashes

9. Out of Scope (MVP)
* AI recommendations
* Chat interface
* Multi-user collaboration
* Cloud sync
* Reviews/ratings aggregation
* Booking integration
* Payments

10. Future Enhancements (Post-MVP)
* AI itinerary generator
* Smart recommendations
* Route optimization
* Budget planning
* Weather integration
* Social sharing
* Sync across devices

11. Technical Stack Summary
* UI: SwiftUI
* Architecture: TCA
* Maps/Search: MapKit
* Location: Core Location
* Persistence: SwiftData
* Concurrency: async/await
* Navigation: NavigationStack
* External Maps: URL scheme (Apple Maps / Google Maps)

12. Success Criteria
* User can:
    * Search a place
    * View details
    * Create a trip
    * Add place to itinerary with time
    * View itinerary by day
    * Navigate externally
If all above flows work smoothly -> MVP success.