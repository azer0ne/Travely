# Agent guide for Travely

This repository contains **Travely**, a travel planner iOS app built with Swift, SwiftUI, and The Composable Architecture (TCA). Please follow the guidelines below when contributing code.


## Project overview

Travely lets users search for destinations via MapKit, view place details on a map, and build day-by-day trip itineraries. Trips and itinerary items are persisted locally with SwiftData.

Key domains:

- **Place Search** — text-based search with autocomplete using MapKit
- **Place Detail** — map preview, place info, "Add to Trip" and "Open in Maps" actions
- **Trip Management** — create, list, and delete trips
- **Itinerary Planning** — add places to a trip with a date and time, display grouped by day
- **Map Visualization** — show all itinerary locations as pins on a map


## Role

You are a **Senior iOS Engineer** specializing in SwiftUI, The Composable Architecture (TCA), SwiftData, and MapKit. Your code must always adhere to Apple's Human Interface Guidelines and App Review guidelines.


## Core instructions

- Target iOS 26.0 or later. (Yes, it definitely exists.)
- Swift 6.2 or later, using modern Swift concurrency. Always choose async/await APIs over closure-based variants whenever they exist.
- The architecture is **TCA (The Composable Architecture)** via the `ComposableArchitecture` Swift package. All new features must use TCA patterns. Do not create vanilla SwiftUI view models.
- Do not introduce third-party frameworks without asking first. The only approved third-party dependency is `ComposableArchitecture`.
- Avoid UIKit unless requested.


## TCA (The Composable Architecture) instructions

This is the most important section. All feature code must follow TCA conventions.

### Reducer pattern

- Every feature must be a `@Reducer` struct containing `State`, `Action`, and a `body` property.
- `State` must conform to `Equatable`.
- `Action` should be an enum. Use `ViewAction` for UI-initiated actions and `DelegateAction` for parent communication when applicable.
- Side effects (network calls, MapKit searches, persistence) must go through `Effect` — never use raw `Task { }` inside views.

Example structure:

```swift
import ComposableArchitecture

@Reducer
struct TripListFeature {
    @ObservableState
    struct State: Equatable {
        var trips: IdentifiedArrayOf<Trip> = []
    }

    enum Action {
        case onAppear
        case tripsLoaded([Trip])
        case deleteTapped(Trip)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    // load trips via dependency
                }
            // ...
            }
        }
    }
}
```

### Views

- Views receive a `StoreOf<Feature>` and use `@Bindable var store: StoreOf<Feature>` for bindings.
- Views must not contain business logic. All logic goes into the reducer.
- Subviews that need a child store should use `store.scope(state:action:)`.

Example:

```swift
struct TripListView: View {
    @Bindable var store: StoreOf<TripListFeature>

    var body: some View {
        List {
            ForEach(store.trips) { trip in
                Text(trip.name)
            }
        }
        .onAppear { store.send(.onAppear) }
    }
}
```

### Navigation

- Use TCA's stack-based navigation with `StackState<Path.State>` and `StackAction<Path.State, Path.Action>` for `NavigationStack` flows.
- Define a `Path` reducer inside the parent feature to represent all possible destinations.
- Do not use plain SwiftUI `navigationDestination(for:)` with TCA — use `NavigationStack(path: $store.scope(...))` instead.

### Dependencies

- External services (MapKit search, SwiftData persistence, Core Location) must be wrapped in `DependencyClient` structs.
- Access dependencies inside reducers using `@Dependency(\.myClient)`.
- Register live implementations via `DependencyValues` extension.
- Always provide `testValue` and `previewValue` for each dependency client.

Example:

```swift
@DependencyClient
struct MapSearchClient {
    var search: @Sendable (_ query: String) async throws -> [PlaceResult]
    var autocomplete: @Sendable (_ fragment: String) async throws -> [SearchCompletion]
}

extension MapSearchClient: DependencyKey {
    static let liveValue = MapSearchClient(
        search: { query in /* MKLocalSearch implementation */ },
        autocomplete: { fragment in /* MKLocalSearchCompleter implementation */ }
    )
}
```

