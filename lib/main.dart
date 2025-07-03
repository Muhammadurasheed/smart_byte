import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/welcome_screen.dart';
import 'utils/app_theme.dart';
import 'providers/user_provider.dart';
import 'providers/meal_provider.dart';
import 'providers/hardware_provider.dart';

void main() {
  runApp(const SmartByteApp());
}

class SmartByteApp extends StatelessWidget {
  const SmartByteApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
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
        home: const WelcomeScreen(),
      ),
    );
  }
}