# MedBook

## Overview
MedBook is an iOS application that allows users to search for books, sort them based on various parameters, and bookmark their favorite books for later use. The app follows a clean and scalable architecture, implementing the MVVM pattern with SOLID principles and Protocol-Oriented Programming for navigation it relies on UINavigationController, SwiftUI is used for the UI, while Core Data and UserDefaults serves as the local storage mechanism.

## Features
### Level 1 - Authentication
- **Landing Screen**
  - Allows users to Sign Up or Log In.
- **Signup Screen**
  - Users can enter their email, password, and select their country.
  - Country data is fetched from [`https://api.first.org/data/v1/countries`](https://api.first.org/data/v1/countries).
  - Default country selection is determined by IP ([`http://ip-api.com/json`](http://ip-api.com/json)) and stored in UserDefaults.
  - Email and password validations:
    - **Email**: Must be a valid email format.
    - **Password**: Minimum 8 characters, at least 1 number, 1 uppercase letter, and 1 special character.
  - User data is stored in Core Data upon successful signup.
- **Login Screen**
  - Users can log in with their stored credentials.
  - Session is maintained until the user logs out.

### Level 2 - Home Screen & Search
- **Book Search**
  - Users can search for books (API: [`https://openlibrary.org/search.json`](https://openlibrary.org/search.json))
  - Search starts when 3+ characters are entered.
  - Results are displayed in a table view with sorting options (**Title, Average Rating, Hits**).
- **Pagination**
  - The app loads 10 results initially and fetches more when scrolling to the bottom.
- **Book Cover Display**
  - Cover images are fetched via [`https://covers.openlibrary.org/b/id/<cover_i>-M.jpg`](https://covers.openlibrary.org/b/id/<cover_i>-M.jpg).

### Level 3 - Bookmarking
- **Bookmark Feature**
  - Users can bookmark/unbookmark books using a trailing action in the search results.
  - Bookmarked books are stored in Core Data and persist after logout.
- **Bookmarks Screen**
  - Users can view all bookmarked books in a dedicated screen.
  - Bookmarks can be removed using a trailing action.

## Architecture & Design Patterns
- **MVVM Architecture**: Promotes separation of concerns and testability.
- **SOLID Principles**: Ensures modular, scalable, and maintainable code.
- **Protocol-Oriented Programming (POP)**: Used for navigation (**UINavigationController-based**).
- **Repository Pattern**: Abstracts Core Data interactions for better separation of concerns.
- **Dependency Injection**: Enables better testability.

  ## TechStack
- **Swift**
- **SwiftUI**
- **UIkit**
- **Core Data**
- **Combine**
- **Swift Package Manager**

## Improvements & Future Enhancements
1. **Test Coverage**: Increase coverage by adding unit tests for services, view models, and repositories.
2. **UI Refinements**: Improve visual aesthetics and animations.
3. **Secure Authentication**: Implement biometric authentication and better password encryption.
4. **Network Security**: Add SSL pinning when connecting to real servers.
5. **Core Data Schema Enhancements**: Improve schema for scalability and efficiency.

## Installation
1. Clone the repository:
   ```sh
   git clone <repo_url>
   cd MedBook
   ```
2. Open `MedBook.xcodeproj` in **Xcode 16**.
3. Build and run on an iOS simulator or device.

## External Dependencies:
   Kingfisher Image Library via SPM

## Contact
For any questions or contributions, feel free to open an issue or submit a pull request.
manish.patidar.97540@gmail.com
contact: 9753986228
