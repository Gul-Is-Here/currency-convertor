import 'package:get/get.dart';
import '../modules/splash/splash_view.dart';
import '../modules/splash/splash_controller.dart';
import '../modules/home/home_view.dart';
import '../modules/converter/converter_view.dart';
import '../modules/chart/chart_view.dart';
import '../modules/favorites/favorites_view.dart';
import '../modules/settings/settings_view.dart';
import '../modules/calculator/calculator_view.dart';
import '../modules/alerts/alerts_view.dart';
import '../modules/expenses/expenses_view.dart';
import '../modules/converter/currency_controller.dart';
import '../modules/chart/chart_controller.dart';
import '../modules/calculator/calculator_controller.dart';
import '../modules/alerts/alerts_controller.dart';
import '../modules/expenses/expense_controller.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SplashController>(() => SplashController());
      }),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CurrencyController>(() => CurrencyController());
      }),
    ),
    GetPage(name: AppRoutes.converter, page: () => const ConverterView()),
    GetPage(
      name: AppRoutes.chart,
      page: () => const ChartView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ChartController>(() => ChartController());
      }),
    ),
    GetPage(name: AppRoutes.favorites, page: () => const FavoritesView()),
    GetPage(name: AppRoutes.settings, page: () => const SettingsView()),
    GetPage(
      name: AppRoutes.calculator,
      page: () => const CalculatorView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CalculatorController>(() => CalculatorController());
      }),
    ),
    GetPage(
      name: AppRoutes.alerts,
      page: () => const AlertsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AlertsController>(() => AlertsController());
      }),
    ),
    GetPage(
      name: AppRoutes.expenses,
      page: () => const ExpensesView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ExpenseController>(() => ExpenseController());
      }),
    ),
  ];
}
