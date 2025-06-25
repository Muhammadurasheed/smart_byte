import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _name = '';
  String _gender = '';
  int _age = 0;
  double _height = 0.0;
  double _weight = 0.0;
  String _goal = '';
  bool _isSetupComplete = false;

  String get name => _name;
  String get gender => _gender;
  int get age => _age;
  double get height => _height;
  double get weight => _weight;
  String get goal => _goal;
  bool get isSetupComplete => _isSetupComplete;

  void updateUserInfo({
    String? name,
    String? gender,
    int? age,
    double? height,
    double? weight,
    String? goal,
  }) {
    if (name != null) _name = name;
    if (gender != null) _gender = gender;
    if (age != null) _age = age;
    if (height != null) _height = height;
    if (weight != null) _weight = weight;
    if (goal != null) _goal = goal;
    notifyListeners();
  }

  void completeSetup() {
    _isSetupComplete = true;
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