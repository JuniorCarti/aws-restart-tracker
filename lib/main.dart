import 'package:flutter/material.dart';
import 'package:aws_restart_tracker/screens/home_screen.dart';

void main() {
  runApp(const AWSRestartTracker());
}

class AWSRestartTracker extends StatelessWidget {
  const AWSRestartTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AWS RESTART',
      theme: ThemeData(
        primaryColor: const Color(0xFF232F3E), // AWS Dark Blue
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF232F3E),
          secondary: Color(0xFFFF9900), // AWS Orange
          background: Color(0xFFFAFAFA),
          surface: Colors.white,
        ),
        fontFamily: 'Inter',
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF232F3E),
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          surfaceTintColor: Colors.white,
        ),
        cardColor: Colors.white,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
