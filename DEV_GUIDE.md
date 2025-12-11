# Development Quick Reference Guide

## 🚀 Quick Start Commands

```bash
# Setup
flutter pub get                          # Install dependencies
flutter clean && flutter pub get         # Clean install

# Run
flutter run                              # Run on connected device
flutter run -d chrome                    # Run on Chrome
flutter run -d android                   # Run on Android
flutter run -d ios                       # Run on iOS
flutter run --release                    # Release mode

# Build
flutter build apk --release             # Android APK
flutter build appbundle --release       # Android App Bundle
flutter build ios --release             # iOS IPA
flutter build web --release             # Web build
flutter build windows --release         # Windows exe

# Quality
flutter analyze                         # Analyze code
dart fix --apply                        # Auto-fix issues
dart format lib/                        # Format code
flutter test                            # Run tests
flutter test --coverage                 # With coverage

# Dev Tools
flutter devices                         # List devices
flutter doctor                          # Check setup
flutter logs                            # View logs
flutter clean                           # Clean build
```

## 📂 File Organization

### Adding a New Currency

**File:** `lib/app/data/providers/currency_data.dart`

```dart
static final Map<String, Map<String, String>> currencyInfo = {
  'BTC': {'name': 'Bitcoin', 'symbol': '₿', 'flag': '₿'},
  // Add your currency here
};
```

### Adding a New Feature Module

```bash
# Create directory structure
mkdir -p lib/app/modules/feature_name
cd lib/app/modules/feature_name

# Create files
touch feature_controller.dart
touch feature_view.dart
touch feature_binding.dart  # Optional
```

**Controller Template:**
```dart
import 'package:get/get.dart';

class FeatureController extends GetxController {
  // Observables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadData();
  }
  
  @override
  void onClose() {
    // Cleanup
    super.onClose();
  }
  
  Future<void> loadData() async {
    try {
      isLoading.value = true;
      // Your logic here
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
```

**View Template:**
```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'feature_controller.dart';

class FeatureView extends StatelessWidget {
  const FeatureView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FeatureController());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        
        return ListView(
          children: [
            // Your UI here
          ],
        );
      }),
    );
  }
}
```

### Adding a Route

**Step 1:** Add route constant in `app_routes.dart`
```dart
class AppRoutes {
  static const String feature = '/feature';
}
```

**Step 2:** Add page in `app_pages.dart`
```dart
GetPage(
  name: AppRoutes.feature,
  page: () => const FeatureView(),
  binding: BindingsBuilder(() {
    Get.lazyPut<FeatureController>(() => FeatureController());
  }),
),
```

**Step 3:** Navigate
```dart
Get.toNamed(AppRoutes.feature);
```

## 🎨 Theming

### Using App Colors

```dart
import '../../core/theme/app_theme.dart';

// Colors
AppTheme.primaryColor       // #6C63FF
AppTheme.secondaryColor     // #00D4AA
AppTheme.accentColor        // #FF6584
AppTheme.backgroundColor    // #F8F9FA
AppTheme.successColor       // #00B894
AppTheme.errorColor         // #D63031

// Gradients
AppTheme.primaryGradient
AppTheme.cardGradient
```

### Custom Widget Styling

```dart
// Gradient Button
GradientButton(
  text: 'Click Me',
  icon: Icons.star,
  onPressed: () {},
  isLoading: false,
)

// Currency Card
CurrencyCard(
  flag: '🇺🇸',
  code: 'USD',
  name: 'US Dollar',
  onTap: () {},
  isSelected: false,
)
```

## 🔄 State Management (GetX)

### Creating Observables

```dart
// Simple observable
final RxInt count = 0.obs;
final RxString name = ''.obs;
final RxBool isLoading = false.obs;
final RxDouble amount = 0.0.obs;

// Object observable
final Rx<Currency?> currency = Rx<Currency?>(null);

// List observable
final RxList<Currency> currencies = <Currency>[].obs;
```

### Updating Observables

```dart
// Option 1: Direct assignment
count.value = 10;
name.value = 'John';

// Option 2: Using methods
count.value++;
currencies.add(newCurrency);
currencies.remove(currency);
```

### Observing Changes

```dart
// In widget
Obx(() => Text('Count: ${controller.count.value}'))

// Listen to changes
ever(count, (value) {
  print('Count changed to $value');
});

// Listen once
once(count, (value) {
  print('Count changed once to $value');
});

// Debounce (wait for pause in changes)
debounce(searchQuery, (value) {
  performSearch(value);
}, time: const Duration(milliseconds: 500));
```

### Dependency Injection

