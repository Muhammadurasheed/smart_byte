import 'package:flutter/material.dart';

// Mock data for the app
const Map<String, dynamic> mockUserData = {
  'gender': 'Female',
  'age': 30,
  'height': 165, // cm
  'weight': 60, // kg
};

const Map<String, dynamic> mockMealData = {
  'photo': 'https://placehold.co/400x300/e0ffe0/000000?text=Your+Meal',
  'name': 'Grilled Chicken Salad',
  'macros': {
    'calories': {'value': 350, 'color': Colors.red},
    'carbs': {'value': 25, 'color': Colors.blue},
    'fats': {'value': 15, 'color': Colors.amber},
    'protein': {'value': 40, 'color': Colors.green},
    'fiber': {'value': 8, 'color': Colors.purple},
  },
  'servingSize': 1.0, // Mock interaction
};

const Map<String, dynamic> mockDashboardData = {
  'biteSummary': {
    'portionSize': '220g',
    'eatingSpeed': 'Moderate (12g/min)',
    'mealDuration': '18 min',
  },
  'smartSuggestions': [
    {'type': 'alert', 'message': '⚠ Slow down next meal for better digestion'},
    {'type': 'success', 'message': '✅ Perfect portion today!'},
    {'type': 'tip', 'message': '💡 Try adding more leafy greens for fiber.'},
  ],
  'aiFeedback': {
    'biteSpeedIndicator': 'Optimal',
    'portionFeedback': 'You\'re eating 10% under your portion goal – great job!',
    'durationFeedback': 'Meal completed in 18 mins – a good pace for digestion.',
  }
};

const List<Map<String, String>> mockGroceryItems = [
  {'item': 'Spinach', 'reason': 'for more fiber'},
  {'item': 'Quinoa', 'reason': 'for complex carbs and protein'},
  {'item': 'Berries', 'reason': 'for antioxidants'},
  {'item': 'Lean Chicken Breast', 'reason': 'for lean protein'},
  {'item': 'Avocado', 'reason': 'for healthy fats'},
];

void main() {
  runApp(const SmartByteApp());
}

// Reusable Button Component
class PrimaryButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final bool disabled;

  const PrimaryButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.indigo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Make button background transparent to show gradient
          shadowColor: Colors.transparent, // No shadow from the button itself
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        child: child,
      ),
    );
  }
}

// Reusable Card Component
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final String? className; // Not directly used in Flutter for styling, but kept for context if needed

  const CustomCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.className,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

// Header Component with back button
class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const CustomHeader({
    Key? key,
    required this.title,
    this.onBack,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white, // For Android AppBar shadow
      elevation: 2, // Slight shadow
      shadowColor: Colors.grey.withOpacity(0.1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      leading: onBack != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.grey),
              onPressed: onBack,
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontFamily: 'Inter',
        ),
      ),
      centerTitle: true,
    );
  }
}

class SmartByteApp extends StatefulWidget {
  const SmartByteApp({Key? key}) : super(key: key);

  @override
  State<SmartByteApp> createState() => _SmartByteAppState();
}

class _SmartByteAppState extends State<SmartByteApp> {
  int _currentScreenIndex = 0;
  // Using a list of screen names for navigation logic
  final List<String> _screenNames = [
    'welcome',
    'userSetup',
    'goalSelection',
    'dashboard',
    'mealLog',
    'grocery',
    'settings',
  ];

  final PageController _pageController = PageController();

