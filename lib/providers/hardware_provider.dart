import 'dart:async'; // Add this import for Timer
import 'package:flutter/material.dart';
import '../services/hardware_service.dart';

class HardwareProvider with ChangeNotifier {
  HardwareData _hardwareData = HardwareService.getPlaceholderData();
  bool _isConnected = false;
  bool _isLoading = false;
  String? _lastError;
  Timer? _pollingTimer;

  HardwareData get hardwareData => _hardwareData;
  bool get isConnected => _isConnected;
  bool get isLoading => _isLoading;
  String? get lastError => _lastError;

  Future<void> initialize() async {
    await checkConnectionAndFetchData();
    _startPolling();
  }

  // Start polling every 1 second
  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      checkConnectionAndFetchData();
    });
  }

  // Check connection and fetch data
  Future<void> checkConnectionAndFetchData() async {
    if (_isLoading) return; // Skip if already loading

    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      // Check if device is ready
      final isReady = await HardwareService.checkDeviceReady();
      
      if (isReady) {
        // Fetch current data
        final data = await HardwareService.fetchHardwareData();
        
        if (data != null) {
          _hardwareData = data;
          _isConnected = true;
        } else {
          _isConnected = false;
          _lastError = 'Failed to fetch data';
        }
      } else {
        _isConnected = false;
        _hardwareData = HardwareService.getPlaceholderData();
        _lastError = 'Device not ready';
      }
    } catch (e) {
      _isConnected = false;
      _hardwareData = HardwareService.getPlaceholderData();
      _lastError = 'Connection failed';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Send calorie comparison to hardware
  Future<void> sendCalorieComparison(double currentCalorie, double maxCalorie) async {
    if (!_isConnected) return;

    final status = currentCalorie > maxCalorie ? 'over' : 'under';
    await HardwareService.sendCalorieStatus(status);
  }

  // Refresh data manually
  Future<void> refresh() async {
    await checkConnectionAndFetchData();
  }

  // Cancel the timer when the provider is disposed
  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}