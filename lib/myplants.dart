import 'package:flutter/material.dart';
import 'package:himig_halaman/scanner.dart';
import 'plant.dart';
import 'navbar.dart';
import 'settings.dart';
import 'explore.dart';

class MyPlantsPage extends StatefulWidget {
  const MyPlantsPage({super.key});

  @override
  _MyPlantsPageState createState() => _MyPlantsPageState();
}

class _MyPlantsPageState extends State<MyPlantsPage> {
  // Method to toggle favorite status
  void toggleFavorite(Plant plant) {
    setState(() {
      plant.isFavorite = !plant.isFavorite;
    });
  }

  // Method to toggle water needed
  void toggleWaterNeeded(Plant plant) {
    setState(() {
      plant.waterNeeded = !plant.waterNeeded;
    });
  }

  // Method to toggle sunlight needed
  void toggleSunlightNeeded(Plant plant) {
    setState(() {
      plant.sunlightNeeded = !plant.sunlightNeeded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBEA), // Light green background
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FBEA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.person, size: 30, color: Color(0xFF376F47)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, size: 30, color: Color(0xFF376F47)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text(
                "My Garden",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF376F47),
                ),
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF376F47)),
                  filled: true,
                  fillColor: const Color(0xFFEAF3DF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Plants List
            Expanded(
              child: ListView.builder(
                itemCount: plants.length,
                itemBuilder: (context, index) {
                  final plant = plants[index];
                  return PlantCard(
                    plant: plant,
                    onFavoriteToggle: () => toggleFavorite(plant),
                    onWaterToggle: () => toggleWaterNeeded(plant),
                    onSunlightToggle: () => toggleSunlightNeeded(plant),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 0, // Explore Page
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                const PlantScannerPage(),
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
                pageBuilder: (context, animation, secondaryAnimation) =>
                const ExplorePage(),
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

class PlantCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onWaterToggle;
  final VoidCallback onSunlightToggle;

  const PlantCard({
    super.key,
    required this.plant,
    required this.onFavoriteToggle,
    required this.onWaterToggle,
    required this.onSunlightToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantDetailPage(plant: plant),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF3DF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Plant Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                plant.imagePath,
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            // Plant Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.plantName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF376F47),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          plant.waterNeeded
                              ? Icons.water_drop // Full (Water needed)
                              : Icons.water_drop_outlined, // Empty (No water needed)
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
            // Favorite Icon
            IconButton(
              icon: Icon(
                plant.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: plant.isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: onFavoriteToggle,
            ),
          ],
        ),
      ),
    );
  }
}

final List<Plant> plants = [
  Plant(
    plantName: "Spider Plant",
    imagePath: "assets/spider_plant.png",
    probability: 5.0,
    waterNeeded: true,
    sunlightNeeded: true,
    isFavorite: false,
    tasks: [
      "Water daily",
      "Place in indirect sunlight",
      "Check for pests weekly"
    ],
    taskStatus: [false, false, false],
  ),
  Plant(
    plantName: "Fiona",
    imagePath: "assets/fiona.png",
    probability: 80.0,
    waterNeeded: true,
    sunlightNeeded: false,
    isFavorite: false,
    tasks: [
      "Water every other day",
      "Place in shaded area",
      "Prune monthly"
    ],
    taskStatus: [false, false, false],
  ),
];
