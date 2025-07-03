import 'dart:convert';
import 'package:http/http.dart' as http;

class HardwareData {
  final double calorie;
  final double eatingSpeed;
  final double mealDuration;

  HardwareData({
    required this.calorie,
    required this.eatingSpeed,
    required this.mealDuration,
  });

  factory HardwareData.fromJson(Map<String, dynamic> json) {
    return HardwareData(
      calorie: _parseDouble(json['calorie']),
      eatingSpeed: _parseDouble(json['eating_speed']),
      mealDuration: _parseDouble(json['meal_duration']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

class HardwareService {
  static const String _baseUrl = 'http://192.168.4.1';
  static const Duration _timeout = Duration(seconds: 5);

  // Check if hardware is ready
  static Future<bool> checkDeviceReady() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/ready'),
      ).timeout(_timeout);
      
      return response.statusCode == 200 && response.body.toLowerCase().trim() == 'ok';
    } catch (e) {
      print('Hardware readiness check failed: $e');
      return false;
    }
  }

  // Fetch current hardware data
  static Future<HardwareData?> fetchHardwareData() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/status'),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return HardwareData.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Failed to fetch hardware data: $e');
      return null;
    }
  }

  // Send calorie comparison result to hardware
  static Future<bool> sendCalorieStatus(String status) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/trig?status=$status'),
      ).timeout(_timeout);
      
      return response.statusCode == 200;
    } catch (e) {
      print('Failed to send calorie status: $e');
      return false;
    }
  }

  // Get placeholder data for when device is disconnected
  static HardwareData getPlaceholderData() {
    return HardwareData(
      calorie: 0.0,
      eatingSpeed: 0.0,
      mealDuration: 0.0,
    );
  }
}