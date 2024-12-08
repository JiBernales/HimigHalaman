
import 'package:flutter/material.dart';
import 'plant.dart';
import 'navbar.dart';
import 'plant_identification/scanner.dart';
import 'profile.dart';
import 'settings/settings.dart';
import 'explore.dart';

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

  @override
  void initState() {
    super.initState();
    _plants = List.from(widget.initialPlants)..addAll(plants);
  }

  void addPlant(Plant plant) {
    setState(() {
      _plants.add(plant);
    });
  }

  void toggleWaterNeeded(Plant plant) {
    setState(() {
      plant.waterNeeded = !plant.waterNeeded;
    });
  }

  void toggleSunlightNeeded(Plant plant) {
    setState(() {
      plant.sunlightNeeded = !plant.sunlightNeeded;
    });
  }

  void toggleFavorite(Plant plant) {
    setState(() {
      plant.isFavorite = !plant.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            HeaderSection(),
            // Plant List
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
          // Profile and Settings Row
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
          // Title
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

  const PlantCard({
    super.key,
    required this.plant,
    required this.onFavoriteToggle,
    required this.onWaterToggle,
    required this.onSunlightToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlantDetailPage(plant: plant)),
        );
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
              child: Image.asset(
                plant.imagePath,
                height: 70,
                width: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.image_not_supported,
                  size: 70,
                  color: theme.iconTheme.color,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
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
// Example Plant Data
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
    description: '',
    commonNames: [],
    synonyms: [],
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
    description: '',
    commonNames: [],
    synonyms: [],
  ),
];
