import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:himig_halaman/plant.dart';
import 'package:himig_halaman/plant_identification/scanner.dart';
import 'package:himig_halaman/profile.dart';
import 'package:himig_halaman/settings/settings.dart';
import 'dart:io'; // For FileImage
import 'package:image_picker/image_picker.dart';

import 'explore.dart';
import 'navbar.dart'; // For image picker

class MyPlantsPage extends StatefulWidget {
  final List<Plant> initialPlants;

  const MyPlantsPage({
    super.key,
    this.initialPlants = const [],
  });

  @override
  _MyPlantsPageState createState() => _MyPlantsPageState();
}

class _MyPlantsPageState extends State<MyPlantsPage> {
  late List<Plant> _plants;
  bool _isLoading = true;
  String _loadingMessage = "Fetching your garden...";

  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      fetchUserGarden(userId);
    }
  }

  Future<void> fetchUserGarden(String userId) async {
    try {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
      final snapshot = await userDoc.get();

      if (snapshot.exists && snapshot.data() != null) {
        final gardenData = snapshot.data()!['garden'] as List<dynamic>? ?? [];
        setState(() {
          _plants = gardenData.map((data) => Plant.fromJson(data)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _loadingMessage = "Your garden is empty!";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _loadingMessage = "Error fetching garden: $e";
        _isLoading = false;
      });
    }
  }

  // Update plant list when image is changed
  void updatePlantImage(int index, String newImagePath) {
    setState(() {
      _plants[index].imagePath = newImagePath;
    });
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      saveGardenToFirestore(userId);
    }
  }

  Future<void> saveGardenToFirestore(String userId) async {
    final gardenData = _plants.map((plant) => plant.toJson()).toList();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'garden': gardenData});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              _loadingMessage,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : SafeArea(
        child: Column(
          children: [
            const HeaderSection(),
            Expanded(
              child: ListView.builder(
                itemCount: _plants.length,
                itemBuilder: (context, index) {
                  final plant = _plants[index];
                  return PlantCard(
                    plant: plant,
                    onFavoriteToggle: () => toggleFavorite(plant),
                    onWaterToggle: () => toggleWaterNeeded(plant),
                    onSunlightToggle: () => toggleSunlightNeeded(plant),
                    onImageUpdated: (newImagePath) {
                      updatePlantImage(index, newImagePath);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PlantScannerPage()),
            );
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

  // Toggle water needed, sunlight needed, and favorite status
  void toggleWaterNeeded(Plant plant) {
    setState(() {
      plant.waterNeeded = !plant.waterNeeded;
    });
    _updateFirestore();
  }

  void toggleSunlightNeeded(Plant plant) {
    setState(() {
      plant.sunlightNeeded = !plant.sunlightNeeded;
    });
    _updateFirestore();
  }

  void toggleFavorite(Plant plant) {
    setState(() {
      plant.isFavorite = !plant.isFavorite;
    });
    _updateFirestore();
  }

  // Helper function to update Firestore data
  void _updateFirestore() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      saveGardenToFirestore(userId);
    }
  }
}

// Header Section Widget
class HeaderSection extends StatelessWidget {
  const HeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.person, size: 40, color: theme.iconTheme.color),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.settings, size: 40, color: theme.iconTheme.color),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                },
              ),
            ],
          ),
          const Text(
            "My Garden",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// PlantCard Widget
class PlantCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onWaterToggle;
  final VoidCallback onSunlightToggle;
  final Function(String) onImageUpdated;  // Callback for image update

  const PlantCard({
    super.key,
    required this.plant,
    required this.onFavoriteToggle,
    required this.onWaterToggle,
    required this.onSunlightToggle,
    required this.onImageUpdated,  // Initialize the callback
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlantDetailPage(plant: plant)),
        ).then((_) {
          // After returning from PlantDetailPage, refresh the image if it was updated
          onImageUpdated(plant.imagePath);  // Notify the parent
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: plant.imagePath.isNotEmpty
                  ? plant.imagePath.startsWith('http')  // Check if it's a network image
                  ? Image.network(
                plant.imagePath,
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              )
                  : Image.file(
                File(plant.imagePath),
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                'assets/placeholder.png',
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded( // Wrapping the text in Expanded to avoid overflow
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.plantName,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          plant.waterNeeded
                              ? Icons.water_drop
                              : Icons.water_drop_outlined,
                          color: Colors.blue,
                        ),
                        onPressed: onWaterToggle,
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          plant.sunlightNeeded
                              ? Icons.wb_sunny
                              : Icons.wb_sunny_outlined,
                          color: Colors.orange,
                        ),
                        onPressed: onSunlightToggle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                plant.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: plant.isFavorite ? Colors.red : theme.iconTheme.color,
              ),
              onPressed: onFavoriteToggle,
            ),
          ],
        ),
      ),
    );
  }
}
