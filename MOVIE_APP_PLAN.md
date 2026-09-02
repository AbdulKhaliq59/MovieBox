# Movie App — SwiftUI Clean Architecture Plan

## 1. Project Overview

Build a modern, production-quality Movie Discovery App using:

- Swift
- SwiftUI
- MVVM
- Clean Architecture
- Feature-Based Architecture
- Swift Concurrency (`async/await`)
- `@Observable`
- URLSession
- The Movie Database (TMDB) API
- SwiftData for local persistence
- Environment-based configuration
- Dependency Injection
- Unit Testing

The application should feel like a real-world iOS application rather than a tutorial project.

---

# 2. Product Vision

The app helps users discover movies, search for movies, view detailed information, and save movies to their favorites.

Primary navigation:

- Home
- Search
- Favorites

Core user journey:

```text
Open App
    ↓
Home
    ↓
Discover Movies
    ↓
Select Movie
    ↓
Movie Details
    ↓
Add to Favorites
```

---

# 3. Main Features

## Home

Display:

- Featured/trending movie
- Trending movies
- Popular movies
- Now Playing
- Top Rated
- Upcoming movies

Features:

- Horizontal movie carousels
- Pull to refresh
- Loading states
- Error states
- Empty states
- Movie navigation

---

## Search

Users can:

- Search for movies
- View search results
- Clear search
- View empty results
- Paginate results
- Select a movie

Advanced:

- Search debouncing
- Search history
- Recent searches

---

## Movie Details

Display:

- Backdrop image
- Movie poster
- Title
- Tagline
- Rating
- Vote count
- Release date
- Runtime
- Genres
- Overview
- Cast
- Crew
- Similar movies
- Trailers/videos

Actions:

- Add/remove favorite
- Open trailer
- Navigate to similar movies

---

## Favorites

Users can:

- View saved movies
- Remove movies
- Open movie details

Persistence:

- SwiftData

Favorites must remain available after restarting the application.

---

# 4. Architecture

Use:

```text
Clean Architecture + MVVM + Feature-Based Architecture
```

Dependency direction:

```text
Presentation
     ↓
Domain
     ↓
Data
```

The Domain layer must never depend on:

- SwiftUI
- URLSession
- TMDB
- SwiftData
- Networking implementation details

---

# 5. Folder Structure

Use the following structure:

```text
MovieApp/
│
├── App/
│   ├── MovieApp.swift
│   ├── AppContainer.swift
│   └── AppRouter.swift
│
├── Core/
│   │
│   ├── Configuration/
│   │   ├── Environment.swift
│   │   └── AppConfiguration.swift
│   │
│   ├── Networking/
│   │   ├── APIClient.swift
│   │   ├── APIEndpoint.swift
│   │   ├── HTTPMethod.swift
│   │   ├── NetworkError.swift
│   │   └── RequestBuilder.swift
│   │
│   ├── ImageLoading/
│   │   ├── ImageLoader.swift
│   │   └── CachedAsyncImage.swift
│   │
│   ├── Components/
│   │   ├── MovieCard.swift
│   │   ├── RatingView.swift
│   │   ├── LoadingView.swift
│   │   ├── ErrorView.swift
│   │   └── EmptyStateView.swift
│   │
│   ├── Extensions/
│   │
│   └── Utilities/
│
├── Domain/
│   │
│   ├── Entities/
│   │   ├── Movie.swift
│   │   ├── Genre.swift
│   │   ├── CastMember.swift
│   │   └── Video.swift
│   │
│   ├── Repositories/
│   │   └── MovieRepository.swift
│   │
│   └── UseCases/
│       ├── GetTrendingMoviesUseCase.swift
│       ├── GetPopularMoviesUseCase.swift
│       ├── GetNowPlayingMoviesUseCase.swift
│       ├── GetTopRatedMoviesUseCase.swift
│       ├── GetUpcomingMoviesUseCase.swift
│       ├── SearchMoviesUseCase.swift
│       ├── GetMovieDetailsUseCase.swift
│       ├── GetMovieCreditsUseCase.swift
│       └── GetSimilarMoviesUseCase.swift
│
├── Data/
│   │
│   ├── DTOs/
│   │   ├── MovieDTO.swift
│   │   ├── MovieDetailsDTO.swift
│   │   ├── GenreDTO.swift
│   │   ├── CreditsDTO.swift
│   │   ├── CastMemberDTO.swift
│   │   ├── VideoDTO.swift
│   │   └── PaginatedResponseDTO.swift
│   │
│   ├── DataSources/
│   │   ├── Remote/
│   │   │   └── TMDBRemoteDataSource.swift
│   │   │
│   │   └── Local/
│   │       └── FavoritesLocalDataSource.swift
│   │
│   ├── Mappers/
│   │   ├── MovieMapper.swift
│   │   └── CreditsMapper.swift
│   │
│   └── Repositories/
│       └── MovieRepositoryImpl.swift
│
├── Features/
│   │
│   ├── Home/
│   │   ├── Views/
│   │   │   ├── HomeView.swift
│   │   │   └── MovieSectionView.swift
│   │   │
│   │   ├── ViewModels/
│   │   │   └── HomeViewModel.swift
│   │   │
│   │   └── Components/
│   │       └── FeaturedMovieView.swift
│   │
│   ├── Search/
│   │   ├── Views/
│   │   │   ├── SearchView.swift
│   │   │   └── SearchResultsView.swift
│   │   │
│   │   ├── ViewModels/
│   │   │   └── SearchViewModel.swift
│   │   │
│   │   └── Components/
│   │
│   ├── MovieDetails/
│   │   ├── Views/
│   │   │   ├── MovieDetailsView.swift
│   │   │   ├── CastView.swift
│   │   │   └── SimilarMoviesView.swift
│   │   │
│   │   ├── ViewModels/
│   │   │   └── MovieDetailsViewModel.swift
│   │   │
│   │   └── Components/
│   │
│   └── Favorites/
│       ├── Views/
│       │   └── FavoritesView.swift
│       │
│       ├── ViewModels/
│       │   └── FavoritesViewModel.swift
│       │
│       └── Components/
│
├── Resources/
│   ├── Assets.xcassets
│   └── Localizable.xcstrings
│
└── Tests/
    ├── DomainTests/
    ├── DataTests/
    └── FeatureTests/
```

