import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Plant {
  String plantName;
  String imagePath;
  double probability;
  bool waterNeeded;
  bool sunlightNeeded;
  bool isFavorite;
  String description;
  List<String> commonNames;
  List<String> synonyms;
  List<String> tasks;
  List<bool> taskStatus;

  Plant({
    required this.plantName,
    required this.imagePath,
    required this.probability,
    required this.waterNeeded,
    required this.sunlightNeeded,
    required this.isFavorite,
    required this.description,
    required this.commonNames,
    required this.synonyms,
    required this.tasks,
    required this.taskStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'plantName': plantName,
      'imagePath': imagePath,
      'probability': probability,
      'waterNeeded': waterNeeded,
      'sunlightNeeded': sunlightNeeded,
      'isFavorite': isFavorite,
      'description': description,
      'commonNames': commonNames,
      'synonyms': synonyms,
      'tasks': tasks,
      'taskStatus': taskStatus,
    };
  }

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      plantName: json['plantName'],
      imagePath: json['imagePath'],
      probability: json['probability'],
      waterNeeded: json['waterNeeded'],
      sunlightNeeded: json['sunlightNeeded'],
      isFavorite: json['isFavorite'],
      description: json['description'],
      commonNames: List<String>.from(json['commonNames']),
      synonyms: List<String>.from(json['synonyms']),
      tasks: List<String>.from(json['tasks']),
      taskStatus: List<bool>.from(json['taskStatus']),
    );
  }
}

class PlantDetailPage extends StatefulWidget {
  final Plant plant;

  const PlantDetailPage({super.key, required this.plant});

  @override
  _PlantDetailPageState createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage> {
  @override
  Widget build(BuildContext context) {
    final plant = widget.plant;

    return Scaffold(
      appBar: AppBar(
        title: Text(plant.plantName),
        actions: [
          IconButton(
            icon: Icon(
              plant.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () {
              setState(() {
                plant.isFavorite = !plant.isFavorite;
              });
              _updatePlantData(plant);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Plant Image
            Image(
              image: plant.imagePath.startsWith('/')
                  ? FileImage(File(plant.imagePath))
                  : plant.imagePath.startsWith('assets')
                  ? AssetImage(plant.imagePath) as ImageProvider
                  : NetworkImage(plant.imagePath) as ImageProvider,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                    Text("Image not available"),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            // Plant Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailSection("Common Names", plant.commonNames.join(', ')),
                  _buildDetailSection("Synonyms", plant.synonyms.join(', ')),
                  const SizedBox(height: 16),
                  const Text(
                    "Tasks",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildTaskList(plant),
                ],
              ),
            ),

            // Update Plant Photo Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () => _showImageSourceOptions(context, plant),
                child: const Text(
                  "Update Plant Photo",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Method to Build Detail Section
  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title:",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
      ],
    );
  }

  // Helper Method to Build Task List
  Widget _buildTaskList(Plant plant) {
    return Column(
      children: List.generate(plant.tasks.length, (index) {
        return CheckboxListTile(
          title: Text(plant.tasks[index]),
          value: plant.taskStatus[index],
          onChanged: (bool? value) {
            setState(() {
              plant.taskStatus[index] = value ?? false;
            });
            _updatePlantData(plant);
          },
        );
      }),
    );
  }

  // Show Image Source Options
  Future<void> _showImageSourceOptions(BuildContext context, Plant plant) async {
    final ImagePicker picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () async {
              final XFile? image = await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                setState(() {
                  plant.imagePath = image.path;
                });
                _updatePlantData(plant);
              }
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera),
            title: const Text('Camera'),
            onTap: () async {
              final XFile? image = await picker.pickImage(source: ImageSource.camera);
              if (image != null) {
                setState(() {
                  plant.imagePath = image.path;
                });
                _updatePlantData(plant);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // Mock Method to Update Plant Data in Database
  void _updatePlantData(Plant plant) {
    // Implement this function to save updated data in your database.
    // For now, this is a placeholder.
    print('Plant data updated: ${plant.toJson()}');
  }
}