  void _navigateToScreen(String screenName) {
    setState(() {
      _currentScreenIndex = _screenNames.indexOf(screenName);
      _pageController.jumpToPage(_currentScreenIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartByte App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Inter'),
          bodyMedium: TextStyle(fontFamily: 'Inter'),
          labelLarge: TextStyle(fontFamily: 'Inter'),
          titleLarge: TextStyle(fontFamily: 'Inter'),
          titleMedium: TextStyle(fontFamily: 'Inter'),
          headlineMedium: TextStyle(fontFamily: 'Inter'),
        ),
        // Customizing ElevatedButton theme for a consistent look
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, // Text color
            backgroundColor: Colors.blueAccent, // Background color
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
      home: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(), // Disable swipe
          children: [
            WelcomeScreen(onGetStarted: () => _navigateToScreen('userSetup')),
            UserSetupScreen(
              onSetupComplete: (data) {
                // In a real app, save user data
                _navigateToScreen('goalSelection');
              },
              onBack: () => _navigateToScreen('welcome'),
            ),
            GoalSelectionScreen(
              onGoalSelected: (goal) {
                // In a real app, save goal
                _navigateToScreen('dashboard');
              },
              onBack: () => _navigateToScreen('userSetup'),
            ),
            DashboardScreen(
              onLogMeal: () => _navigateToScreen('mealLog'),
              onGrocery: () => _navigateToScreen('grocery'),
              onSettings: () => _navigateToScreen('settings'),
            ),
            MealLoggingScreen(
              onMealLogged: () => _navigateToScreen('dashboard'),
              onBack: () => _navigateToScreen('dashboard'),
            ),
            GroceryRecommendationsScreen(
              onBack: () => _navigateToScreen('dashboard'),
            ),
            SettingsScreen(
              onBack: () => _navigateToScreen('dashboard'),
            ),
          ],
        ),
        bottomNavigationBar:
            _currentScreenIndex >= _screenNames.indexOf('dashboard')
                ? NavigationFooter(
                    currentScreen: _screenNames[_currentScreenIndex],
                    onNavigate: _navigateToScreen,
                  )
                : null,
      ),
    );
  }
}

// 1. Welcome Screen
class WelcomeScreen extends StatelessWidget {
  final VoidCallback onGetStarted;