---

# 6. Environment Configuration

Never hardcode API configuration throughout the application.

Do NOT do:

```swift
let apiKey = "YOUR_API_KEY"
```

Do NOT do:

```swift
"https://api.themoviedb.org/3/movie/popular"
```

inside ViewModels or Views.

Use environment configuration.

Example `.env`:

```text
TMDB_API_KEY=your_api_key
TMDB_BASE_URL=https://api.themoviedb.org/3
TMDB_IMAGE_BASE_URL=https://image.tmdb.org/t/p
```

`.env` must be included in `.gitignore`.

The application should expose configuration through:

```swift
AppConfiguration
```

Example:

```swift
enum AppConfiguration {
    static let tmdbAPIKey: String
    static let tmdbBaseURL: String
    static let tmdbImageBaseURL: String
}
```

All configuration values must come from the environment/configuration layer.

---

# 7. Constants

Centralize application constants.

Example:

```text
Core/
└── Configuration/
    └── AppConfiguration.swift
```

Possible constants:

- API base URL
- API key
- Image base URL
- Image sizes
- Request timeout
- Pagination limits

Do not duplicate constants across features.

---

# 8. Networking Layer

Create a reusable networking layer.

Responsibilities:

- Build requests
- Add authentication
- Add query parameters
- Execute HTTP requests
- Decode JSON
- Handle HTTP errors
- Handle network errors
- Handle decoding errors

Architecture:

```text
ViewModel
    ↓
UseCase
    ↓
Repository
    ↓
RemoteDataSource
    ↓
APIClient
    ↓
URLSession
    ↓
TMDB
```

---

# 9. APIClient

Create:

```swift
protocol APIClient {
    func request<T: Decodable>(
        endpoint: APIEndpoint
    ) async throws -> T
}
```

Implementation:

```swift
final class URLSessionAPIClient: APIClient {
    ...
}
```

The API client must be reusable and independent from Movie-specific logic.

---

# 10. API Endpoints

Create an endpoint abstraction.

Example:

```swift
enum TMDBEndpoint {
    case trending
    case popular(page: Int)
    case nowPlaying(page: Int)
    case topRated(page: Int)
    case upcoming(page: Int)
    case search(query: String, page: Int)
    case details(id: Int)
    case credits(id: Int)
    case similar(id: Int, page: Int)
    case videos(id: Int)
}
```

Each endpoint should define:

- HTTP method
- Path
- Query parameters
- Headers

Avoid manually constructing URLs inside features.

---

# 11. DTO Layer

TMDB responses must not directly become Domain entities.

Flow:

```text
TMDB JSON
    ↓
DTO
    ↓
Mapper
    ↓
Domain Entity
```

Example:

