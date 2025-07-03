import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smartbyte/screens/home/home_dashboard.dart';
import 'screens/welcome_screen.dart';
import 'utils/app_theme.dart';
import 'providers/user_provider.dart';
import 'providers/meal_provider.dart';
import 'providers/hardware_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartByteApp());
}

class SmartByteApp extends StatelessWidget {
  const SmartByteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
                  ),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ),
            ),
          );
        }

        return _buildMainApp();
      },
    );
  }

  Future<void> _initializeApp() async {
    // Initialize user data from storage
    // This is handled in the provider initialization
  }

  Widget _buildMainApp() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final provider = UserProvider();
            provider.loadUserData(); // Load saved data
            return provider;
          },
        ),
        ChangeNotifierProvider(create: (_) => MealProvider()),
        ChangeNotifierProvider(create: (_) => HardwareProvider()),
      ],
      child: MaterialApp(
        title: 'SmartByte',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.interTextTheme(),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: AppColors.textPrimary),
          ),
        ),
        home: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            if (userProvider.isSetupComplete) {
              return const HomeDashboard();
            } else {
              return const WelcomeScreen();
            }
          },
        ),
      ),
    );
  }
}