  const WelcomeScreen({Key? key, required this.onGetStarted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFDCEDC8), Color(0xFFBBDEFB)], // Emerald-100 to Blue-200
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: CustomCard(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipOval(
                  child: Image.network(
                    'https://placehold.co/150x150/81C784/ffffff?text=SmartByte',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'SmartByte',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                    letterSpacing: -1.0,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your smart companion for healthier eating, guided by a smart spoon for perfect portion control.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 48),
                PrimaryButton(
                  onPressed: onGetStarted,
                  child: const Text('Get Started'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 2. User Setup Flow
class UserSetupScreen extends StatefulWidget {
  final ValueChanged<Map<String, String>> onSetupComplete;
  final VoidCallback onBack;

  const UserSetupScreen({
    Key? key,
    required this.onSetupComplete,
    required this.onBack,
  }) : super(key: key);

  @override
  State<UserSetupScreen> createState() => _UserSetupScreenState();
}

class _UserSetupScreenState extends State<UserSetupScreen> {
  int _step = 1;
  final Map<String, String> _formData = {
    'gender': '',
    'age': '',
    'height': '',
    'weight': '',
  };

  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  void _handleNext() {
    if (_step < 4) {
      setState(() {
        _step++;
      });
    } else {
      widget.onSetupComplete(_formData);
    }
  }

  void _handleBack() {
    if (_step > 1) {
      setState(() {
        _step--;
      });
    } else {
      widget.onBack();
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = _step / 4;

    return Scaffold(
      appBar: CustomHeader(
        title: 'Tell us about yourself',
        onBack: _handleBack,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: CustomCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_step == 1) ...[
                      const Text(
                        'What\'s your gender?',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        value: _formData['gender']!.isEmpty ? null : _formData['gender'],
                        hint: const Text('Select...'),
                        onChanged: (String? newValue) {
                          setState(() {
                            _formData['gender'] = newValue!;
                          });
                        },
                        items: <String>['Male', 'Female', 'Other']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: const TextStyle(fontSize: 16)),
                          );
                        }).toList(),
                      ),
                    ],
                    if (_step == 2) ...[
                      const Text(
                        'How old are you?',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'e.g., 30',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onChanged: (value) => _formData['age'] = value,
                      ),
                    ],
                    if (_step == 3) ...[
                      const Text(
                        'What\'s your height (cm)?',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'e.g., 170',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onChanged: (value) => _formData['height'] = value,
                      ),
                    ],
                    if (_step == 4) ...[
                      const Text(
                        'What\'s your weight (kg)?',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'e.g., 70',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onChanged: (value) => _formData['weight'] = value,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            PrimaryButton(
              onPressed: _handleNext,
              child: Text(_step < 4 ? 'Next' : 'Complete Setup'),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. Goal Selection
class GoalSelectionScreen extends StatefulWidget {
  final ValueChanged<String> onGoalSelected;
  final VoidCallback onBack;

  const GoalSelectionScreen({
    Key? key,
    required this.onGoalSelected,
    required this.onBack,
  }) : super(key: key);

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  String? _selectedGoal;

  final List<Map<String, dynamic>> goals = [
    {'id': 'fitness', 'name': 'Fitness', 'icon': Icons.fitness_center},
    {'id': 'health', 'name': 'Health', 'icon': Icons.favorite},
    {'id': 'lifestyle', 'name': 'Lifestyle & Wellness', 'icon': Icons.self_improvement},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHeader(
        title: 'Choose your goal',
        onBack: widget.onBack,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  final goal = goals[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedGoal = goal['id'];
                      });
                    },
                    child: CustomCard(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(goal['icon'], size: 32, color: Colors.blue[700]),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            goal['name'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          if (_selectedGoal == goal['id'])
                            const Icon(Icons.check_circle, color: Colors.blue, size: 28),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            PrimaryButton(
              onPressed: () {
                if (_selectedGoal != null) {
                  widget.onGoalSelected(_selectedGoal!);
                }
              },
              disabled: _selectedGoal == null,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

// 4. Home Dashboard
class DashboardScreen extends StatelessWidget {
  final VoidCallback onLogMeal;
  final VoidCallback onGrocery;
  final VoidCallback onSettings;

  const DashboardScreen({
    Key? key,
    required this.onLogMeal,
    required this.onGrocery,
    required this.onSettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final biteSummary = mockDashboardData['biteSummary'];
    final smartSuggestions = mockDashboardData['smartSuggestions'] as List<dynamic>;
    final aiFeedback = mockDashboardData['aiFeedback'];
    final macros = mockMealData['macros'] as Map<String, dynamic>;

    return Scaffold(
      appBar: const CustomHeader(title: 'Dashboard'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bite Summary
            CustomCard(
              padding: const EdgeInsets.all(24),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.indigo],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Today\'s Bites Summary',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${biteSummary['portionSize']} total bites',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, size: 16, color: Colors.white70),
                            SizedBox(width: 4),
                            Text(
                              'Speed: ${biteSummary['eatingSpeed']}',
                              style: TextStyle(fontSize: 12, color: Colors.white70),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.timer_outlined, size: 16, color: Colors.white70),
                            SizedBox(width: 4),
                            Text(
                              'Duration: ${biteSummary['mealDuration']}',
                              style: TextStyle(fontSize: 12, color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // AI Feedback
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, size: 20, color: Colors.amber[600]),
                      SizedBox(width: 8),
                      Text(
                        'AI Insights',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                            text: 'Bite Speed: ',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        TextSpan(text: aiFeedback['biteSpeedIndicator']),
                      ],
                    ),
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                            text: 'Portion: ',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        TextSpan(text: aiFeedback['portionFeedback']),
                      ],
                    ),
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                            text: 'Meal Pace: ',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        TextSpan(text: aiFeedback['durationFeedback']),
                      ],
                    ),
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
            // Food Logging Card
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Latest Meal Log',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      TextButton.icon(
                        onPressed: onLogMeal,
                        icon: const Icon(Icons.edit_note, size: 20, color: Colors.blue),
                        label: const Text(
                          'Log New',
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          mockMealData['photo'],
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mockMealData['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 3.5, // Adjust as needed
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 16,
                              ),
                              itemCount: macros.length,
                              itemBuilder: (context, index) {
                                final entry = macros.entries.elementAt(index);
                                final key = entry.key;
                                final value = entry.value['value'];
                                final color = entry.value['color'];
                                return Text(
                                  '${key.capitalize()}: $value${key == 'calories' ? '' : 'g'}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: color,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Smart Suggestions
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, size: 20, color: Colors.cyan[600]),
                  SizedBox(width: 8),
                  Text(
                    'Smart Suggestions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                ],
              ),
            ),
            ...smartSuggestions.map((suggestion) {
              Color cardColor = Colors.white;
              Color borderColor = Colors.transparent;
              String emoji = '💡';
              Color emojiColor = Colors.blue[600]!;

              if (suggestion['type'] == 'alert') {
                cardColor = Colors.red[50]!;
                borderColor = Colors.red[400]!;
                emoji = '🚨';
                emojiColor = Colors.red[600]!;
              } else if (suggestion['type'] == 'success') {
                cardColor = Colors.green[50]!;
                borderColor = Colors.green[400]!;
                emoji = '👍';
                emojiColor = Colors.green[600]!;
              } else if (suggestion['type'] == 'tip') {
                cardColor = Colors.blue[50]!;
                borderColor = Colors.blue[400]!;
                emoji = '💡';
                emojiColor = Colors.blue[600]!;
              }

              return CustomCard(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border(left: BorderSide(color: borderColor, width: 4)),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Text(emoji, style: TextStyle(fontSize: 24, color: emojiColor)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          suggestion['message'],
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// 5. Meal Logging (via Photo)
class MealLoggingScreen extends StatefulWidget {
  final VoidCallback onMealLogged;
  final VoidCallback onBack;

  const MealLoggingScreen({
    Key? key,
    required this.onMealLogged,
    required this.onBack,
  }) : super(key: key);

  @override
  State<MealLoggingScreen> createState() => _MealLoggingScreenState();
}

class _MealLoggingScreenState extends State<MealLoggingScreen> {
  String _mealPhoto = mockMealData['photo'];
  double _servingSize = mockMealData['servingSize'];

  // Mock function for picking an image
  void _pickImage() {
    // In a real app, use image_picker package
    // For now, just simulate a change or revert to default
    setState(() {
      _mealPhoto = _mealPhoto == mockMealData['photo']
          ? 'https://placehold.co/400x300/a8e6cf/000000?text=New+Meal+Photo' // Different mock image
          : mockMealData['photo'];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Simulating photo upload/take...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final macros = mockMealData['macros'] as Map<String, dynamic>;

    return Scaffold(
      appBar: CustomHeader(
        title: 'Log Your Meal',
        onBack: widget.onBack,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CustomCard(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _mealPhoto,
                      height: 192,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 192,
                        color: Colors.grey[200],
                        child: const Center(child: Text('Image not loaded')),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take or Upload Photo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: Colors.grey[700],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AI Estimated Breakdown',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3.0, // Adjust as needed
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 16,
                    ),
                    itemCount: macros.length,
                    itemBuilder: (context, index) {
                      final entry = macros.entries.elementAt(index);
                      final key = entry.key;
                      final value = entry.value['value'] * _servingSize; // Apply serving size mock
                      final color = entry.value['color'];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${key.capitalize()}:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: color,
                            ),
                          ),
                          Text(
                            '${value.toStringAsFixed(key == 'calories' ? 0 : 1)}${key == 'calories' ? '' : 'g'}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Adjust Serving Size:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                  ),
                  Slider(
                    value: _servingSize,
                    min: 0.5,
                    max: 2.0,
                    divisions: 15, // 0.1 increments from 0.5 to 2.0
                    label: '${_servingSize.toStringAsFixed(1)}x',
                    activeColor: Colors.blue,
                    inactiveColor: Colors.blue.withOpacity(0.2),
                    onChanged: (newValue) {
                      setState(() {
                        _servingSize = newValue;
                      });
                    },
                  ),
                  Text(
                    'Current: ${_servingSize.toStringAsFixed(1)}x serving (Adjusts macros proportionally)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            PrimaryButton(
              onPressed: widget.onMealLogged,
              child: const Text('Save Meal Log'),
            ),
          ],
        ),
      ),
    );
  }
}

// 6. Grocery Recommendations
class GroceryRecommendationsScreen extends StatelessWidget {
  final VoidCallback onBack;

  const GroceryRecommendationsScreen({Key? key, required this.onBack}) : super(key: key);

  String _getEmoji(String item) {
    switch (item) {
      case 'Spinach': return '🥬';
      case 'Quinoa': return '🍚';
      case 'Berries': return '🍓';
      case 'Lean Chicken Breast': return '🍗';
      case 'Avocado': return '🥑';
      default: return '🛒';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHeader(
        title: 'Grocery Recommendations',
        onBack: onBack,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCard(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade50, Colors.cyan.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border(left: BorderSide(color: Colors.cyan.shade400, width: 4)),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 24, color: Colors.cyan[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personalized for You',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Based on your goals, logged meals, and nutritional gaps.',
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mockGroceryItems.length,
              itemBuilder: (context, index) {
                final item = mockGroceryItems[index];
                return CustomCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(_getEmoji(item['item']!), style: const TextStyle(fontSize: 28)),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['item']!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Add ${item['reason']!}',
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                      OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${item['item']} added to list!')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: BorderSide(color: Colors.blue.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        child: const Text('Add to list'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// 7. Settings Page
class SettingsScreen extends StatelessWidget {
  final VoidCallback onBack;

  const SettingsScreen({Key? key, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHeader(
        title: 'Settings',
        onBack: onBack,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 20, color: Colors.grey[700]),
                      SizedBox(width: 8),
                      Text(
                        'Personal Details',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildSettingDetail('Gender', mockUserData['gender']),
                  _buildSettingDetail('Age', '${mockUserData['age']} years'),
                  _buildSettingDetail('Height', '${mockUserData['height']} cm'),
                  _buildSettingDetail('Weight', '${mockUserData['weight']} kg'),
                ],
              ),
            ),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.devices_other_outlined, size: 20, color: Colors.grey[700]),
                      SizedBox(width: 8),
                      Text(
                        'Device Setup',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildSettingDetail('Smart Spoon', 'Connected (Placeholder)'),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Managing Smart Spoon device...')),
                      );
                    },
                    child: const Text(
                      'Manage Device',
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.notifications_none, size: 20, color: Colors.grey[700]),
                      SizedBox(width: 8),
                      Text(
                        'Notifications',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildToggleSetting(context, 'Portion Alerts', true),
                  _buildToggleSetting(context, 'Daily Tips', false),
                ],
              ),
            ),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.help_outline, size: 20, color: Colors.grey[700]),
                      SizedBox(width: 8),
                      Text(
                        'Help & Support',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildSettingDetail('FAQ', ''), // Placeholder for a link/button
                  _buildSettingDetail('Contact Us', ''), // Placeholder for a link/button
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSetting(BuildContext context, String label, bool initialValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          Switch(
            value: initialValue,
            onChanged: (bool newValue) {
              // In a real app, update state and save preference
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$label ${newValue ? 'enabled' : 'disabled'}')),
              );
            },
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}

// Navigation Footer
class NavigationFooter extends StatelessWidget {
  final String currentScreen;
  final ValueChanged<String> onNavigate;

  const NavigationFooter({
    Key? key,
    required this.currentScreen,
    required this.onNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> navItems = [
      {'name': 'Home', 'icon': Icons.home_outlined, 'screen': 'dashboard'},
      {'name': 'Log Meal', 'icon': Icons.add_box_outlined, 'screen': 'mealLog'},
      {'name': 'Grocery', 'icon': Icons.shopping_cart_outlined, 'screen': 'grocery'},
      {'name': 'Settings', 'icon': Icons.settings_outlined, 'screen': 'settings'},
    ];

    int currentIndex = navItems.indexWhere((item) => item['screen'] == currentScreen);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => onNavigate(navItems[index]['screen']),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey[600],
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      backgroundColor: Colors.white,
      elevation: 8,
      items: navItems.map((item) {
        return BottomNavigationBarItem(
          icon: Icon(item['icon'], size: 26),
          label: item['name'],
        );
      }).toList(),
    );
  }
}

// Extension to capitalize strings (for macro keys)
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