```text
MovieDTO
   ↓
MovieMapper
   ↓
Movie
```

DTOs belong in:

```text
Data/DTOs/
```

Domain entities belong in:

```text
Domain/Entities/
```

---

# 12. Domain Entities

The Domain layer should contain clean application models.

Example:

```swift
struct Movie: Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let rating: Double
    let voteCount: Int
    let releaseDate: String
}
```

Do not expose TMDB-specific response structures to SwiftUI.

---

# 13. Repository Pattern

Define repository protocols in Domain.

Example:

```swift
protocol MovieRepository {
    func getTrendingMovies() async throws -> [Movie]
    func getPopularMovies(page: Int) async throws -> [Movie]
    func getNowPlayingMovies(page: Int) async throws -> [Movie]
    func getTopRatedMovies(page: Int) async throws -> [Movie]
    func getUpcomingMovies(page: Int) async throws -> [Movie]

    func searchMovies(
        query: String,
        page: Int
    ) async throws -> [Movie]

    func getMovieDetails(id: Int) async throws -> MovieDetails
}
```

Implementation belongs in:

```text
Data/Repositories/
```

---

# 14. Use Cases

Use Cases contain application/business operations.

Examples:

```text
GetTrendingMoviesUseCase
GetPopularMoviesUseCase
SearchMoviesUseCase
GetMovieDetailsUseCase
GetSimilarMoviesUseCase
```

Example:

```swift
struct GetPopularMoviesUseCase {
    private let repository: MovieRepository

    func execute(page: Int) async throws -> [Movie] {
        try await repository.getPopularMovies(page: page)
    }
}
```

ViewModels should call Use Cases rather than directly calling repositories.

---

# 15. MVVM

Each feature should have:

```text
View
ViewModel
```

Example:

```text
Features/Home/
├── Views/
│   └── HomeView.swift
└── ViewModels/
    └── HomeViewModel.swift
```

Use:

```swift
@Observable
final class HomeViewModel {
    ...
}
```

ViewModels manage:

- UI state
- Loading state
- Error state
- User actions
- Calling use cases
- Updating presentation state

Views should remain focused on UI.

---

# 16. State Management

Use Apple's modern Observation framework.

Primary tools:

```text
@State
@Binding
@Observable
@Environment
```

Do not introduce Redux-style state management initially.

Use local state where appropriate.

Use `@Observable` for feature ViewModels.

Example:

```swift
@Observable
final class HomeViewModel {
    var trendingMovies: [Movie] = []
    var popularMovies: [Movie] = []
    var isLoading = false
    var errorMessage: String?
}
```

---

# 17. Dependency Injection

Create:

```text
App/AppContainer.swift
```

The container should construct:

```text
APIClient
    ↓
RemoteDataSource
    ↓
Repository
    ↓
UseCases
    ↓
ViewModels
```

Avoid creating dependencies directly inside Views.

Bad:

```swift
HomeViewModel(
    repository: MovieRepositoryImpl()
)
```

Better:

```text
AppContainer
     ↓
HomeViewModel
```

Dependency injection should also allow test mocks.

---

# 18. Home Feature

Implement in this order:

### Step 1

Create HomeView.

### Step 2

Create HomeViewModel.

### Step 3

Create trending use case.

### Step 4

Create popular use case.

### Step 5

Connect repository.

### Step 6

Connect TMDB API.

### Step 7

Display real data.

### Step 8

Add loading state.

### Step 9

Add error state.

### Step 10

Add pull-to-refresh.

---

# 19. Home UI

Design principles:

- Minimal
- Modern
- Image-driven
- Large typography
- Generous spacing
- Rounded cards
- Smooth animations
- Strong visual hierarchy

Avoid:

- Excessive gradients
- Too many buttons
- Crowded cards
- Unnecessary borders
- Over-designed UI

Home should feel premium and cinematic.

---

# 20. Movie Card

Create reusable:

```text
Core/Components/MovieCard.swift
```

MovieCard should support:

- Poster
- Title
- Rating
- Release year
- Favorite state

It should be reusable in:

- Home
- Search
- Favorites
- Similar movies

---

# 21. Movie Details Feature

Flow:

```text
MovieCard
    ↓
Navigation
    ↓
MovieDetailsView
    ↓
MovieDetailsViewModel
    ↓
GetMovieDetailsUseCase
    ↓
MovieRepository
    ↓
TMDB
```

Display:

- Hero backdrop
- Poster
- Movie title
- Rating
- Genres
- Runtime
- Release date
- Overview
- Cast
- Similar movies

---

