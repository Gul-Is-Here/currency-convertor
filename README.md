# CurrencyHub Live 💱

**Your Complete Currency & Crypto Companion**

A beautiful, feature-rich Flutter application with real-time exchange rates, interactive trading charts, cryptocurrency tracking, rate alerts, multi-currency calculator, and offline support.

![Flutter](https://img.shields.io/badge/Flutter-3.10.0%2B-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?logo=dart)
![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Web-blue)

<p align="center">
  <img src="https://img.shields.io/badge/GetX-4.7.3-purple?logo=flutter" alt="GetX">
  <img src="https://img.shields.io/badge/awesome__notifications-0.10.1-orange" alt="Notifications">
  <img src="https://img.shields.io/badge/fl__chart-1.1.1-blue" alt="Charts">
</p>

## 📱 Screenshots

> Add your app screenshots here

## ✨ Features

### 🔄 Real-Time Currency Conversion
- 💱 Live exchange rates from **open.er-api.com** (free, unlimited API)
- 🌍 Support for **30+ major currencies** with flags and symbols
- ⏰ Auto-refresh every 5 minutes
- 💾 Offline caching for uninterrupted access
- 🔄 Currency swap with one tap
- 📝 Recent conversions history
- 📈 Mini-chart showing 7-day trend on home screen

### 🧮 Multi-Currency Calculator
- 💰 Convert one amount to **multiple currencies simultaneously**
- 📊 Beautiful 2-column grid layout
- ⭐ Pre-selected popular currencies (EUR, GBP, JPY, CAD, AUD, CHF)
- ➕ Add/remove currencies easily
- ⚡ Real-time calculations with exchange rates
- 🎯 Perfect for travelers, forex traders, and international business

### 🔔 Rate Alerts System
- 🎯 Create custom alerts for any currency pair
- 📊 Set target rates with **"above" or "below"** conditions
- ⏱️ Automatic monitoring every 5 minutes
- 📲 **Push notifications** when target rates are hit
- ✅ Manage active and triggered alerts
- 💾 Persistent storage across app restarts
- 🎨 Beautiful alert management UI

### 📊 Interactive Charts
- 📈 Historical rate visualization using **fl_chart**
- 📅 Multiple time periods: **7D, 1M, 3M, 1Y**
- 👆 Touch tooltips with precise date and rate values
- 📊 Statistics: High, Low, and Average
- 📈 Percentage change indicators
- 🎨 Gradient line charts with area fill

### ⭐ Favorites Management
- ❤️ Save frequently used currencies
- ⚡ Quick access from converter
- 💱 Live rate updates for favorites
- ➕ Easy add/remove functionality
- 💾 Persistent storage

### 🌓 Dark Mode
- 🌙 Toggle between light and dark themes
- ⚡ Instant theme switching (no restart needed)
- 💾 Persistent preference storage
- 🎨 Beautiful color schemes for both modes
- ⚙️ Accessible in settings

### 📡 Offline Mode Indicator
- 🌐 Real-time network connectivity monitoring
- 🟠 Orange banner when offline
- 📶 Shows connection type (WiFi, Mobile, Ethernet, etc.)
- ⚙️ Connection status in settings
- 💪 Graceful offline handling with cached data

### 🎨 Modern UI/UX
- 🎯 Material Design 3
- ✨ Smooth animations and transitions
- 🎨 Custom gradient buttons
- 💜 Beautiful purple/teal color scheme
- 📱 Bottom navigation for easy access
- 🔄 Pull-to-refresh functionality
- 📱 Responsive layouts
- 🏳️ Currency cards with emoji flags
- 📭 Empty states with helpful messages

### 💾 Data Management
- 💿 Persistent local caching with SharedPreferences
- 📝 Recent conversions history
- 🌐 Works seamlessly without internet
- 🧹 Clear cache and history options
- 💾 Automatic data backup

---

## 🏗️ Architecture

- **State Management**: GetX 4.7.3
- **API**: open.er-api.com (free, unlimited)
- **Charts**: fl_chart 1.1.1
- **Notifications**: awesome_notifications 0.10.1
- **Storage**: shared_preferences 2.5.4
- **Network**: connectivity_plus 6.1.0
- **HTTP**: http 1.6.0
- **Formatting**: intl 0.20.2

### Project Structure
```
lib/
├── app/
│   ├── core/                     # Shared utilities
│   │   ├── controllers/          # ThemeController
│   │   ├── theme/                # AppTheme
│   │   ├── utils/                # FormatUtils
│   │   └── widgets/              # Reusable widgets
│   ├── data/                     # Data layer
│   │   ├── models/               # Data models
│   │   ├── providers/            # API & storage providers
│   │   └── services/             # Business logic services
│   ├── modules/                  # Feature modules
│   │   ├── converter/            # Main conversion
│   │   ├── calculator/           # Multi-currency calculator
│   │   ├── alerts/               # Rate alerts
│   │   ├── chart/                # Historical charts
│   │   ├── favorites/            # Favorites
│   │   ├── settings/             # Settings
│   │   └── home/                 # Bottom nav container
│   └── routes/                   # GetX navigation
└── main.dart                     # App entry point
```

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: 3.10.0 or higher
- **Dart**: 3.0 or higher
- **Android Studio** / **VS Code** with Flutter extension
- **Xcode** (for iOS development on macOS)

### Installation

```bash
# Clone the repository
git clone https://github.com/Gul-Is-Here/currency-convertor.git

# Navigate to project directory
cd currency-convertor

# Install dependencies
flutter pub get

# Run the app (Web)
flutter run -d chrome

# Run the app (Android)
flutter run -d android

# Run the app (iOS)
flutter run -d ios
```

---

## 📱 Platform Setup

### Android
- **minSdk**: 21 (Android 5.0+)
- **targetSdk**: 34 (Android 14)
- **Package**: com.gulishereapps.currency_convertor

### iOS
- **Minimum**: iOS 12.0+
- **Bundle ID**: Set in Xcode
- **Deployment Target**: iOS 12.0

### Web
- **Browsers**: Chrome, Safari, Firefox, Edge
- **Note**: Notifications work only when tab is active

See [PLATFORM_SETUP_GUIDE.md](PLATFORM_SETUP_GUIDE.md) for detailed configuration.

---

## 🔧 Configuration

### API Configuration
No API key required! The app uses **open.er-api.com** which is:
- ✅ Free
- ✅ Unlimited requests
- ✅ No authentication needed
- ✅ HTTPS enabled

### Notification Setup
1. Android: Permissions auto-requested at runtime
2. iOS: Permission requested on first alert creation
3. Web: Browser permission prompt appears

---

## 📚 Documentation

Comprehensive guides available:
- 📖 [Dark Mode Guide](DARK_MODE_GUIDE.md)
- 📖 [Offline Mode Guide](OFFLINE_MODE_GUIDE.md)
- 📖 [Multi-Currency Calculator Guide](CALCULATOR_GUIDE.md)
- 📖 [Rate Alerts System Guide](RATE_ALERTS_GUIDE.md)
- 📖 [Platform Setup Guide](PLATFORM_SETUP_GUIDE.md)
- 📖 [Progress Report](PROGRESS_REPORT.md)
- 📖 [Features Documentation](FEATURES.md)
- 📖 [Development Guide](DEV_GUIDE.md)
- 📖 [Project Summary](PROJECT_SUMMARY.md)

---

## 🎯 Usage

### Converting Currency
1. Open app → Converter tab (default)
2. Enter amount in "From" currency
3. Select currencies by tapping flags
4. View converted amount in real-time
5. Tap swap icon to reverse currencies

### Multi-Currency Calculator
1. Tap calculator icon (📊) in app bar
2. Enter amount to convert
3. Select base currency
4. Tap "Add" to select target currencies
5. View all conversions in grid layout
6. Remove currencies with X button

### Creating Rate Alerts
1. Go to Settings → Rate Alerts
2. Tap "New Alert" button
3. Select currency pair
4. Choose condition (above/below)
5. Enter target rate
6. Tap "Create"
7. Wait for notification when target is hit

### Viewing Charts
1. Tap mini-chart on home screen
2. Or tap chart icon in converter
3. Select time period (7D/1M/3M/1Y)
4. Touch chart to view exact values
5. View statistics (High/Low/Average)

### Managing Favorites
1. Open Favorites tab
2. Tap ➕ to add currencies
3. View live rates for favorites
4. Swipe to remove favorites

### Enabling Dark Mode
1. Tap Settings icon (⚙️)
2. Toggle "Dark Mode" switch
3. Theme changes instantly

---

## 🏗️ Building

### Debug Build
```bash
# Android
flutter build apk --debug

# iOS
flutter build ios --debug
```

### Release Build
```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Analyze code
flutter analyze

# Format code
dart format lib/
```

---

## 📦 Dependencies

### Core
- **get**: ^4.7.3 (State management, routing, dependency injection)
- **http**: ^1.6.0 (HTTP requests)
- **intl**: ^0.20.2 (Date and number formatting)
- **shared_preferences**: ^2.5.4 (Local storage)

### Features
- **fl_chart**: ^1.1.1 (Interactive charts)
- **connectivity_plus**: ^6.1.0 (Network monitoring)
- **awesome_notifications**: ^0.10.1 (Push notifications)

### UI
- **cupertino_icons**: ^1.0.8 (iOS-style icons)

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `flutter format` before committing
- Add comments for complex logic
- Write unit tests for new features

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Gul-Is-Here**
- GitHub: [@Gul-Is-Here](https://github.com/Gul-Is-Here)

---

## 🙏 Acknowledgments

- **Open Exchange Rates API**: [open.er-api.com](https://open.er-api.com)
- **Flutter Team**: For the amazing framework
- **GetX**: For excellent state management
- **awesome_notifications**: For notification support
- **fl_chart**: For beautiful charts
- **Community**: All contributors and users

---

## 📊 Project Stats

- **Lines of Code**: ~8,000+
- **Files**: 40+
- **Features**: 8 major features
- **Documentation**: 10 comprehensive guides
- **Supported Currencies**: 30+
- **Platforms**: Android, iOS, Web

---

## 🗺️ Roadmap

### Completed ✅
- [x] Real-time currency conversion
- [x] Interactive charts
- [x] Favorites management
- [x] Dark mode
- [x] Offline mode indicator
- [x] Multi-currency calculator
- [x] Rate alerts system
- [x] Platform configuration

### Planned 🔮
- [ ] Expense tracker module
- [ ] Cloud sync
- [ ] Multiple themes
- [ ] Currency news feed
- [ ] Widgets support
- [ ] Voice input
- [ ] Export to CSV/PDF
- [ ] Biometric authentication

---

## 📞 Support

If you encounter any issues or have questions:
1. Check the [Documentation](FEATURES.md)
2. Search existing [Issues](https://github.com/Gul-Is-Here/currency-convertor/issues)
3. Create a new issue with details
4. Contact the developer

---

## ⭐ Show Your Support

If you like this project, please give it a ⭐ on GitHub!

---

## 📸 Demo

> Add GIFs or video demonstrations here

---

**Made with ❤️ using Flutter**

