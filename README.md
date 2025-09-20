## GitHub Pull Requests App 🚀

A Flutter application that displays open pull requests from GitHub repositories using the GitHub REST API. Built with BLoC pattern for state management and featuring a clean, responsive UI.

## 📱 Features

### Core Features
- ✅ Fetch and display pull requests from GitHub REST API
- ✅ Show PR title, description, author, and creation date
- ✅ Simulated login functionality with persistent session management
- ✅ Persistent login state management with boolean flag storage

### 🎉 Bonus Features Implemented
- 🔍 **Advanced PR Filters**: Filter pull requests by status (Open, Closed, All)
- 📊 **Smart Sorting**: Sort by created date or updated date
- 🔄 **Order Control**: Sort in newest first or oldest first order
- 🔑 **Persistent Login**: Login once and stay logged in with boolean flag storage
- 🏠 **Auto Navigation**: Automatic home screen navigation for logged-in users
- 🔄 **Pull-to-Refresh**: Refresh PR data using RefreshIndicator widget
- ✨ **Shimmer Animation**: Beautiful loading animations using shimmer package
- 📱 **Responsive Design**: Flexible UI layout using ScreenUtil package

## 🏗️ Project Structure

```
lib/
├── 📁 BLOC/
│   ├── 📁 Login/
│   │   ├── 🔷 Login_bloc.dart          # Login business logic
│   │   ├── 🔷 Login_event.dart         # Login events (LoginRequested, etc.)
│   │   └── 🔷 Login_state.dart         # Login states (Initial, Loading, Success, Error)
│   └── 📁 pullRequest/
│       ├── 🔷 pr_bloc.dart             # Pull Request business logic
│       ├── 🔷 pr_event.dart            # PR events (FetchPRs, FilterPRs, etc.)
│       └── 🔷 pr_state.dart            # PR states (Loading, Loaded, Error)
├── 📁 Core/
│   ├── 🔷 app_colors.dart              # App color constants
│   └── 🔷 const.dart                   # Global constants and configurations
├── 📁 Data/
│   ├── 📁 Model/
│   │   ├── 🔷 PrModel.dart             # Pull Request data model
│   │   └── 🔷 userModel.dart           # User data model
│   └── 📁 Services/
│       ├── 🔷 githubService.dart       # GitHub API service
│       └── 🔷 LoginService.dart        # Authentication service
└── 📁 Presentation/
    ├── 📁 Screens/
    │   ├── 🔷 HomeScreen.dart          # Main PR listing screen
    │   ├── 🔷 LoginScreen.dart         # Login/authentication screen
    │   └── 🔷 shimmerLoading.dart      # Shimmer loading widgets
    └── 🔷 main.dart                    # App entry point
```

## 🧠 BLoC Pattern Explained

This app uses the **BLoC (Business Logic Component)** pattern for state management, which provides a clear separation of concerns and predictable state management.

### What is BLoC?
BLoC is a design pattern that separates business logic from UI components using streams. It consists of three main components:

### 📤 **Events**
Events represent user interactions or system triggers that can change the app's state.

**Login Events:**
- `LoginRequested` - User attempts to login
- `LogoutRequested` - User attempts to logout
- `CheckLoginStatus` - Check if user is already logged in

**Pull Request Events:**
- `FetchPullRequests` - Load PRs from API
- `FilterPullRequests` - Filter PRs by status
- `SortPullRequests` - Sort PRs by date
- `RefreshPullRequests` - Refresh PR data

### 📥 **States**
States represent the current condition of the app at any given time.

**Login States:**
- `LoginInitial` - Initial state
- `LoginLoading` - Authentication in progress
- `LoginSuccess` - User successfully authenticated
- `LoginFailure` - Authentication failed

**Pull Request States:**
- `PullRequestInitial` - Initial state
- `PullRequestLoading` - Loading PRs
- `PullRequestLoaded` - PRs successfully loaded
- `PullRequestError` - Error occurred while loading

### ⚡ **BLoC**
The BLoC component processes events and emits corresponding states. It contains the business logic and manages the flow between events and states.

## 🔐 Authentication Handling

The app implements simulated login functionality to demonstrate session management:

1. **Login Process**: User enters credentials on login screen
2. **Session Storage**: On successful login, a boolean flag is set to `true`
3. **Persistent Login**: Uses `SharedPreferences` to store login state
4. **Auto Navigation**: App checks login status on startup and navigates accordingly
5. **Session Management**: User stays logged in until manual logout

### Login State Implementation
```dart
// Store login state
await SharedPreferences.getInstance()
    .then((prefs) => prefs.setBool('isLoggedIn', true));

// Check login status
final prefs = await SharedPreferences.getInstance();
final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

// Navigate based on login state
if (isLoggedIn) {
  // Navigate to Home Screen
} else {
  // Show Login Screen
}
```

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- Android Studio / VS Code
- Git

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd github-pr-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### 📦 Key Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.3           # State management
  http: ^1.1.0                   # API calls
  shared_preferences: ^2.2.2     # Local storage
  shimmer: ^3.0.0                # Loading animations
  flutter_screenutil: ^5.9.0     # Responsive design
```

## 🎯 Usage

1. **Launch App**: App checks for existing login session
2. **Login** (if not authenticated): Enter any credentials to simulate login
3. **View PRs**: Browse pull requests with title, description, author, and date
4. **Filter & Sort**: Use filter options (Open/Closed/All) and sort by created/updated date with newest/oldest order
5. **Pull-to-Refresh**: Pull down on the PR list to refresh data using RefreshIndicator
6. **Logout**: Clear session and return to login screen

## 🐞 Known Issues & Limitations

### Current Limitations
- **Mock Authentication**: Uses simulated login instead of real GitHub OAuth
- **Static Repository**: Currently hardcoded to fetch from a specific repository
- **Limited Error Handling**: Basic error messages without detailed API error codes
- **No Offline Support**: Requires internet connection to fetch data
- **Rate Limiting**: No handling for GitHub API rate limits

### Future Enhancements
- [ ] Real GitHub OAuth integration
- [ ] Repository selection functionality
- [ ] Offline caching with local database
- [ ] Enhanced error handling and user feedback
- [ ] Dark mode support
- [ ] PR detail view with comments and files
- [ ] Search functionality within PRs

## 🛠️ Technical Details

### Architecture
- **Pattern**: BLoC (Business Logic Component)
- **API**: GitHub REST API v3
- **Storage**: SharedPreferences for token persistence
- **UI**: Responsive design with ScreenUtil
- **Loading**: Shimmer animations for better UX

### API Endpoints Used
```
GET /repos/{owner}/{repo}/pulls
Parameters: state, sort, direction
```

### Performance Optimizations
- Shimmer loading for perceived performance
- Pull-to-refresh for manual data updates
- Efficient list rendering with ListView.builder
- Responsive layout adaptation

## 📄 License

This project is created for educational purposes as part of a Flutter development assignment.

---

**Built with ❤️ using Flutter & BLoC Pattern**
