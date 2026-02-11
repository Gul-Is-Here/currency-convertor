import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../converter/converter_view.dart';
import '../favorites/favorites_view.dart';
import '../calculator/calculator_view.dart';
import '../expenses/expenses_view.dart';
import '../../core/theme/app_theme.dart';
import '../../routes/app_routes.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ConverterView(),
    const FavoritesView(),
    const CalculatorView(),
    const ExpensesView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              title: const Text('CurrencyHub Live'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => Get.toNamed(AppRoutes.alerts),
                  tooltip: 'Rate Alerts',
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => Get.toNamed(AppRoutes.settings),
                ),
              ],
            )
          : _selectedIndex == 1
          ? AppBar(title: const Text('Crypto Market'))
          : null, // Calculator & Expenses have their own AppBars
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            // Haptic feedback on tab switch
            HapticFeedback.lightImpact();
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: AppTheme.textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.currency_exchange),
              label: 'Converter',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.currency_bitcoin),
              label: 'Crypto',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate),
              label: 'Calculator',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Expenses',
            ),
          ],
        ),
      ),
    );
  }
}