```dart
// Put (create and register)
Get.put(MyController());

// Lazy put (create only when needed)
Get.lazyPut(() => MyController());

// Put async (wait for Future to complete)
await Get.putAsync(() async => await MyService.init());

// Find (get existing instance)
final controller = Get.find<MyController>();

// Delete (remove from memory)
Get.delete<MyController>();
```

## 🌐 API Integration

### Adding New API Endpoint

**Step 1:** Add method in `currency_api_provider.dart`
```dart
Future<MyData> getMyData() async {
  try {
    final url = '$baseUrl/endpoint';
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MyData.fromJson(data);
    } else {
      throw Exception('Failed: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}
```

**Step 2:** Add service method in `currency_service.dart`
```dart
Future<MyData> getMyData() async {
  try {
    return await _apiProvider.getMyData();
  } catch (e) {
    // Handle error, try cache, etc.
    rethrow;
  }
}
```

**Step 3:** Use in controller
```dart
Future<void> loadMyData() async {
  try {
    isLoading.value = true;
    final data = await _service.getMyData();
    myData.value = data;
  } catch (e) {
    errorMessage.value = e.toString();
  } finally {
    isLoading.value = false;
  }
}
```

## 💾 Local Storage

### Saving Data

```dart
final storage = LocalStorageProvider();

// Save string
await storage.setBaseCurrency('USD');

// Save list
await storage.saveFavorites(['USD', 'EUR', 'GBP']);

// Save complex data
await storage.cacheRates('USD', ratesMap);
```

### Reading Data

```dart
// Read string
final base = await storage.getBaseCurrency();

// Read list
final favorites = await storage.getFavorites();

// Read complex data
final rates = await storage.getCachedRates('USD');
```

## 🧪 Testing

### Unit Test Template

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyClass', () {
    test('should do something', () {
      // Arrange
      final myClass = MyClass();
      
      // Act
      final result = myClass.doSomething();
      
      // Assert
      expect(result, equals(expectedValue));
    });
  });
}
```

### Widget Test Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MyWidget displays correctly', (tester) async {
    // Build widget
    await tester.pumpWidget(
      const MaterialApp(
        home: MyWidget(),
      ),
    );
    
    // Verify
    expect(find.text('Hello'), findsOneWidget);
    expect(find.byType(Button), findsOneWidget);
    
    // Interact
    await tester.tap(find.byType(Button));
    await tester.pump();
    
    // Verify after interaction
    expect(find.text('Clicked'), findsOneWidget);
  });
}
```

## 🐛 Debugging

### Print Debugging

```dart
// Simple print
print('Value: $value');

// Debug print (only in debug mode)
debugPrint('Debug: $value');

// Pretty print objects
debugPrintStack();
```

### GetX Debugging

```dart
// Log all GetX events
GetMaterialApp(
  enableLog: true,
  logWriterCallback: (text, {isError = false}) {
    print('GetX Log: $text');
  },
);
```

### Flutter DevTools

```bash
# Open DevTools
flutter run
# Then press 'v' in terminal

# Or open in browser
flutter pub global activate devtools
flutter pub global run devtools
```

## 📱 Platform-Specific Code

```dart
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

if (kIsWeb) {
  // Web-specific code
} else if (Platform.isAndroid) {
  // Android-specific code
} else if (Platform.isIOS) {
  // iOS-specific code
}
```

## 🔧 Common Issues & Solutions

### Issue: Hot reload not working
```bash
# Solution: Hot restart
flutter run
# Press 'R' in terminal
```

### Issue: Gradle build failed (Android)
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Issue: Pod install failed (iOS)
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

### Issue: GetX controller not found
```dart
// Make sure to put controller before finding
Get.put(MyController());  // First
final controller = Get.find<MyController>();  // Then find
```

### Issue: State not updating
```dart
// Make sure variable is observable
final RxInt count = 0.obs;  // Not: final int count = 0;

// Update with .value
count.value++;  // Not: count++;

// Wrap with Obx()
Obx(() => Text('${count.value}'))  // Not: Text('$count')
```

## 📚 Useful Resources

- [Flutter Docs](https://docs.flutter.dev/)
- [GetX Documentation](https://pub.dev/packages/get)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)

## 💡 Pro Tips

1. **Always use const**: Improves performance significantly
2. **Lazy load controllers**: Use `Get.lazyPut()` for better memory management
3. **Cache API responses**: Reduce network calls and improve UX
4. **Use proper error handling**: Try-catch everywhere with meaningful messages
5. **Comment complex logic**: Help your future self
6. **Test on real devices**: Emulators don't show all issues
7. **Profile performance**: Use DevTools to find bottlenecks
8. **Keep dependencies updated**: But test after updating
9. **Use meaningful names**: Code reads like a story
10. **Follow Flutter conventions**: Makes code maintainable

---

**Happy Coding! 🚀**
