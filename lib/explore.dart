import 'package:flutter/material.dart';
import 'myplants.dart';
import 'plant_identification/scanner.dart';
import 'profile.dart';
import 'settings/settings.dart';
import 'navbar.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Dynamic background color
      body: SafeArea(
        child: SingleChildScrollView(  // Make the entire screen scrollable
          child: Column(
            mainAxisSize: MainAxisSize.min,  // Ensure the column takes only the required space
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
                          icon: Icon(
                            Icons.person,
                            size: 40,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProfilePage()),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.settings,
                            size: 40,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SettingsPage()),
                            );
                          },
                        ),
                      ],
                    ),
                    // Title
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Explore",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          prefixIcon: Icon(
                            Icons.search,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Articles List
              Column( // Use Column here instead of ListView
                children: [
                  buildArticleCard(
                    context,
                    "The Mystery of Sunflowers",
                    "assets/sunflower.png",
                        () {
                      // Navigate to Sunflowers Article Page
                    },
                  ),
                  buildArticleCard(
                    context,
                    "Tips on Flower Arrangements",
                    "assets/tips.png",
                        () {
                      // Navigate to Flower Arrangements Article Page
                    },
                  ),
                  buildArticleCard(
                    context,
                    "How to Care for Succulents",
                    "assets/flowers.png",
                        () {
                      // Navigate to Succulents Article Page
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: NavBar(
        currentIndex: 2, // Explore Page
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                const MyPlantsPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(position: offsetAnimation, child: child);
                },
              ),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                const PlantScannerPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
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

  // Article Card Widget
  Widget buildArticleCard(BuildContext context, String title, String imagePath,
      VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 2,
        color: Theme.of(context).cardColor, // Card background based on theme
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color, // Dynamic text color
                      ),
                    ),
                  ),
                  // Read Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
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