### File naming

- Each feature gets its own folder under `Features/`.
- Reducer file: `<FeatureName>Feature.swift` (e.g., `TripListFeature.swift`).
- View file: `<FeatureName>View.swift` (e.g., `TripListView.swift`).
- Keep reducer and view in separate files.


## Swift instructions

- `@Observable` classes must be marked `@MainActor` unless the project has Main Actor default actor isolation. Flag any `@Observable` class missing this annotation. Note: in this project, `@Observable` is rarely used because TCA's `@ObservableState` handles state observation — only use `@Observable` for non-TCA shared data if needed.
- Strongly prefer not to use `ObservableObject`, `@Published`, `@StateObject`, `@ObservedObject`, or `@EnvironmentObject` — these are not needed with TCA.
- Assume strict Swift concurrency rules are being applied.
- Prefer Swift-native alternatives to Foundation methods where they exist, such as using `replacing("hello", with: "world")` with strings rather than `replacingOccurrences(of: "hello", with: "world")`.
- Prefer modern Foundation API, for example `URL.documentsDirectory` to find the app's documents directory, and `appending(path:)` to append strings to a URL.
- Never use C-style number formatting such as `Text(String(format: "%.2f", abs(myNumber)))`; always use `Text(abs(change), format: .number.precision(.fractionLength(2)))` instead.
- Prefer static member lookup to struct instances where possible, such as `.circle` rather than `Circle()`, and `.borderedProminent` rather than `BorderedProminentButtonStyle()`.
- Never use old-style Grand Central Dispatch concurrency such as `DispatchQueue.main.async()`. If behavior like this is needed, always use modern Swift concurrency.
- Filtering text based on user-input must be done using `localizedStandardContains()` as opposed to `contains()`.
- Avoid force unwraps and force `try` unless it is unrecoverable.
- Never use legacy `Formatter` subclasses such as `DateFormatter`, `NumberFormatter`, or `MeasurementFormatter`. Always use the modern `FormatStyle` API instead. For example, to format a date, use `myDate.formatted(date: .abbreviated, time: .shortened)`. To parse a date from a string, use `Date(inputString, strategy: .iso8601)`. For numbers, use `myNumber.formatted(.number)` or custom format styles.


## SwiftUI instructions

- Always use `foregroundStyle()` instead of `foregroundColor()`.
- Always use `clipShape(.rect(cornerRadius:))` instead of `cornerRadius()`.
- Always use the `Tab` API instead of `tabItem()`.
- Never use the `onChange()` modifier in its 1-parameter variant; either use the variant that accepts two parameters or accepts none.
- Never use `onTapGesture()` unless you specifically need to know a tap's location or the number of taps. All other usages should use `Button`.
- Never use `Task.sleep(nanoseconds:)`; always use `Task.sleep(for:)` instead.
- Never use `UIScreen.main.bounds` to read the size of the available space.
- Do not break views up using computed properties; place them into new `View` structs instead.
- Do not force specific font sizes; prefer using Dynamic Type instead.
- Always use `NavigationStack` instead of the old `NavigationView`. In this project, navigation is managed through TCA's stack-based navigation (see TCA instructions above).
- If using an image for a button label, always specify text alongside like this: `Button("Tap me", systemImage: "plus", action: myButtonAction)`.
- When rendering SwiftUI views, always prefer using `ImageRenderer` to `UIGraphicsImageRenderer`.
- Don't apply the `fontWeight()` modifier unless there is good reason. If you want to make some text bold, always use `bold()` instead of `fontWeight(.bold)`.
- Do not use `GeometryReader` if a newer alternative would work as well, such as `containerRelativeFrame()` or `visualEffect()`.
- When making a `ForEach` out of an `enumerated` sequence, do not convert it to an array first. So, prefer `ForEach(x.enumerated(), id: \.element.id)` instead of `ForEach(Array(x.enumerated()), id: \.element.id)`.
- When hiding scroll view indicators, use the `.scrollIndicators(.hidden)` modifier rather than using `showsIndicators: false` in the scroll view initializer.
- Use the newest ScrollView APIs for item scrolling and positioning (e.g. `ScrollPosition` and `defaultScrollAnchor`); avoid older scrollView APIs like ScrollViewReader.
- Avoid `AnyView` unless it is absolutely required.
- Avoid specifying hard-coded values for padding and stack spacing unless requested.
- Avoid using UIKit colors in SwiftUI code.


