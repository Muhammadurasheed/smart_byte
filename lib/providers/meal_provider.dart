import 'package:flutter/material.dart';

class Meal {
  final String id;
  final String name;
  final String imageUrl;
  final DateTime timestamp;
  final double calories;
  final double carbs;
  final double protein;
  final double fat;
  final double fiber;
  final double portionSize;
  final double eatingDuration;
  final double eatingSpeed;

  Meal({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.timestamp,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.fiber,
    required this.portionSize,
    required this.eatingDuration,
    required this.eatingSpeed,
  });

  // Factory constructor to handle type conversion
  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      imageUrl: map['imageUrl']?.toString() ?? '',
      timestamp: map['timestamp'] ?? DateTime.now(),
      calories: _toDouble(map['calories']),
      carbs: _toDouble(map['carbs']),
      protein: _toDouble(map['protein']),
      fat: _toDouble(map['fat']),
      fiber: _toDouble(map['fiber']),
      portionSize: _toDouble(map['portionSize']),
      eatingDuration: _toDouble(map['eatingDuration']),
      eatingSpeed: _toDouble(map['eatingSpeed']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

class MealProvider with ChangeNotifier {
  final List<Meal> _meals = [
    Meal(
      id: '1',
      name: 'Grilled Chicken Salad',
      imageUrl: 'https://images.pexels.com/photos/1059905/pexels-photo-1059905.jpeg?auto=compress&cs=tinysrgb&w=800',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      calories: 420,
      carbs: 15,
      protein: 35,
      fat: 18,
      fiber: 8,
      portionSize: 320,
      eatingDuration: 12.0,
      eatingSpeed: 26.7,
    ),
    Meal(
      id: '2',
      name: 'Breakfast Bowl',
      imageUrl: 'https://images.pexels.com/photos/1332189/pexels-photo-1332189.jpeg?auto=compress&cs=tinysrgb&w=800',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      calories: 380,
      carbs: 45,
      protein: 20,
      fat: 12,
      fiber: 12,
      portionSize: 280,
      eatingDuration: 15.0,
      eatingSpeed: 18.7,
    ),
  ];

  List<Meal> get meals => _meals;

  double get todayCalories {
    final today = DateTime.now();
    return _meals
        .where((meal) => 
            meal.timestamp.day == today.day &&
            meal.timestamp.month == today.month &&
            meal.timestamp.year == today.year)
        .fold(0.0, (sum, meal) => sum + meal.calories);
  }

  double get averageEatingSpeed {
    if (_meals.isEmpty) return 0.0;
    return _meals.fold(0.0, (sum, meal) => sum + meal.eatingSpeed) / _meals.length;
  }

  void addMeal(Meal meal) {
    _meals.insert(0, meal);
    notifyListeners();
  }

  List<String> get aiSuggestions {
    final suggestions = <String>[];
    
    if (averageEatingSpeed > 25) {
      suggestions.add("⚠️ Try eating slower for better digestion");
    } else {
      suggestions.add("✅ Great eating pace today!");
    }
    
    if (todayCalories > 2000) {
      suggestions.add("📊 You're over your calorie goal today");
    } else if (todayCalories > 1800) {
      suggestions.add("✅ Perfect portion control today!");
    }
    
    suggestions.add("🥬 Add more leafy greens to your next meal");
    
    return suggestions;
  }
}