import 'dart:async';
import 'package:flutter/material.dart';
import 'settings/theme.dart'; // Import your ThemeManager
import 'myplants.dart'; // Import your MyPlantsPage
import 'package:provider/provider.dart'; // Add Provider for state management

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeManager(),
      child: const HimigHalamanApp(),
    ),
  );
}

class HimigHalamanApp extends StatelessWidget {
  const HimigHalamanApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme, // Light theme configuration
      darkTheme: AppThemes.darkTheme, // Dark theme configuration
      themeMode: themeManager.themeMode, // Apply current theme
      initialRoute: '/', // Define the initial route
      routes: {
        '/': (context) => const LoadingScreen(), // Loading screen as the initial screen
        '/myplants': (context) => const MyPlantsPage(), // Navigate to MyPlantsPage
      },
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    for (int i = 0; i < 100; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        _progressValue = (i + 1) / 100.0; // Update progress value
      });
    }
    _navigateToNextScreen(); // Once loading is complete, navigate to the next screen
  }

  void _navigateToNextScreen() {
    Navigator.pushReplacementNamed(context, '/myplants'); // Use named routes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with image and overlay
          Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/background.png'), // Ensure the path is correct
                fit: BoxFit.cover,
              ),
              color: Colors.black.withOpacity(0.5),
              backgroundBlendMode: BlendMode.darken,
            ),
          ),
          // Content Centered
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'WELCOME',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/icon.png'), // Ensure the path is correct
                ),
                const SizedBox(height: 20),
                const Text(
                  'Himig Halaman',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                // Loading Progress Indicator
                SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(
                    value: _progressValue, // Bind progress value
                    color: Colors.greenAccent,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
