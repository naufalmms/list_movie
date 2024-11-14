# Movie App

This is a Flutter application that displays a list of movies, allows users to mark movies as favorites, and provides detailed information about individual movies.

## Features

1. **Home Page**: Displays a grid of now playing and upcoming movies.
2. **Movie Detail Page**: Provides detailed information about a selected movie
3. **Favorite Page**: Displays a grid of the user's favorite movies.
4. **Movie Search**: Allows users to search for movies.

## Technologies Used

- Flutter
- Dart
- Bloc (Business Logic Component) pattern for state management
- Http for network requests
- Dartz for functional programming
- Sqflite for local database

## Getting Started

1. Clone the repository:

```
git clone
```

2. Navigate to the project directory:

```
cd movie-app
```

3. Install the dependencies:

```
flutter pub get
```

4. Run the app:

```
flutter run
```

## Project Structure

The project follows the Clean Architecture principles, with the following layers:

1. **Presentation Layer**: Contains the UI components, such as pages, widgets, and BLoCs.
2. **Domain Layer**: Contains the business logic, entities, and use cases.
3. **Data Layer**: Contains the data sources (remote and local), repositories, and models.
4. **Core Layer**: Contains the common utilities

## Future Improvements

1. Implement pagination for movie lists.
2. Feature Favorite Save to Local
