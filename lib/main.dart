import 'dart:async';
import 'login.dart';
import 'package:flutter/material.dart';

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
  double _progressValue = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _progressValue += 0.005; // Increment the progress
        if (_progressValue >= 1.0) {
          _progressValue = 1.0; // Cap the value at 1.0
          _timer.cancel(); // Stop the timer when the progress completes
          _navigateToNextScreen(); // Navigate to the next screen
        }
      });
    });
  }

  void _navigateToNextScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/background.png'), // Replace with your image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay for darkening background (optional for readability)
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Content
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
                // App Icon
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                      'assets/icon.png'), // Replace with your app icon
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
                // Determinate Loading Bar
                SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(
                    value: _progressValue, // Set the progress value
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text(
          'Welcome to Himig Halaman!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
