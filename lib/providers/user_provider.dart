import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String _name = '';
  String _gender = '';
  int _age = 0;
  double _height = 0.0;
  double _weight = 0.0;
  String _goal = '';
  double _maxCalorie = 0.0;
  bool _isSetupComplete = false;

  String get name => _name;
  String get gender => _gender;
  int get age => _age;
  double get height => _height;
  double get weight => _weight;
  String get goal => _goal;
  double get maxCalorie => _maxCalorie;
  bool get isSetupComplete => _isSetupComplete;

  // Load user data from secure storage
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('user_name') ?? '';
    _gender = prefs.getString('user_gender') ?? '';
    _age = prefs.getInt('user_age') ?? 0;
    _height = prefs.getDouble('user_height') ?? 0.0;
    _weight = prefs.getDouble('user_weight') ?? 0.0;
    _goal = prefs.getString('user_goal') ?? '';
    _maxCalorie = prefs.getDouble('user_max_calorie') ?? 0.0;
    _isSetupComplete = prefs.getBool('setup_complete') ?? false;
    notifyListeners();
  }

  // Save user data to secure storage
  Future<void> saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _name);
    await prefs.setString('user_gender', _gender);
    await prefs.setInt('user_age', _age);
    await prefs.setDouble('user_height', _height);
    await prefs.setDouble('user_weight', _weight);
    await prefs.setString('user_goal', _goal);
    await prefs.setDouble('user_max_calorie', _maxCalorie);
    await prefs.setBool('setup_complete', _isSetupComplete);
  }

  void updateUserInfo({
    String? name,
    String? gender,
    int? age,
    double? height,
    double? weight,
    String? goal,
    double? maxCalorie,
  }) {
    if (name != null) _name = name;
    if (gender != null) _gender = gender;
    if (age != null) _age = age;
    if (height != null) _height = height;
    if (weight != null) _weight = weight;
    if (goal != null) _goal = goal;
    if (maxCalorie != null) _maxCalorie = maxCalorie;
    notifyListeners();
    saveUserData(); // Auto-save when data updates
  }

  Future<void> completeSetup() async {
    _isSetupComplete = true;
    await saveUserData();
    notifyListeners();
  }

  double get bmi {
    if (_height > 0 && _weight > 0) {
      return _weight / ((_height / 100) * (_height / 100));
    }
    return 0.0;
  }

  String get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue < 18.5) return 'Underweight';
    if (bmiValue < 25) return 'Normal';
    if (bmiValue < 30) return 'Overweight';
    return 'Obese';
  }
}