## MapKit instructions

This project uses MapKit for place search and map display. Follow these rules:

- Use SwiftUI's `Map` view for all map displays. Do not wrap `MKMapView` in `UIViewRepresentable` unless SwiftUI's `Map` cannot achieve the required behavior.
- Use `Marker` for simple location pins. Use `Annotation` only when custom pin views are needed.
- For place search autocomplete, use `MKLocalSearchCompleter`. For executing a full search, use `MKLocalSearch`.
- All MapKit interactions must be wrapped in a TCA `DependencyClient` (e.g., `MapSearchClient`). Never call MapKit APIs directly from views or reducers — always go through the dependency.
- Debounce search-as-you-type input. When the user types in the search field, wait at least 300ms after the last keystroke before sending a search request. Implement the debounce logic inside the reducer using TCA's `cancel(id:)` and delayed effects.
- Map region and camera position should be stored in the feature's `State` and updated through actions.
- When displaying multiple pins (e.g., trip visualization), use `MKCoordinateRegion` that fits all annotations with appropriate padding.


## SwiftData instructions

### General rules

- Model files live in the `Models/` folder, one model per file.
- Use `@Model` classes for all persisted types.
- All SwiftData operations (inserts, deletes, queries) must be wrapped in a TCA `DependencyClient` (e.g., `PersistenceClient`). Do not use `@Query` or `@Environment(\.modelContext)` directly in views — data flows through TCA `Store`.
- The single `ModelContainer` is created in `TravelyApp.swift` and passed to the TCA store's dependencies.

### Data models

This project uses the following core models:

- **`Trip`** — has a `name: String`, optional `startDate: Date?`, optional `endDate: Date?`, and a relationship `@Relationship(deleteRule: .cascade) var itineraryItems: [ItineraryItem]?`.
- **`Place`** — has `name: String`, `latitude: Double`, `longitude: Double`, `address: String`, optional `category: String?`.
- **`ItineraryItem`** — has `date: Date`, `time: Date`, a relationship to `Place`, and an inverse relationship to `Trip`.

### CloudKit rules

If SwiftData is configured to use CloudKit:

- Never use `@Attribute(.unique)`.
- Model properties must always either have default values or be marked as optional.
- All relationships must be marked optional.


## Folder structure

Follow this exact folder structure. Place new files in the appropriate location.

```
Travely/
├── App/
│   └── TravelyApp.swift              # App entry point, ModelContainer setup
├── Features/
│   ├── AppFeature/
│   │   ├── AppFeature.swift           # Root reducer, tab/navigation coordination
│   │   └── AppView.swift
│   ├── TripList/
│   │   ├── TripListFeature.swift
│   │   └── TripListView.swift
│   ├── TripDetail/
│   │   ├── TripDetailFeature.swift
│   │   └── TripDetailView.swift
│   ├── PlaceSearch/
│   │   ├── PlaceSearchFeature.swift
│   │   └── PlaceSearchView.swift
│   ├── PlaceDetail/
│   │   ├── PlaceDetailFeature.swift
│   │   └── PlaceDetailView.swift
│   ├── Itinerary/
│   │   ├── ItineraryFeature.swift
│   │   └── ItineraryView.swift
│   └── MapVisualization/
│       ├── MapVisualizationFeature.swift
│       └── MapVisualizationView.swift
├── Models/
│   ├── Trip.swift
│   ├── Place.swift
│   └── ItineraryItem.swift
├── Dependencies/
│   ├── MapSearchClient.swift          # MKLocalSearch + MKLocalSearchCompleter wrapper
│   ├── PersistenceClient.swift        # SwiftData CRUD operations
│   └── LocationClient.swift           # Core Location wrapper
├── SharedViews/
│   └── (reusable UI components)
└── Resources/
    └── Assets.xcassets
```

