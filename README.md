# Planner+

A production-quality Flutter task planner application with offline-first architecture and automatic synchronization.

## Features

### Core Functionality
- **CRUD Operations**: Create, read, update, and delete tasks
- **Task Management**:
  - Task title and description
  - Priority levels (Low, Medium, High)
  - Due dates
  - Tags for organization
  - Completion status
- **Advanced Features**:
  - Search functionality
  - Filtering (All, Completed, Pending)
  - Sorting (by Date, Title, Priority)
  - Grouping (by Priority, Status, Date)

### Offline-First Architecture
- **Local Storage**: Uses Hive for fast, efficient local data storage
- **Offline Mode**: Full app functionality works without internet connection
- **Automatic Sync**: Synchronizes local changes with remote server when online
- **Connectivity Detection**: Real-time network status monitoring

### UI/UX
- **Material Design 3**: Modern, beautiful UI with Material You theming
- **Dark Mode**: Full support for light and dark themes
- **Responsive Design**: Adapts to different screen sizes
- **Accessibility**: Semantic labels and screen reader support
- **Animations**: Smooth transitions and animations
- **Empty States**: Helpful messages when no data is available

### Internationalization
- **Multi-language Support**: English and Russian
- **System Locale Detection**: Automatically uses system language

## Architecture

### Clean Architecture
The project follows clean architecture principles with clear separation of concerns:

```
lib/
├── core/                    # Core functionality
│   ├── di/                 # Dependency injection
│   ├── errors/             # Error handling
│   ├── theme/              # App theming
│   └── router/             # Navigation
├── data/                    # Data layer
│   ├── datasources/        # Local and remote data sources
│   ├── models/             # Data models
│   └── repositories/       # Repository implementations
├── domain/                  # Domain layer
│   ├── entities/           # Business entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business logic
└── presentation/            # Presentation layer
    ├── bloc/               # State management
    ├── screens/            # UI screens
    └── widgets/            # Reusable widgets
```

### Key Design Decisions

#### State Management
- **BLoC Pattern**: Uses `flutter_bloc` for predictable state management
- **Reactive Updates**: Real-time UI updates via streams
- **Event-Driven**: Clear separation between events and state

#### Data Management
- **Hive**: Fast, lightweight local storage with type adapters
- **Dio**: Robust HTTP client with interceptors and error handling
- **Repository Pattern**: Single source of truth for data access

#### Navigation
- **GoRouter**: Declarative routing with deep linking support
- **Custom Transitions**: Smooth page transitions

#### Dependency Injection
- **get_it**: Service locator for dependency management
- **Lazy Loading**: Dependencies initialized only when needed

## Dependencies

### Core
- `flutter_bloc`: State management
- `equatable`: Value equality
- `get_it`: Dependency injection

### Data
- `hive` & `hive_flutter`: Local storage
- `dio`: HTTP client
- `connectivity_plus`: Network connectivity
- `shared_preferences`: Simple key-value storage

### Navigation
- `go_router`: Declarative routing

### UI
- `flutter_svg`: SVG support
- `shimmer`: Loading effects
- `intl`: Internationalization

### Development
- `build_runner`: Code generation
- `hive_generator`: Hive adapter generation
- `mocktail`: Testing
- `bloc_test`: BLoC testing
- `very_good_analysis`: Linting

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/planner_plus.git
cd planner_plus
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code (if needed):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

### Running Tests

Run all tests:
```bash
flutter test
```

Run tests with coverage:
```bash
flutter test --coverage
```

### Building

Build APK:
```bash
flutter build apk --release
```

Build iOS:
```bash
flutter build ios --release
```

Build Web:
```bash
flutter build web --release
```

## Testing

The project includes comprehensive testing:

### Unit Tests
- **Domain Layer**: Use case tests
- **Data Layer**: Repository and data source tests
- Located in `test/unit/`

### Widget Tests
- **UI Components**: Screen and widget tests
- **User Interactions**: Tap, scroll, input tests
- Located in `test/widget/`

### Test Coverage
The project maintains high test coverage focusing on:
- Critical business logic
- Data transformations
- User interactions

## Code Quality

### Linting
The project uses `very_good_analysis` for strict code analysis:
- Null safety enforcement
- Consistent code style
- Best practices

### Static Analysis
```bash
flutter analyze
```

### Formatting
```bash
flutter format lib/ test/
```

## Offline Mode & Synchronization

### How It Works

1. **Offline-First**: All operations work locally first
2. **Change Tracking**: Modified tasks marked as "not synced"
3. **Automatic Sync**: When online, changes sync automatically
4. **Conflict Resolution**: Server data takes precedence

### Sync Demo

To demonstrate offline functionality:

1. Launch the app with internet connection
2. Create some tasks (they sync immediately)
3. Turn off internet (airplane mode)
4. Create/edit/delete tasks (works normally)
5. Notice "Not synced" indicator
6. Turn on internet
7. Tap sync button
8. Tasks synchronize with server

## API Integration

The app uses JSONPlaceholder (https://jsonplaceholder.typicode.com) as a mock API for demonstration purposes.

In production, replace with your actual API:
1. Update `TaskRemoteDataSourceImpl.baseUrl`
2. Implement authentication if needed
3. Adjust API endpoints to match your backend

## Localization

### Adding a New Language

1. Create ARB file in `l10n/`:
```
l10n/app_de.arb
```

2. Add translations (copy from `app_en.arb`)

3. Add locale to `main.dart`:
```dart
supportedLocales: const [
  Locale('en'),
  Locale('ru'),
  Locale('de'), // Add new locale
],
```

## Accessibility

The app includes accessibility features:
- Semantic labels for icons and buttons
- Screen reader support
- Sufficient color contrast
- Touch target sizes meet guidelines
- Focus management

## Performance

### Optimizations
- Lazy loading of dependencies
- Efficient list rendering
- Minimal rebuilds with BLoC
- Fast local storage with Hive
- Image and asset optimization

### Monitoring
- Use Flutter DevTools for performance profiling
- Monitor frame rendering times
- Track memory usage

## Future Enhancements

Potential improvements:
- [ ] Task reminders and notifications
- [ ] Recurring tasks
- [ ] Task sharing and collaboration
- [ ] Cloud backup
- [ ] Task attachments
- [ ] Calendar integration
- [ ] Analytics and insights

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Write/update tests
5. Ensure all tests pass
6. Submit a pull request

## License

This project is licensed under the MIT License.

## Contact

For questions or feedback, please open an issue on GitHub.

## Acknowledgments

- Flutter team for the amazing framework
- Community packages and libraries
- JSONPlaceholder for the mock API
