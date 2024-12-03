import 'package:flutter/material.dart';
import 'camera.dart';
import 'explore.dart';
import 'myplants.dart';
import 'navbar.dart';
import 'settings.dart';

class PlantScannerPage extends StatefulWidget {
  const PlantScannerPage({super.key});

  @override
  _PlantScannerPageState createState() => _PlantScannerPageState();
}

class _PlantScannerPageState extends State<PlantScannerPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _scanAnimation;

  @override
  void initState() {
    super.initState();
    // Create the animation controller for the scanning line
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Repeat the animation to create the back-and-forth effect

    // Create the animation for the scanning line moving up and down
    _scanAnimation = Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 1))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBEA), // Light greenish background
      body: SafeArea(
        child: SingleChildScrollView( // Make the entire screen scrollable
          child: Column(
            children: [
              // Header and Search Bar
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Profile and Settings Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.person, size: 30, color: Color(0xFF376F47)),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings, size: 30, color: Color(0xFF376F47)),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Placeholder for the scanner UI
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage('assets/plant-bg.png'), height: 200), // Display first image as plant scanner UI
                    Text(
                      "Use the camera feature to identify a plant instantly",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),
                  ],
                ),
              ),
              // Scanning Effect
              Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/plant-bg.png', // Background image where the line will scan
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Scanning line animation
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return SlideTransition(
                        position: _scanAnimation,
                        child: Container(
                          width: double.infinity,
                          height: 2, // Scanning line thickness
                          color: Colors.white.withOpacity(0.8), // Scanning line color
                        ),
                      );
                    },
                  ),
                ],
              ),
              // Capture Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CameraScreen()));
                  },
                  child: const Text(
                    "Take a picture!",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const MyPlantsPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(position: offsetAnimation, child: child);
                },
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const ExplorePage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(position: offsetAnimation, child: child);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
