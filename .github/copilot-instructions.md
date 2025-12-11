# Copilot Instructions for Currency Converter

## Project Overview
A full-featured Flutter currency converter app with real-time exchange rates, interactive charts, favorites, and offline caching. Built with GetX for state management and follows clean architecture principles.

## Tech Stack
- **Flutter SDK**: 3.10.0+
- **State Management**: GetX 4.7.3
- **API**: exchangerate-api.com (free, open-source)
- **Charts**: fl_chart 1.1.1
- **Storage**: shared_preferences 2.5.4
- **HTTP**: http 1.6.0
- **Formatting**: intl 0.20.2
- **Linting**: flutter_lints ^6.0.0

## Project Architecture

### Folder Structure
```
lib/
├── app/
│   ├── core/                 # Shared utilities
│   │   ├── theme/           # AppTheme, color schemes
│   │   ├── utils/           # FormatUtils, constants
│   │   └── widgets/         # Reusable widgets (GradientButton, CurrencyCard)
│   ├── data/                # Data layer
│   │   ├── models/          # Currency, ExchangeRate, HistoricalRate models
│   │   ├── providers/       # API and storage providers
│   │   └── services/        # CurrencyService (business logic)
│   ├── modules/             # Feature modules
│   │   ├── converter/       # Main conversion screen
│   │   ├── chart/           # Historical rate charts
│   │   ├── favorites/       # Favorite currencies
│   │   └── home/            # Bottom nav container
│   └── routes/              # GetX navigation
│       ├── app_routes.dart
│       └── app_pages.dart
└── main.dart                # App entry point with GetMaterialApp
```

## Key Features Implemented

### 1. Real-Time Currency Conversion
- Live exchange rates from open.er-api.com (no API key needed)
- Auto-refresh every 5 minutes
- Offline caching with shared_preferences
- Support for 30+ major currencies with flags and symbols

### 2. Interactive Charts
- Historical rate visualization using fl_chart
- Multiple time periods (7D, 1M, 3M, 1Y)
- Touch tooltips showing date and rate
- Statistics (High, Low, Average)
- Percentage change indicators

### 3. Favorites Management
- Save preferred currencies
- Quick access from converter
- Real-time rate display for favorites
- Persistent storage

### 4. Modern UI
- Material Design 3
- Custom gradient buttons and cards
- Smooth animations
- Purple/teal color scheme
- Bottom navigation

## Development Workflow

### Running the App
```bash
# Run with hot reload
flutter run

# Run on specific device
flutter run -d chrome  # or ios, android

# Clean and rebuild
flutter clean && flutter pub get && flutter run
```

### Testing
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Code Quality
```bash
# Analyze code
flutter analyze

# Format all files
dart format lib/

# Fix lint issues
dart fix --apply
```

## GetX State Management Patterns

### Controller Structure
```dart
class MyController extends GetxController {
  final RxType observable = initialValue.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Initialize data
  }
  
  @override
  void onClose() {
    // Clean up resources
    super.onClose();
  }
}
```

### Using Controllers in Views
```dart
// Get or create controller
final controller = Get.put(MyController());

// Find existing controller
final controller = Get.find<MyController>();

// Observe changes
Obx(() => Text(controller.observable.value))
```

### Navigation
```dart
// Navigate to route
Get.toNamed(AppRoutes.chart);

// Go back
Get.back();

// Show snackbar
Get.snackbar('Title', 'Message', snackPosition: SnackPosition.BOTTOM);
```

## API Integration

### Open Exchange Rates API
- **Base URL**: https://open.er-api.com/v6
- **Endpoint**: `/latest/{base_currency}`
- **Free tier**: Unlimited requests
- **No authentication** required

### Data Flow
1. `CurrencyApiProvider` makes HTTP requests
2. `CurrencyService` handles business logic + caching
3. `CurrencyController` manages UI state
4. `LocalStorageProvider` persists data

### Adding New API Features
1. Add method to `CurrencyApiProvider`
2. Create service method in `CurrencyService`
3. Expose in controller
4. Update UI to consume data

## Common Tasks

### Adding a New Currency
1. Update `currencyInfo` map in `lib/app/data/providers/currency_data.dart`
2. Include: name, symbol, flag emoji

### Creating a New Feature Module
```bash
mkdir lib/app/modules/feature_name
touch lib/app/modules/feature_name/{feature_controller.dart,feature_view.dart}
```

### Adding a Route
1. Add route constant in `app_routes.dart`
2. Add GetPage in `app_pages.dart` with binding
3. Navigate with `Get.toNamed(AppRoutes.yourRoute)`

### Customizing Theme
- Edit `lib/app/core/theme/app_theme.dart`
- Update colors in `AppTheme` class
- Both light and dark themes available

## Widget Conventions

### Reusable Widgets
- `GradientButton`: Styled button with gradient
- `CurrencyCard`: Display currency with flag
- All in `lib/app/core/widgets/`

### Layout Patterns
- Use `Card` for elevated content
- `RefreshIndicator` for pull-to-refresh
- `Obx()` for reactive UI updates

## Performance Tips
- Use `const` constructors wherever possible
- Lazy load controllers with `Get.lazyPut()`
- Cache API responses to reduce network calls
- Dispose timers in controller's `onClose()`

## Debugging
```bash
# Check for errors
flutter analyze

# View logs
flutter logs

# Run in profile mode
flutter run --profile
```

## Suggested Feature Enhancements
1. **Push notifications** for rate alerts (using flutter_local_notifications)
2. **Multi-currency calculator** - convert multiple currencies at once
3. **Rate alerts** - notify when rate reaches target
4. **Offline mode indicator** - show when using cached data
5. **Currency comparison** - side-by-side rate comparison
6. **Export history** - save conversion history as CSV
7. **Dark mode toggle** - user preference for theme
8. **Biometric auth** - secure favorite rates
9. **Voice input** - speak amounts to convert
10. **Widget support** - home screen widget for quick conversion

## Testing Strategy
- Widget tests for UI components
- Unit tests for models and utilities
- Integration tests for API calls
- Mock data for offline testing

## Common Issues

### API Not Working
- Check internet connection
- Verify API URL in `currency_api_provider.dart`
- Check if cached data is being used

### State Not Updating
- Ensure using `.obs` for observables
- Wrap UI in `Obx()` or `GetBuilder()`
- Call `.value` when accessing observables

### Navigation Errors
- Verify route is registered in `app_pages.dart`
- Check controller bindings
- Ensure using `Get.toNamed()` not `Navigator.push()`

