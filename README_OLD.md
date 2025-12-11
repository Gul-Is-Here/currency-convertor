# Currency Converter 💱

A beautiful, feature-rich Flutter currency converter app with real-time exchange rates, interactive charts, and offline support.

![Flutter](https://img.shields.io/badge/Flutter-3.10.0%2B-02569B?logo=flutter)
![License](https://img.shields.io/badge/license-MIT-green)

## ✨ Features

### 🔄 Real-Time Currency Conversion
- Live exchange rates from open.er-api.com
- Support for 30+ major currencies
- Auto-refresh every 5 minutes
- Offline caching for uninterrupted access
- Currency swap with one tap

### 📊 Interactive Charts
- Historical rate visualization using fl_chart
- Multiple time periods (7D, 1M, 3M, 1Y)
- Touch tooltips with precise values
- High, Low, and Average statistics
- Percentage change indicators

### ⭐ Favorites Management
- Save frequently used currencies
- Quick access from converter
- Live rate updates for favorites
- Easy add/remove functionality

### 🎨 Modern UI/UX
- Material Design 3
- Smooth animations and transitions
- Custom gradient buttons
- Beautiful color scheme (Purple/Teal)
- Bottom navigation for easy access
- Pull-to-refresh functionality

### 💾 Offline Support
- Persistent local caching
- Recent conversions history
- Works without internet connection

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.10.0 or higher
- Dart 3.0 or higher

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Gul-Is-Here/currency-convertor.git
cd currency-convertor
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# For Chrome
flutter run -d chrome

# For Android
flutter run -d android

# For iOS
flutter run -d ios
```

## 🏗️ Architecture

This app follows clean architecture principles with GetX state management:

```
lib/
├── app/
│   ├── core/              # Shared utilities, theme, widgets
│   ├── data/              # Models, providers, services
│   ├── modules/           # Feature modules (converter, chart, favorites)
│   └── routes/            # Navigation setup
└── main.dart              # App entry point
```

### Key Components

- **Models**: Currency, ExchangeRate, HistoricalRate
- **Providers**: CurrencyApiProvider, LocalStorageProvider, CurrencyData
- **Services**: CurrencyService (business logic layer)
- **Controllers**: CurrencyController, ChartController (GetX state management)
- **Views**: ConverterView, ChartView, FavoritesView, HomeView

## 🛠️ Technologies Used

| Technology | Purpose |
|------------|---------|
| **Flutter** | Cross-platform UI framework |
| **GetX** | State management, navigation, dependency injection |
| **http** | API communication |
| **fl_chart** | Beautiful interactive charts |
| **shared_preferences** | Local data persistence |
| **intl** | Number and date formatting |

## 🌐 API

This app uses the free **exchangerate-api.com** service:
- **Base URL**: https://open.er-api.com/v6
- **No API key required**
- **Unlimited requests**
- **Real-time exchange rates**

## 🎯 Future Enhancements

### Planned Features
1. ⚠️ **Rate Alerts** - Get notifications when rates reach your target
2. 🔢 **Multi-Currency Calculator** - Convert multiple currencies at once
3. 🌙 **Dark Mode Toggle** - User preference for theme
4. 📤 **Export History** - Save conversions as CSV/PDF
5. 🎤 **Voice Input** - Speak amounts to convert
6. 🔒 **Biometric Auth** - Secure favorite rates with fingerprint/face ID
7. 📲 **Home Screen Widget** - Quick conversion widget
8. 🌍 **More Currencies** - Expand to 100+ currencies
9. 📈 **Advanced Charts** - Candlestick charts, technical indicators
10. 🔔 **Push Notifications** - Daily rate summaries

### Suggested Improvements
- **Comparison Mode**: Side-by-side currency comparison
- **Offline Indicator**: Show when using cached data
- **Custom Rate**: Add custom exchange rates for personal tracking
- **Currency Converter API**: Switch between multiple API providers
- **Historical Data Export**: Download historical rates
- **Rate History**: View all rate changes for a currency pair
- **Currency News**: Latest forex news integration
- **Calculator Mode**: Advanced calculator with currency support

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

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

**Gul-Is-Here**
- GitHub: [@Gul-Is-Here](https://github.com/Gul-Is-Here)

## 🙏 Acknowledgments

- [exchangerate-api.com](https://exchangerate-api.com) for free exchange rate data
- [fl_chart](https://pub.dev/packages/fl_chart) for beautiful charts
- [GetX](https://pub.dev/packages/get) for state management
- Flutter community for amazing packages and support

---

Made with ❤️ using Flutter