# 22. Search Feature

Search flow:

```text
User enters text
       ↓
Debounce
       ↓
SearchMoviesUseCase
       ↓
Repository
       ↓
TMDB
       ↓
Results
```

Implement:

- Search field
- Debouncing
- Loading indicator
- Search results
- Pagination
- Empty state
- Error state
- Clear button

Do not execute an API request for every keystroke.

---

# 23. Pagination

Implement pagination for:

- Popular movies
- Search results
- Similar movies
- Other large lists

Example:

```text
Page 1
 ↓
User reaches bottom
 ↓
Page 2
 ↓
User reaches bottom
 ↓
Page 3
```

Prevent:

- Duplicate requests
- Duplicate movies
- Multiple simultaneous pagination requests

---

# 24. Favorites

Use SwiftData.

Architecture:

```text
FavoritesView
      ↓
FavoritesViewModel
      ↓
Favorite UseCase
      ↓
Repository
      ↓
SwiftData
```

Create local model:

```text
FavoriteMovie
```

Store enough information to display favorites offline.

---

# 25. Image Loading

TMDB provides image paths rather than complete image URLs.

Create a centralized image system.

Example:

```text
ImageLoader
     ↓
Image Cache
     ↓
Remote Image
```

Requirements:

- Async loading
- Placeholder
- Failure state
- Caching
- Proper image resizing

Avoid downloading unnecessarily large images.

---

# 26. Navigation

Use SwiftUI's modern navigation APIs.

Main navigation:

```text
TabView
├── Home
├── Search
└── Favorites
```

Movie navigation:

```text
Home
 ↓
MovieDetails
```

Similar movie:

```text
MovieDetails
 ↓
Similar Movie
 ↓
MovieDetails
```

Centralize complex navigation where necessary through:

```text
AppRouter
```

---

# 27. Error Handling

Create centralized:

```swift
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case decodingError
    case noInternet
    case unknown
}
```

The UI should convert technical errors into user-friendly messages.

Example:

```text
Technical:
URLError.notConnectedToInternet

UI:
"No internet connection. Please check your connection and try again."
```

---

# 28. Loading States

Every network-driven screen must handle:

```text
Loading
Success
Empty
Error
```

Do not leave screens blank while loading.

Use:

- Skeletons
- Progress indicators
- Placeholders

Prefer skeleton loading for major movie sections.

---

# 29. Empty States

Examples:

Search:

```text
No movies found

Try searching for another title.
```

Favorites:

```text
No favorites yet

Save movies you want to watch later.
```

---

# 30. Pull to Refresh

Home should support:

```swift
.refreshable {
    await viewModel.refresh()
}
```

Refresh should reload the main content cleanly.

---

# 31. Animations

Use subtle animations.

Examples:

- Movie card appearance
- Favorite button
- Hero transitions
- Search result insertion
- Navigation transitions

Animations must improve usability rather than become decoration.

---

# 32. Accessibility

Support:

- Dynamic Type
- VoiceOver
- Accessibility labels
- Sufficient contrast
- Large text
- Reduce Motion

Images should have meaningful accessibility descriptions where appropriate.

---

# 33. Testing

Create tests for:

## Domain

Test:

- Use Cases
- Business logic

## Data

Test:

- DTO decoding
- Mappers
- Repository behavior

## Features

Test:

- ViewModel state
- Loading
- Success
- Error
- Empty states
- Pagination

Create mocks:

```text
MockMovieRepository
MockAPIClient
MockTMDBRemoteDataSource
```

Tests must not depend on the real TMDB API.

---

# 34. Development Phases

## Phase 1 — Project Foundation

Tasks:

- Create Xcode project
- Configure SwiftUI
- Create folder structure
- Configure `.gitignore`
- Configure `.env`
- Create AppConfiguration
- Create AppContainer

Deliverable:

```text
Application launches successfully.
```

---

## Phase 2 — Networking

Tasks:

- APIClient
- URLSession
- APIEndpoint
- HTTPMethod
- NetworkError
- RequestBuilder
- Environment configuration
- TMDB authentication
- JSON decoding

Deliverable:

```text
Successfully fetch movies from TMDB.
```

---

## Phase 3 — Domain + Data

Tasks:

- Movie entity
- DTOs
- Mappers
- Repository protocol
- Repository implementation
- Remote data source
- First Use Case

Deliverable:

```text
TMDB
 ↓
DTO
 ↓
Mapper
 ↓
Movie
```

---

## Phase 4 — Home

Tasks:

