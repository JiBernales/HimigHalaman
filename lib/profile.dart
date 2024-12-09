import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  String? profileImageBase64; // To store the base64 string of the profile image
  String? username; // Store the username
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  /// Load the user's profile data from Firestore
  Future<void> _loadProfileData() async {
    if (user != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(
          user!.uid);
      final docSnapshot = await userDoc.get();
      if (docSnapshot.exists) {
        setState(() {
          username = docSnapshot.data()?['username'];
          profileImageBase64 = docSnapshot.data()?['profilePicture'];
        });
      }
    }
  }

  /// Convert the image to a base64 string
  Future<String> _convertImageToBase64(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return base64Encode(bytes);
  }

  /// Compress the image to reduce file size before uploading
  Future<File> _compressImage(File file) async {
    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 500,
      minHeight: 500,
      quality: 88,
    );

    // Check if compression was successful
    if (result == null) {
      throw Exception("Image compression failed");
    }

    final compressedFile = File(file.absolute.path)
      ..writeAsBytesSync(result);
    return compressedFile;
  }

  /// Pick an image and upload it as base64 to Firestore
  Future<void> _pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final file = File(image.path);
    final fileSize = await file.length();

    if (fileSize > 5 * 1024 * 1024) {
      _showErrorDialog(
          "Image size exceeds 5MB. Please select a smaller image.");
      return;
    }

    // Check if the file extension is valid
    final extension = image.path
        .split('.')
        .last
        .toLowerCase();
    if (!['jpg', 'jpeg', 'png'].contains(extension)) {
      _showErrorDialog("Only JPG, JPEG, and PNG files are allowed.");
      return;
    }

    try {
      // Compress the image before uploading
      final compressedImage = await _compressImage(file);
      await _uploadImageAndUpdate(compressedImage);
    } catch (e) {
      print('Upload failed: $e');
      _showErrorDialog("Failed to upload image. Please try again.");
    }
  }

  /// Upload image and store the base64 in Firestore
  Future<void> _uploadImageAndUpdate(File file) async {
    // Show loading indicator while the image is being uploaded
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Convert the image to base64 string
      final base64String = await _convertImageToBase64(file);

      // Get reference to the user's document in Firestore
      final userDoc = FirebaseFirestore.instance.collection('users').doc(
          user?.uid);

      // Update the profile picture field in Firestore with the base64 string
      await userDoc.update({'profilePicture': base64String});

      // Update the profile image in the app
      setState(() {
        profileImageBase64 = base64String;
      });
    } catch (e) {
      print('Upload failed: $e');
      _showErrorDialog("Failed to upload image. Please try again.");
    } finally {
      // Dismiss the loading dialog
      Navigator.pop(context);
    }
  }

  /// Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  /// Convert the base64 string to an image widget
  Widget _buildProfileImage() {
    if (profileImageBase64 != null) {
      try {
        final decodedBytes = base64Decode(profileImageBase64!);
        return Image.memory(
          decodedBytes,
          fit: BoxFit.cover,
          width: 100,
          height: 100,
        );
      } catch (e) {
        print('Error decoding base64: $e');
        return const Icon(Icons.error, size: 100);
      }
    } else {
      return const Icon(Icons.person, size: 100);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (username == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: CircleAvatar(
                  backgroundColor: Theme
                      .of(context)
                      .cardColor,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Theme
                        .of(context)
                        .iconTheme
                        .color),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme
                        .of(context)
                        .cardColor,
                    child: _buildProfileImage(), // Use base64 image here
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Theme
                          .of(context)
                          .primaryColor,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: _pickAndUploadImage,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                username ?? 'User Name',
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge
                    ?.color),
              ),
              const SizedBox(height: 10),
              Text(
                user?.email ?? 'Email not available',
                style: TextStyle(fontSize: 16, color: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium
                    ?.color),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    ProfileButton(
                      icon: Icons.edit,
                      label: "Edit Profile",
                      onPressed: _editProfile,
                    ),
                    ProfileButton(
                      icon: Icons.logout,
                      label: "Log Out",
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      iconColor: Colors.red,
                      textColor: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editProfile() async {
    final usernameController = TextEditingController(text: username);
    final emailController = TextEditingController(text: user?.email);

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text("Edit Profile"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: "Username"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (usernameController.text.isEmpty || emailController.text.isEmpty) {
                    _showErrorDialog("Username and Email cannot be empty.");
                    return;
                  }

                  try {
                    // Update username in Firestore
                    if (usernameController.text.isNotEmpty) {
                      final userDoc = FirebaseFirestore.instance.collection('users').doc(user?.uid);
                      await userDoc.update({'username': usernameController.text});
                    }

                    // Update email if provided
                    if (emailController.text.isNotEmpty) {
                      await user?.verifyBeforeUpdateEmail(emailController.text);
                    }

                    // Reload the user to get the updated information
                    await user?.reload();

                    // Fetch and update the username from Firestore again
                    await _loadProfileData(); // Ensure that the profile is refreshed

                    // Explicitly set the new username in the state to reflect it
                    setState(() {
                      username = usernameController.text;
                    });

                    // Close the dialog
                    Navigator.pop(context);
                  } catch (e) {
                    print('Error while updating profile: $e');
                    _showErrorDialog("Failed to update profile. Please try again.");
                  }
                },
                child: const Text("Save"),
              ),

            ],
          ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? iconColor;
  final Color? textColor;

  const ProfileButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? theme.iconTheme.color),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor ?? theme.textTheme.bodyMedium?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
