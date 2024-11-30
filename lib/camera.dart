import 'package:flutter/material.dart';
import 'explore.dart';
import 'myplants.dart';

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
                  Image(image: AssetImage('assets/Identify Plant.png'), height: 200), // Display first image as plant scanner UI
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
                print("Navigating to Camera Screen...");
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
              MaterialPageRoute(builder: (context) => const MyPlantsPage()),
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

// Camera Screen
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  CameraScreenState createState() {
    return CameraScreenState();
  }
}

class CameraScreenState extends State<CameraScreen> {
  bool isScanning = false;

  // Mock function to simulate fetching plant data
  Future<Map<String, String>> fetchPlantInfo() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    return {
      "name": "Spider Plant",
      "description":
      "A low-maintenance plant that improves air quality and thrives in indirect light.",
      "care": "Water bi-weekly and avoid direct sunlight."
    };
  }

  // Scanning action
  void scanPlant() async {
    setState(() {
      isScanning = true;
    });

    // Fetch data
    Map<String, String> plantInfo = await fetchPlantInfo();

    // Ensure the widget is still mounted before updating the state
    if (mounted) {
      setState(() {
        isScanning = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlantDetailsPage(plantInfo: plantInfo),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          // Camera Placeholder
          Center(
            child: Image.asset(
              'assets/Camera.png', // Use second image as camera placeholder
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          // Scanning Box
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          // Capture Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(), backgroundColor: Colors.green,
                  padding: const EdgeInsets.all(20),
                ),
                onPressed: isScanning ? null : scanPlant,
                child: Icon(
                  isScanning ? Icons.hourglass_empty : Icons.camera,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Results Page
class PlantDetailsPage extends StatelessWidget {
  final Map<String, String> plantInfo;

  const PlantDetailsPage({super.key, required this.plantInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plantInfo['name']!),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name: ${plantInfo['name']}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Description:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(plantInfo['description']!),
            const SizedBox(height: 10),
            const Text(
              "Care Instructions:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(plantInfo['care']!),
          ],
        ),
      ),
    );
  }
}
