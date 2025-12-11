import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background circles
            ..._buildBackgroundCircles(),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo
                  Obx(
                    () => AnimatedScale(
                      scale: controller.logoScale.value,
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.elasticOut,
                      child: AnimatedOpacity(
                        opacity: controller.logoOpacity.value,
                        duration: const Duration(milliseconds: 600),
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.currency_exchange,
                                  size: 60,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // App name with animation
                  Obx(
                    () => AnimatedOpacity(
                      opacity: controller.textOpacity.value,
                      duration: const Duration(milliseconds: 800),
                      child: Column(
                        children: [
                          Text(
                            'CurrencyHub Live',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your Complete Currency & Crypto Companion',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Loading indicator
                  Obx(
                    () => AnimatedOpacity(
                      opacity: controller.loadingOpacity.value,
                      duration: const Duration(milliseconds: 600),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: Stack(
                              children: [
                                // Rotating outer circle
                                AnimatedBuilder(
                                  animation: controller.rotationController,
                                  builder: (context, child) {
                                    return Transform.rotate(
                                      angle:
                                          controller.rotationController.value *
                                          2 *
                                          math.pi,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            width: 3,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // Progress indicator
                                Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    strokeWidth: 3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Loading...',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Version text at bottom
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Obx(
                () => AnimatedOpacity(
                  opacity: controller.textOpacity.value,
                  duration: const Duration(milliseconds: 800),
                  child: Center(
                    child: Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBackgroundCircles() {
    return List.generate(3, (index) {
      return Obx(
        () => Positioned(
          top: -100 + (index * 150.0),
          right: -100 + (index * 80.0),
          child: AnimatedOpacity(
            opacity: controller.circleOpacity.value,
            duration: Duration(milliseconds: 600 + (index * 200)),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000 + (index * 200)),
              curve: Curves.easeInOut,
              width: 200.0 + (index * 50.0),
              height: 200.0 + (index * 50.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05 + (index * 0.02)),
              ),
            ),
          ),
        ),
      );
    });
  }
}
