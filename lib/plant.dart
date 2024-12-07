import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Plant {
  final String plantName;
  final double probability;
  String imagePath;
  bool waterNeeded;
  bool sunlightNeeded;
  bool isFavorite;
  final String description;
  final List<String> commonNames;
  final List<String> synonyms;
  final List<String> tasks;
  final List<bool> taskStatus;

  Plant({
    required this.plantName,
    required this.probability,
    required this.imagePath,
    required this.waterNeeded,
    required this.sunlightNeeded,
    required this.isFavorite,
    required this.description,
    required this.commonNames,
    required this.synonyms,
    required this.tasks,
    required this.taskStatus,
  });
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
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Plant image handling
            Image(
              image: plant.imagePath.startsWith('/')
                  ? FileImage(File(plant.imagePath)) // Local image
                  : plant.imagePath.startsWith('assets')
                  ? AssetImage(plant.imagePath) as ImageProvider // Asset image
                  : NetworkImage(plant.imagePath) as ImageProvider, // Network image (if URL)
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported, size: 100);
              },
            ),
            const SizedBox(height: 16),
            // Task list
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "To Do",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(plant.tasks.length, (index) {
                    return CheckboxListTile(
                      title: Text(plant.tasks[index]),
                      value: plant.taskStatus[index],
                      onChanged: (bool? value) {
                        setState(() {
                          plant.taskStatus[index] = value ?? false;
                        });
                      },
                    );
                  }),
                ],
              ),
            ),
            // Update plant photo button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? pickedImage = await picker.pickImage(
                    source: ImageSource.gallery, // Can also use ImageSource.camera
                  );

                  if (pickedImage != null) {
                    setState(() {
                      plant.imagePath = pickedImage.path; // Update the image path
                    });
                  } else {
                    // Handle when no image is selected
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No image selected.')),
                    );
                  }
                },
                child: const Text(
                  "Update plant photo",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
