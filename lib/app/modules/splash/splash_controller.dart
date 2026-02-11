import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Animation observables
  final logoScale = 0.0.obs;
  final logoOpacity = 0.0.obs;
  final textOpacity = 0.0.obs;
  final loadingOpacity = 0.0.obs;
  final circleOpacity = 0.0.obs;

  // Rotation controller for loading animation
  late AnimationController rotationController;

  @override
  void onInit() {
    super.onInit();

    // Initialize rotation controller
    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    // Animate background circles
    await Future.delayed(const Duration(milliseconds: 100));
    circleOpacity.value = 1.0;

    // Animate logo
    await Future.delayed(const Duration(milliseconds: 300));
    logoScale.value = 1.0;
    logoOpacity.value = 1.0;

    // Animate text
    await Future.delayed(const Duration(milliseconds: 600));
    textOpacity.value = 1.0;

    // Animate loading indicator
    await Future.delayed(const Duration(milliseconds: 400));
    loadingOpacity.value = 1.0;

    // Navigate after splash duration
    await Future.delayed(const Duration(milliseconds: 2500));
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

    if (onboardingComplete) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }

  @override
  void onClose() {
    rotationController.dispose();
    super.onClose();
  }
}
