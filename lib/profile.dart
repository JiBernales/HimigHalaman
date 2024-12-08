import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the current theme mode to adjust colors
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Dynamically get background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Back Button
              Align(
                alignment: Alignment.topLeft,
                child: CircleAvatar(
                  backgroundColor: theme.cardColor, // Dynamic background color for avatar
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous screen
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Profile Picture
              CircleAvatar(
                radius: 50,
                backgroundColor: theme.cardColor, // Dynamic background color for avatar
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: theme.iconTheme.color, // Dynamic color for icon
                ),
              ),
              const SizedBox(height: 20),
              // Username
              Text(
                "UserName",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color, // Dynamic text color
                ),
              ),
              const SizedBox(height: 20),
              // Buttons List
              Expanded(
                child: ListView(
                  children: [
                    ProfileButton(
                      icon: Icons.alternate_email,
                      label: "User Name",
                      onPressed: () {},
                    ),
                    ProfileButton(
                      icon: Icons.email,
                      label: "Email",
                      onPressed: () {},
                    ),
                    ProfileButton(
                      icon: Icons.logout,
                      label: "Log Out",
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      iconColor: Colors.red.withOpacity(1), // Darker color for log out
                      textColor: Colors.red.withOpacity(1), // Darker color for text
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
          backgroundColor: theme.cardColor, // Dynamic background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? theme.iconTheme.color), // Dynamic icon color
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor ?? theme.textTheme.bodyMedium?.color, // Dynamic text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
