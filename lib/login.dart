import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  Future<void> _authenticateUser(BuildContext context, bool isLogin) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog(context, "Please fill in all fields.");
      return;
    }

    try {
      UserCredential userCredential;
      if (isLogin) {
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Save additional user info to Firestore for new users
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': 'Anonymous', // You can allow users to set this later
          'email': email,
          'profilePicture': '', // Placeholder for now
          'garden': [], // Initialize an empty garden
        });
      }

      _redirectToMyPlants(context);
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(context, e.message ?? "Authentication failed.");
    }
  }


  Future<void> _guestLogin(BuildContext context) async {
    await FirebaseAuth.instance.signInAnonymously();
    _redirectToMyPlants(context);
  }

  void _redirectToMyPlants(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/myplants');
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade300,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green.shade700,
                child: const Icon(
                  Icons.eco,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              _buildTextField("Email", emailController),
              const SizedBox(height: 16),
              _buildTextField("Password", passwordController, isPassword: true),
              const SizedBox(height: 16),
              _buildActionButton(
                context,
                label: "Login",
                onPressed: () => _authenticateUser(context, true),
              ),
              const SizedBox(height: 8),
              const Text("or"),
              const SizedBox(height: 8),
              _buildActionButton(
                context,
                label: "Register",
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextButton(
                context,
                label: "Skip for Later",
                color: Colors.yellow.shade300,
                textColor: Colors.black,
                onPressed: () => _guestLogin(context),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  // TODO: Link to Terms and Services
                },
                child: const Text(
                  "Terms and Services",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(label),
    );
  }

  Widget _buildTextButton(BuildContext context,
      {required String label,
        required VoidCallback onPressed,
        required Color color,
        required Color textColor}) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(label, style: TextStyle(color: textColor)),
    );
  }
}

class RegistrationScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RegistrationScreen({super.key});

  Future<void> _authenticateUser(BuildContext context, bool isLogin) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog(context, "Please fill in all fields.");
      return;
    }

    try {
      UserCredential userCredential;
      if (isLogin) {
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Save additional user info to Firestore for new users
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'username': '', // Placeholder
          'email': email,
          'profilePicture': '', // Placeholder
          'garden': [], // Initialize empty garden
        });
      }

      _redirectToMyPlants(context);
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(context, e.message ?? "Authentication failed.");
    }
  }

  void _redirectToMyPlants(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/myplants');
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade300,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green.shade700,
                child: const Icon(
                  Icons.eco,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              _buildTextField("Email", emailController),
              const SizedBox(height: 16),
              _buildTextField("Password", passwordController, isPassword: true),
              const SizedBox(height: 16),
              _buildActionButton(
                context,
                label: "Register",
                onPressed: () => _authenticateUser(context, false),
              ),
              const SizedBox(height: 8),
              const Text("or"),
              const SizedBox(height: 8),
              _buildActionButton(
                context,
                label: "Login",
                onPressed: () => Navigator.pop(context), // Navigate back to Login
              ),
              const SizedBox(height: 16),
              _buildTextButton(
                context,
                label: "Skip for Later",
                color: Colors.yellow.shade300,
                textColor: Colors.black,
                onPressed: () => _guestLogin(context),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  // TODO: Link to Terms and Services
                },
                child: const Text(
                  "Terms and Services",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(label),
    );
  }

  Widget _buildTextButton(BuildContext context,
      {required String label,
        required VoidCallback onPressed,
        required Color color,
        required Color textColor}) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(label, style: TextStyle(color: textColor)),
    );
  }

  Future<void> _guestLogin(BuildContext context) async {
    await FirebaseAuth.instance.signInAnonymously();
    _redirectToMyPlants(context);
  }
}
