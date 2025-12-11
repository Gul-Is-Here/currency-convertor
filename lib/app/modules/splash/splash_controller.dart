import 'package:get/get.dart';
import 'package:flutter/material.dart';
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

    // Navigate to home after splash duration
    await Future.delayed(const Duration(milliseconds: 2500));
    _navigateToHome();
  }

  void _navigateToHome() {
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  void onClose() {
    rotationController.dispose();
    super.onClose();
  }
}
