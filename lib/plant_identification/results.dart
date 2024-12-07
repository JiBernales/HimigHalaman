
import 'package:flutter/material.dart';
import 'package:himig_halaman/myplants.dart';
import 'package:himig_halaman/plant.dart';

class ResultsPage extends StatelessWidget {
  final String plantName;
  final String imagePath;
  final List<Diagnosis> diagnosisDetails;

  const ResultsPage({
    super.key,
    required this.plantName,
    required this.imagePath,
    required this.diagnosisDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBEA), // Light background color
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                backgroundColor: const Color(0xFFEAF3DF), // Soft green
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF376F47)),
                  onPressed: () {
                    Navigator.pop(context); // Navigate back
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Title
            const Center(
              child: Text(
                "Results",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF376F47), // Dark green
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Plant Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath, // Dynamic image path
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Plant Name
            Center(
              child: Column(
                children: [
                  const Text(
                    "Your plant is",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF376F47),
                    ),
                  ),
                  Text(
                    plantName, // Dynamic plant name
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF376F47),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Diagnosis Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Diagnosis",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF376F47),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...diagnosisDetails.map((diagnosis) => DiagnosisCard(
                    icon: diagnosis.icon,
                    title: diagnosis.title,
                    description: diagnosis.description,
                  )),
                ],
              ),
            ),
            const Spacer(),
            // Add to My Garden Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final newPlant = Plant(
                      plantName: plantName,
                      imagePath: imagePath,
                      probability: 95.0, // Example probability, adjust as needed
                      waterNeeded: true,
                      sunlightNeeded: true,
                      isFavorite: false,
                      tasks: ["Water regularly", "Provide indirect sunlight"],
                      taskStatus: [false, false],
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyPlantsPage(
                          initialPlants: [newPlant],
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF376F47), // Dark green
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Add to My Garden",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiagnosisCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const DiagnosisCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3DF), // Light green
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 30,
            color: const Color(0xFF376F47), // Dark green
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF376F47),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF376F47),
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

// Model for Diagnosis
class Diagnosis {
  final IconData icon;
  final String title;
  final String description;

  Diagnosis({
    required this.icon,
    required this.title,
    required this.description,
  });
}
