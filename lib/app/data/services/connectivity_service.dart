import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final RxBool isOnline = true.obs;
  final Rx<ConnectivityResult> connectionStatus = ConnectivityResult.none.obs;
  final RxBool isInitialized = false.obs;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result, isInitialCheck: true);
      isInitialized.value = true;
    } catch (e) {
      isOnline.value = false;
      isInitialized.value = true;
    }
  }

  void _updateConnectionStatus(
    List<ConnectivityResult> results, {
    bool isInitialCheck = false,
  }) {
    if (results.isEmpty) {
      connectionStatus.value = ConnectivityResult.none;
      final wasOnline = isOnline.value;
      isOnline.value = false;

      // Only show snackbar if we just went offline (not on initial load)
      if (wasOnline && !isInitialCheck && isInitialized.value) {
        Get.snackbar(
          'No Internet Connection',
          'You are offline. Showing cached data.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
      return;
    }

    final result = results.first;
    connectionStatus.value = result;

    // Consider mobile, wifi, and ethernet as online
    final wasOffline = !isOnline.value;
    isOnline.value = result != ConnectivityResult.none;

    // // Show back online message only if we were previously offline
    // if (wasOffline &&
    //     isOnline.value &&
    //     !isInitialCheck &&
    //     isInitialized.value) {
    //   Get.snackbar(
    //     'Back Online',
    //     'Internet connection restored.',
    //     snackPosition: SnackPosition.BOTTOM,
    //     duration: const Duration(seconds: 2),
    //     backgroundColor: const Color(0xFF4CAF50),
    //     colorText: Colors.white,
    //   );
    // }
  }

  String get connectionType {
    switch (connectionStatus.value) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.other:
        return 'Other';
      case ConnectivityResult.none:
        return 'Offline';
    }
  }
}
