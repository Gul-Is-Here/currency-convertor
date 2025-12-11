import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/providers/local_storage_provider.dart';

class ThemeController extends GetxController {
  final LocalStorageProvider _storage = LocalStorageProvider();

  final RxBool isDarkMode = false.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadThemePreference();
  }

  Future<void> loadThemePreference() async {
    try {
      isLoading.value = true;
      final prefs = await _storage.getThemePreference();
      isDarkMode.value = prefs;
    } catch (e) {
      isDarkMode.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    await _storage.saveThemePreference(isDarkMode.value);

    // Update app theme
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);

    Get.snackbar(
      'Theme Changed',
      'Switched to ${isDarkMode.value ? "Dark" : "Light"} mode',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  ThemeMode get themeMode =>
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
}