- HomeView
- HomeViewModel
- Trending
- Popular
- Now Playing
- Top Rated
- MovieCard
- Loading states
- Error states
- Pull-to-refresh

Deliverable:

```text
Complete movie discovery home screen.
```

---

## Phase 5 — Details

Tasks:

- MovieDetailsView
- MovieDetailsViewModel
- Details API
- Cast
- Genres
- Similar movies
- Videos
- Trailer support

Deliverable:

```text
Complete movie details experience.
```

---

## Phase 6 — Search

Tasks:

- Search UI
- Search ViewModel
- Search Use Case
- Debouncing
- Pagination
- Empty states
- Search history

Deliverable:

```text
Fast movie search experience.
```

---

## Phase 7 — Favorites

Tasks:

- SwiftData
- FavoriteMovie
- Favorites repository
- Favorite Use Cases
- Favorites View
- Add/remove favorite

Deliverable:

```text
Persistent favorites.
```

---

## Phase 8 — Image System

Tasks:

- ImageLoader
- Cache
- Placeholder
- Error state
- Optimized image sizes

Deliverable:

```text
Fast and smooth image experience.
```

---

## Phase 9 — Navigation + Polish

Tasks:

- Tab navigation
- Movie navigation
- Deep navigation
- Animations
- Loading skeletons
- Pull-to-refresh
- Accessibility
- Dark/light appearance

Deliverable:

```text
Production-quality UX.
```

# 35. Coding Rules

Follow these rules throughout the project.

### Rule 1

Views must not make API calls directly.

### Rule 2

ViewModels must not use URLSession.

### Rule 3

Domain must not import SwiftUI.

### Rule 4

Domain must not know about TMDB.

### Rule 5

DTOs must not be exposed directly to Views.

### Rule 6

API configuration must not be hardcoded inside features.

### Rule 7

Dependencies should be injected.

### Rule 8

Use `async/await` instead of completion-handler networking.

### Rule 9

Prefer structs for immutable data models.

### Rule 10

Keep features independent.

### Rule 11

Avoid massive ViewModels.

### Rule 12

Avoid massive Views.

### Rule 13

Reusable UI components belong in Core.

### Rule 14

Feature-specific components belong inside the feature.

### Rule 15

Do not add a third-party library unless there is a clear reason.

---

# 36. Git Strategy

Use small, meaningful commits.

Examples:

```text
chore: initialize movie app project
feat: add environment configuration
feat: implement API client
feat: add TMDB endpoints
feat: add movie domain entity
feat: implement movie repository
feat: add trending movies use case
feat: build home screen
feat: add movie details
feat: implement movie search
feat: add favorites persistence
test: add movie repository tests
refactor: improve dependency injection
```

---

# 37. Definition of Done

The application is considered complete when:

- [ ] App launches successfully
- [ ] Environment variables work
- [ ] No API key is hardcoded in feature code
- [ ] TMDB networking works
- [ ] Clean Architecture is respected
- [ ] MVVM is used
- [ ] `@Observable` is used for ViewModels
- [ ] Feature-based structure is maintained
- [ ] Home works
- [ ] Search works
- [ ] Movie details work
- [ ] Favorites work
- [ ] SwiftData persistence works
- [ ] Pagination works
- [ ] Image caching works
- [ ] Loading states exist
- [ ] Error states exist
- [ ] Empty states exist
- [ ] Pull-to-refresh works
- [ ] Navigation is clean
- [ ] Accessibility is considered
- [ ] Dependencies can be mocked
- [ ] Project builds without warnings related to our implementation
- [ ] README documents setup and architecture

---

# 38. Final Architecture

The final application should follow:

```text
                         ┌──────────────────┐
                         │     SwiftUI      │
                         │      Views       │
                         └────────┬─────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │    ViewModels    │
                         │    @Observable   │
                         └────────┬─────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │     Use Cases    │
                         │      Domain      │
                         └────────┬─────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │    Repository    │
                         │    Protocol      │
                         └────────┬─────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │ Repository Impl  │
                         │       Data       │
                         └────────┬─────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │ Remote DataSource│
                         │      TMDB        │
                         └────────┬─────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │    APIClient     │
                         │    URLSession    │
                         └────────┬─────────┘
                                  │
                                  ▼
                              TMDB API
```

The most important principle:

```text
UI should know about presentation.
Domain should know about business rules.
Data should know about external data sources.
Core should provide shared infrastructure.
Features should own feature-specific behavior.
```

Build the application **phase by phase**. Do not implement Phase 8 before the foundation, networking, Domain, and Data layers are stable.
