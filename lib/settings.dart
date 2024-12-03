import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBEA), // Light greenish background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF376F47)),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF376F47),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          // General Section
          buildSectionTitle("General"),
          buildListTile(
            context,
            title: "Notifications",
            icon: Icons.notifications,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NotificationsPage()));
            },
          ),
          buildListTile(
            context,
            title: "Language",
            icon: Icons.language,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LanguagePage()));
            },
          ),
          buildListTile(
            context,
            title: "Location",
            icon: Icons.location_on,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LocationPage()));
            },
          ),

          // Personalization Section
          buildSectionTitle("Personalization"),
          buildListTile(
            context,
            title: "Font Size",
            icon: Icons.text_fields,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const FontSizePage()));
            },
          ),
          buildListTile(
            context,
            title: "Light/Dark Mode",
            icon: Icons.brightness_4,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ThemeModePage()));
            },
          ),

          // More Section
          buildSectionTitle("More"),
          buildListTile(
            context,
            title: "About Us",
            icon: Icons.info,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AboutUsPage()));
            },
          ),
          buildListTile(
            context,
            title: "Privacy Notice",
            icon: Icons.lock,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const PrivacyNoticePage()));
            },
          ),
          buildListTile(
            context,
            title: "Terms and Conditions",
            icon: Icons.description,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TermsAndConditionsPage()));
            },
          ),
        ],
      ),
    );
  }

  // Section Title Widget
  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF376F47),
        ),
      ),
    );
  }

  // ListTile Widget
  Widget buildListTile(
      BuildContext context, {
        required String title,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return Card(
      color: const Color(0xFFEAF3DF), // Light green tile color
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF376F47), size: 28),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF376F47),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF376F47), size: 18),
        onTap: onTap,
      ),
    );
  }
}

// Dummy Pages for Navigation
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications"), backgroundColor: Colors.green),
      body: const Center(child: Text("Notifications Page")),
    );
  }
}

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Language"), backgroundColor: Colors.green),
      body: const Center(child: Text("Language Page")),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), backgroundColor: Colors.green),
      body: const Center(child: Text("Profile Page")),
    );
  }
}

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location"), backgroundColor: Colors.green),
      body: const Center(child: Text("Location Page")),
    );
  }
}

class FontSizePage extends StatelessWidget {
  const FontSizePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Font Size"), backgroundColor: Colors.green),
      body: const Center(child: Text("Font Size Page")),
    );
  }
}

class ThemeModePage extends StatelessWidget {
  const ThemeModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Theme Mode"), backgroundColor: Colors.green),
      body: const Center(child: Text("Theme Mode Page")),
    );
  }
}

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About Us"), backgroundColor: Colors.green),
      body: const Center(child: Text("About Us Page")),
    );
  }
}

class PrivacyNoticePage extends StatelessWidget {
  const PrivacyNoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy Notice"), backgroundColor: Colors.green),
      body: const Center(child: Text("Privacy Notice Page")),
    );
  }
}

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Terms and Conditions"), backgroundColor: Colors.green),
      body: const Center(child: Text("Terms and Conditions Page")),
    );
  }
}
