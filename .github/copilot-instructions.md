# Copilot Instructions for the CoFi Project

Welcome to the CoFi project! This document provides essential guidelines for AI coding agents to be productive in this codebase.

## Project Overview
CoFi is a Flutter-based mobile application designed to enhance the coffee shop experience. The app includes features such as:
- Viewing coffee shop details (`CafeDetailsScreen`)
- Logging visits (`LogVisitScreen`)
- Writing and submitting reviews (`WriteReviewScreen` and `ReviewShopScreen`)
- Authentication workflows (`SplashScreen`, `SignupScreen`, etc.)

## Architecture
- **Screens**: Located in `lib/screens/`, each screen represents a distinct feature or user interaction.
- **Widgets**: Reusable UI components are in `lib/widgets/`.
- **Utilities**: Shared constants and colors are defined in `lib/utils/`.
- **Routing**: Navigation between screens is managed using `MaterialApp` routes in `main.dart`.

## Key Files
- `main.dart`: Entry point of the application. Defines global routes and the app theme.
- `lib/screens/cafe_details_screen.dart`: Displays detailed information about coffee shops.
- `lib/screens/log_visit_screen.dart`: Allows users to log their visits.
- `lib/screens/write_review_screen.dart`: Enables users to write reviews.
- `lib/screens/review_shop_screen.dart`: Provides a detailed review submission interface.
- `lib/utils/colors.dart`: Defines the primary color scheme for the app.

## Developer Workflows
### Build and Run
- Use `flutter run` to start the application.
- Ensure dependencies are installed using `flutter pub get`.

### Debugging
- Use `flutter analyze` to check for linting issues.
- Debug screens by setting breakpoints in the respective Dart files.

### Testing
- Widget tests are located in `test/widget_test.dart`. Run tests using `flutter test`.

## Project-Specific Conventions
- **UI Components**: Use `TextWidget` for consistent text styling across screens.
- **UI Components**: Use custom widgets from `lib/widgets/` across screens.
- **Navigation**: Define routes in `main.dart` and use `Navigator.push` for screen transitions.
- **Color Scheme**: Use `primary` from `lib/utils/colors.dart` for branding consistency.

## Examples
### Adding a New Screen
1. Create a new Dart file in `lib/screens/`.
2. Define a `StatelessWidget` or `StatefulWidget`.
3. Add the screen to `main.dart` routes.

### Navigating Between Screens
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => NewScreen(),
  ),
);
```

### Using `TextWidget`
```dart
TextWidget(
  text: 'Hello, World!',
  fontSize: 16,
  color: Colors.white,
);
```

## External Dependencies
- **Flutter**: Ensure the Flutter SDK is installed.
- **Pub Packages**: Dependencies are managed via `pubspec.yaml`. Run `flutter pub get` after adding new packages.

Feel free to update this document as the project evolves!
