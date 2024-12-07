import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'api_integration.dart';
import '../plant.dart';
import 'dart:convert';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  CameraController? cameraController;
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    try {
      final cameras = await availableCameras();
      // Use the back camera if available
      final backCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      cameraController = CameraController(
        backCamera,
        ResolutionPreset.medium,
      );
      await cameraController?.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print("Camera initialization failed: $e");
      _showErrorDialog("Failed to initialize the camera. Ensure permissions are granted.");
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  Future<void> captureAndIdentifyPlant() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      try {
        setState(() {
          isScanning = true;
        });

        final image = await cameraController!.takePicture();
        final imageBytes = await image.readAsBytes();
        final base64Image = base64Encode(imageBytes);

        final apiIntegration = APIIntegration();
        final plants = await apiIntegration.identifyPlant(base64Image);

        setState(() {
          isScanning = false;
        });

        if (plants != null && plants.isNotEmpty && mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlantDetailPage(plant: plants.first),
            ),
          );

        } else {
          _showErrorDialog("Plant not identified. Please try again.");
        }
      } catch (e) {
        setState(() {
          isScanning = false;
        });
        _showErrorDialog("Error capturing or identifying plant: $e");
      }
    }
  }

  List<String> _generateTasks(Plant plant) {
    // Example task generation logic
    return [
      "Water every ${plant.waterNeeded ? 'day' : 'other day'}",
      "Place in ${plant.sunlightNeeded ? 'direct sunlight' : 'indirect sunlight'}",
      "Monitor for pests weekly",
    ];
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: cameraController != null && cameraController!.value.isInitialized
          ? Stack(
        children: [
          CameraPreview(cameraController!),
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
          if (isScanning)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.all(20),
                ),
                onPressed: isScanning ? null : captureAndIdentifyPlant,
                child: Icon(
                  isScanning ? Icons.hourglass_empty : Icons.camera,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}