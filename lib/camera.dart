import 'package:flutter/material.dart';
import 'explore.dart';
import 'myplants.dart';
import 'scanner.dart';

class PlantScannerPage extends StatelessWidget {
  const PlantScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[50],
      appBar: AppBar(
        title: const Text('Plant Scanner'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Placeholder for the scanner UI
          const Expanded(
            child: Center(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CameraScreen()),
                );
              },
              child: const Text(
                "Take a picture!",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 1, // Active page index
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyPlants()),
            );
          } else if (index == 1) {
            // Stay on the current page
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ExplorePage()),
            );
          }
        },
      ),
    );
  }
}

class NavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const NavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.eco), label: "Garden"),
        BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: "Capture"),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
      ],
    );
  }
}
