import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade300,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Phone Number or Email",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // TODO: Add registration functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Register"),
              ),
              const SizedBox(height: 8),
              const Text("or"),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Add Google Sign-In functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                icon: const Icon(Icons.g_mobiledata, color: Colors.white),
                label: const Text("Continue with Google"),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // TODO: Add skip functionality
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.yellow.shade300,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Skip for Later",
                  style: TextStyle(color: Colors.black),
                ),
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
            ],
          ),
        ),
      ),
    );
  }
}
