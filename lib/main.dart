import 'dart:async';
import 'package:flutter/material.dart';
import 'myplants.dart';

void main() {
  runApp(const HimigHalamanApp());
}

class HimigHalamanApp extends StatelessWidget {
  const HimigHalamanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _progressValue = 0.0; // Track progress value
  late Timer _timer; // Timer for progress updates

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  /// Starts the loading animation and navigates when complete
  void _startLoading() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _progressValue += 0.005; // Increment progress
        if (_progressValue >= 1.0) {
          _progressValue = 1.0; // Cap at 1.0
          _timer.cancel(); // Stop the timer
          _navigateToNextScreen(); // Navigate to next screen
        }
      });
    });
  }

  /// Navigates to the MyPlants screen after loading
  void _navigateToNextScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyPlantsPage()),
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel timer to avoid leaks
    super.dispose();
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
                image: AssetImage('assets/background.png'), // Replace with valid image path
                fit: BoxFit.cover,
              ),
              color: Colors.black.withOpacity(0.5), // Dark overlay for readability
              backgroundBlendMode: BlendMode.darken,
            ),
          ),
          // Content Centered
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Welcome Text
                const Text(
                  'WELCOME',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // App Icon (Replace with your app logo)
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/icon.png'), // Replace with valid image path
                ),
                const SizedBox(height: 20),
                // App Name
                const Text(
                  'Himig Halaman',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                // Loading Bar
                SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(
                    value: _progressValue,
                    color: Colors.greenAccent,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // Loading Text
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
