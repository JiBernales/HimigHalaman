import 'package:flutter/material.dart';
import 'explore.dart';
import 'camera.dart';

void main() {
  runApp(const MyPlantsPage());
}

class MyPlantsPage extends StatelessWidget {
  const MyPlantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.green),
      home: MyPlants(), // Corrected to reference MyPlants
    );
  }
}

class MyPlants extends StatelessWidget {
  final List<Plant> plants = [
    Plant(
      name: "Spider Plant",
      imageUrl: "https://via.placeholder.com/150",
      isFavorite: true,
      waterNeeded: true,
      sunlightNeeded: true,
    ),
    Plant(
      name: "Fiona",
      imageUrl: "https://via.placeholder.com/150",
      isFavorite: false,
      waterNeeded: true,
      sunlightNeeded: false,
    ),
    Plant(
      name: "Plant Name#1",
      imageUrl: "https://via.placeholder.com/150",
      isFavorite: false,
      waterNeeded: false,
      sunlightNeeded: true,
    ),
  ];

   MyPlants({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade100,
        elevation: 0,
        leading: const Icon(Icons.person, color: Colors.green),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.green),
            onPressed: () {},
          ),
        ],
        title: const Text(
          "My Garden",
          style: TextStyle(color: Colors.green),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search",
                filled: true,
                fillColor: Colors.green.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: plants.length,
              itemBuilder: (context, index) {
                final plant = plants[index];
                return PlantCard(plant: plant);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 0, // Explore Page
        onTap: (index) {
          if (index == 0) {
          } else if (index == 1) {
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

class Plant {
  final String name;
  final String imageUrl;
  final bool isFavorite;
  final bool waterNeeded;
  final bool sunlightNeeded;

  Plant({
    required this.name,
    required this.imageUrl,
    required this.isFavorite,
    required this.waterNeeded,
    required this.sunlightNeeded,
  });
}

class PlantCard extends StatelessWidget {
  final Plant plant;

  const PlantCard({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            plant.imageUrl,
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(plant.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                plant.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: plant.isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                // Handle favorite toggle
              },
            ),
            Icon(
              plant.waterNeeded ? Icons.opacity : Icons.opacity_outlined,
              color: Colors.blue,
            ),
            const SizedBox(width: 8),
            Icon(
              plant.sunlightNeeded ? Icons.wb_sunny : Icons.wb_sunny_outlined,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}

// Define the NavBar widget
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
