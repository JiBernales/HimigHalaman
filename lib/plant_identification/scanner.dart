import 'package:flutter/material.dart';
import 'package:himig_halaman/plant_identification/results.dart';
import 'package:image_picker/image_picker.dart'; // Add this package for image picking
import 'dart:io';
import 'dart:convert';
import 'camera.dart';
import '../explore.dart';
import '../myplants.dart';
import '../navbar.dart';
import '../profile.dart';
import '../settings/settings.dart';
import 'api_integration.dart';

class PlantScannerPage extends StatefulWidget {
  const PlantScannerPage({super.key});

  @override
  _PlantScannerPageState createState() => _PlantScannerPageState();
}

class _PlantScannerPageState extends State<PlantScannerPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _scanAnimation;
  File? _imageFile; // To store the selected image

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )
      ..repeat(reverse: true);

    _scanAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 1))
            .animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Convert the image to Base64
      final base64Image = base64Encode(_imageFile!.readAsBytesSync());

      // Call the API with the Base64 image
      final apiIntegration = APIIntegration();
      final plant = await apiIntegration.identifyPlant(base64Image);

      if (plant != null) {
        // Pass the plant data to the ResultsPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsPage(scannedImageUrl: base64Image),
          ),
        );
      } else {
        print('Failed to identify plant.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header Row
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.person, size: 40, color: Theme
                        .of(context)
                        .iconTheme
                        .color),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const ProfilePage()));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.settings, size: 40, color: Theme
                        .of(context)
                        .iconTheme
                        .color),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const SettingsPage()));
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Plant Scanning Section
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/plant-bg.png',
                  height: 200,
                  fit: BoxFit.cover,
                ),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return SlideTransition(
                      position: _scanAnimation,
                      child: Container(
                        width: 200,
                        height: 75,
                        color: Theme
                            .of(context)
                            .brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.8)
                            : Colors.green.withOpacity(0.8),
                      ),
                    );
                  },
                ),
              ],
            ),
            const Spacer(),
            Text(
              "Use the camera feature to identify \n a plant instantly",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge
                    ?.color,
              ),
            ),
            const Spacer(),
            // Take Picture Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme
                    .of(context)
                    .brightness == Brightness.dark
                    ? Colors.greenAccent
                    : Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const CameraScreen()));
              },
              child: const Text(
                  "Take a picture!", style: TextStyle(fontSize: 18)),
            ),
            // Upload Image Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme
                    .of(context)
                    .brightness == Brightness.dark
                    ? Colors.greenAccent
                    : Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: _pickImage,
              child: const Text(
                  "Upload an image", style: TextStyle(fontSize: 18)),
            ),
            const Spacer(),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation,
                    secondaryAnimation) => const MyPlantsPage(),
                transitionsBuilder: (context, animation, secondaryAnimation,
                    child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  final tween = Tween(begin: begin, end: end).chain(
                      CurveTween(curve: curve));
                  return SlideTransition(
                      position: animation.drive(tween), child: child);
                },
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation,
                    secondaryAnimation) => const ExplorePage(),
                transitionsBuilder: (context, animation, secondaryAnimation,
                    child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  final tween = Tween(begin: begin, end: end).chain(
                      CurveTween(curve: curve));
                  return SlideTransition(
                      position: animation.drive(tween), child: child);
                },
              ),
            );
          }
        },
      ),
    );
  }
}