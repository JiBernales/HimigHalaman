import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:himig_halaman/myplants.dart';
import 'package:himig_halaman/plant.dart';
import 'api_integration.dart'; // For parsing the JSON response

class ResultsPage extends StatefulWidget {
  final String scannedImageUrl; // The base64 string of the scanned image

  const ResultsPage({super.key, required this.scannedImageUrl});

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  late String plantName = 'Loading...';
  late String imagePath = '';
  late String description = 'Fetching plant details...';
  late List<String> commonNames = [];
  late List<String> synonyms = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlantDetails(widget.scannedImageUrl);
  }

  // Fetching plant details using APIIntegration
  Future<void> _fetchPlantDetails(String base64Image) async {
    final apiIntegration = APIIntegration();
    final plant = await apiIntegration.identifyPlant(base64Image);

    if (plant != null) {
      setState(() {
        plantName = plant.plantName;
        imagePath = plant.imagePath;
        description = plant.description;
        commonNames = plant.commonNames;
        synonyms = plant.synonyms;
        isLoading = false;

      });
    } else {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Failed to fetch plant details');
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBEA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircleAvatar(
                  backgroundColor: const Color(0xFFEAF3DF),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF376F47)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Results",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF376F47),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? Center(child: CircularProgressIndicator(color: Color(0xFF376F47))) // Loading indicator
                  : Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imagePath.isNotEmpty && imagePath != 'assets/placeholder.png'
                      ? Image.network(
                    imagePath,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/placeholder.png',
                        height: 200,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                      : Image.asset(
                    'assets/placeholder.png',
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    const Text("Your plant is", style: TextStyle(fontSize: 18, color: Color(0xFF376F47))),
                    Text(
                      plantName,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF376F47)),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF376F47))),
                    const SizedBox(height: 10),
                    DiagnosisCard(icon: Icons.info, title: "Description", description: description),
                    DiagnosisCard(
                      icon: Icons.label,
                      title: "Common Names",
                      description: commonNames.isNotEmpty ? commonNames.join(", ") : "No common names available.",
                    ),
                    DiagnosisCard(
                      icon: Icons.alternate_email,
                      title: "Synonyms",
                      description: synonyms.isNotEmpty ? synonyms.join(", ") : "No synonyms available.",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final newPlant = Plant(
                        plantName: plantName,
                        imagePath: imagePath,
                        probability: 95.0,
                        waterNeeded: true,
                        sunlightNeeded: true,
                        isFavorite: false,
                        tasks: ["Water regularly", "Provide indirect sunlight"],
                        taskStatus: [false, false],
                        description: description,
                        commonNames: commonNames,
                        synonyms: synonyms,
                      );

                      // Save the plant to Firestore
                      final userId = FirebaseAuth.instance.currentUser?.uid;
                      if (userId != null) {
                        try {
                          final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

                          // Fetch existing garden data
                          final snapshot = await userDoc.get();
                          List<dynamic> gardenData = snapshot.data()?['garden'] ?? [];

                          // Add the new plant to the garden
                          gardenData.add(newPlant.toJson());

                          // Update Firestore
                          await userDoc.update({'garden': gardenData});

                          // Navigate to MyPlantsPage with updated garden
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyPlantsPage(initialPlants: gardenData.map((data) => Plant.fromJson(data)).toList()),
                            ),
                          );

                          _showSuccessDialog("Plant successfully added to your garden!");

                        } catch (e) {
                          _showErrorDialog("Error saving plant: $e");
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF376F47),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Add to My Garden",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class DiagnosisCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const DiagnosisCard({Key? key, required this.icon, required this.title, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF376F47)),
        title: Text(title, style: const TextStyle(fontSize: 16, color: Color(0xFF376F47))),
        subtitle: Text(description, style: const TextStyle(fontSize: 14, color: Color(0xFF376F47))),
      ),
    );
  }
}
