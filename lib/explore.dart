import 'package:flutter/material.dart';
import 'myplants.dart';
import 'camera.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF7FBEA), // Light greenish background color
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Profile and Settings Icons
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.person,
                      size: 30, color: Color(0xFF376F47)),
                  onPressed: () {
                    // Navigate to Profile Page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfilePage()));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings,
                      size: 30, color: Color(0xFF376F47)),
                  onPressed: () {
                    // Navigate to Settings Page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage()));
                  },
                ),
              ],
            ),
          ),
          // Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Explore",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF376F47),
              ),
            ),
          ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF376F47)),
                filled: true,
                fillColor: const Color(0xFFEAF3DF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Articles List
          Expanded(
            child: ListView(
              children: [
                buildArticleCard(
                  context,
                  "The Mystery of Sunflowers",
                  "assets/sunflowers.jpg",
                  () {
                    // Navigate to Sunflowers Article Page
                  },
                ),
                buildArticleCard(
                  context,
                  "Tips on Flower Arrangements",
                  "assets/flowers.jpg",
                  () {
                    // Navigate to Flower Arrangements Article Page
                  },
                ),
                buildArticleCard(
                  context,
                  "How to Care for Succulents",
                  "assets/succulents.jpg",
                  () {
                    // Navigate to Succulents Article Page
                  },
                ),
              ],
            ),
          ),
          // Bottom Navigation Bar
          NavBar(
            currentIndex: 2, // Explore Page
            onTap: (index) {
              if (index == 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyPlants()),
                );
              } else if (index == 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PlantScannerPage()),
                );
              } else if (index == 2) {
                // Stay on Explore Page
              }
            },
          ),
        ],
      ),
    );
  }

  // Article Card Widget
  Widget buildArticleCard(BuildContext context, String title, String imagePath,
      VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 2,
        child: Column(
          children: [
            // Article Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(imagePath,
                  height: 150, width: double.infinity, fit: BoxFit.cover),
            ),
            // Article Details
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Article Title
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF376F47),
                      ),
                    ),
                  ),
                  // Read Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBFE7A7), // Light green
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: onPressed,
                    child: const Text("Read"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy Pages for Navigation
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Profile"), backgroundColor: Colors.green),
      body: const Center(child: Text("Profile Page")),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Settings"), backgroundColor: Colors.green),
      body: const Center(child: Text("Settings Page")),
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