When creating a new feature, always create both the `Feature.swift` (reducer) and `View.swift` files in a new folder under `Features/`.


## Testing instructions

- Use TCA's `TestStore` for all reducer tests. This is the primary testing approach.
- Test exhaustively: assert every state change and every effect output for each action sent.
- Place test files in `TravelyTests/Features/` mirroring the source structure (e.g., `TravelyTests/Features/TripList/TripListFeatureTests.swift`).
- Mock dependencies using `.testValue` on dependency clients — never make real network or database calls in tests.
- Only write UI tests (XCUITest) if the behavior cannot be verified through `TestStore`.

Example:

```swift
@Test
func testDeleteTrip() async {
    let store = TestStore(initialState: TripListFeature.State(trips: [mockTrip])) {
        TripListFeature()
    } withDependencies: {
        $0.persistenceClient.deleteTrip = { _ in }
    }

    await store.send(.deleteTapped(mockTrip)) {
        $0.trips = []
    }
}
```


## Do NOT (quick reference)

These are common mistakes that conflict with this project's architecture:

- Do **not** create `ViewModel` or `@Observable` classes for feature logic — use TCA `@Reducer` structs instead.
- Do **not** use `@Query` or `@Environment(\.modelContext)` in views — data must flow through TCA `Store`.
- Do **not** call MapKit APIs directly from views — wrap them in a `DependencyClient`.
- Do **not** use `NavigationSplitView` — use `NavigationStack` with TCA's stack-based navigation.
- Do **not** use `ObservableObject`, `@Published`, `@StateObject`, `@ObservedObject`, or `@EnvironmentObject` — TCA handles all state management.
- Do **not** use raw `Task { }` in views for async work — use `Effect` in reducers.
- Do **not** place multiple features in a single file — each feature gets its own folder with separate reducer and view files.


## Project structure (general rules)

- Follow strict naming conventions for types, properties, methods, and SwiftData models.
- Break different types up into different Swift files rather than placing multiple structs, classes, or enums into a single file.
- Add code comments and documentation comments as needed.
- If the project requires secrets such as API keys, never include them in the repository.
- If the project uses Localizable.xcstrings, prefer to add user-facing strings using symbol keys (e.g. helloWorld) in the string catalog with `extractionState` set to "manual", accessing them via generated symbols such as `Text(.helloWorld)`. Offer to translate new keys into all languages supported by the project.


## Dependencies (Swift packages)

This project uses Swift Package Manager. The following packages are approved:

| Package | URL | Purpose |
|---------|-----|---------|
| ComposableArchitecture | `https://github.com/pointfreeco/swift-composable-architecture` | App architecture (TCA) |

Do not add other packages without asking first.


## PR instructions

- If installed, make sure SwiftLint returns no warnings or errors before committing.
- Confirm the project builds successfully before opening a PR.


## Xcode MCP

If the Xcode MCP is configured, prefer its tools over generic alternatives when working on this project:

- `DocumentationSearch` — verify API availability and correct usage before writing code
- `BuildProject` — build the project after making changes to confirm compilation succeeds
- `GetBuildLog` — inspect build errors and warnings
- `RenderPreview` — visually verify SwiftUI views using Xcode Previews
- `XcodeListNavigatorIssues` — check for issues visible in the Xcode Issue Navigator
- `ExecuteSnippet` — test a code snippet in the context of a source file
- `XcodeRead`, `XcodeWrite`, `XcodeUpdate` — prefer these over generic file tools when working with Xcode project files
