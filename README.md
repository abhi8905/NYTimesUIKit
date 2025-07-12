# NYTimesUIKit# NYTimesUIKit

**NYTimesUIKit** is a UIKit-based iOS application that consumes New York Times article data using the modular `nytkit` Swift Package. It demonstrates how to architect a clean and scalable UIKit app by isolating core business logic into a reusable SPM component.

---

## nytkit (Swift Package)

`nytkit` encapsulates the shared data and networking logic used across both UIKit and SwiftUI-based applications.

### Core Responsibilities

- **Networking**: API requests to NYTimes “Most Popular” endpoints
- **Models**: Codable entities like `Article`, `ArticleAPIResponse`, and `MostPopularFilter`
- **Caching**:
  - `ResponseCache`: Response-level caching with TTL and stale-while-revalidate logic
  - `ImageCache`: In-memory image caching for efficient thumbnail loading
- **Environment Switching**: Dynamically handles dev and production endpoints via `APIEnvironment`
- **Reachability**: `NetworkMonitor` uses `NWPathMonitor` to track connectivity changes
- **Typed Error Handling**: `APIError` provides granular decoding and network error feedback
- **State Management**: Unified `ViewState` enum simplifies UI feedback handling across clients

---

## NYTimesUIKit (UIKit Client)

This app integrates `nytkit` to build a fast, modular, and maintainable UIKit experience.

### Features

- **Coordinators**
  - `AppCoordinator` – manages app lifecycle
  - `ArticleListCoordinator` – pushes list screen
  - `ArticleDetailCoordinator` – presents article details
- **View Controllers**
  - `ArticleListViewController`: Handles data rendering, filtering, reachability, and errors
  - `ArticleDetailViewController`: Presents details for selected articles
- **UI Components**
  - `ArticleCell`: Custom cell with thumbnail, title, byline, and publish date
  - `EmptyStateView`, `PaddingLabel`, and utility extensions for layout and image caching
- **Live Filters**: Switch between most viewed, shared, and emailed using `MostPopularFilter`
- **Connectivity Handling**: Offline mode displays contextual UI using `NetworkMonitor`
- **Secrets Handling**: API Key is injected securely using `.xcconfig` (`Secrets.xcconfig`)

---

## Architecture

The app follows a modular MVVM-Coordinator architecture.

- **MVVM**: ViewModels encapsulate business logic and state. ViewControllers observe state and update UI accordingly.
- **Coordinator**: Navigation logic is separated from view controllers for cleaner transitions and testability.
- **SPM Integration**: All networking, caching, filtering, and API modeling is delegated to the shared `nytkit` package.

---

## Highlights

- Dynamic filters (endpoint, period)
- Async loading and structured error UI
- Offline awareness with graceful fallback
- Caches responses and images for performance

---


## Testing

- **Coverage**: ~95% unit test coverage for `nytkit`
- **Areas Covered**:
  - Networking layer
  - Cache logic
  - API response decoding
  - Filter logic and key generation
  - Connectivity fallback and retry behavior

---

## Installation

### Step 1: Add `nytkit` via Swift Package Manager

1. In Xcode, open **File > Add Packages...**
2. Enter your Git URL (e.g. `https://github.com/abhi8905/nytkit.git`)
3. Choose the version or branch
4. Add to your UIKit target under **Frameworks, Libraries, and Embedded Content**

> The `nytkit` package is UI-independent and can be reused across SwiftUI or other iOS clients.

---
