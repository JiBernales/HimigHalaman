import 'package:flutter/material.dart';
import 'language.dart';
import 'theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Dynamic background color
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor, // Use theme's app bar color
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.titleLarge, // Use theme's text style
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          // General Section
          buildSectionTitle(context, "General"),
          buildListTile(
            context,
            title: "Notifications",
            icon: Icons.notifications,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsPage()),
              );
            },
          ),
          buildListTile(
            context,
            title: "Language",
            icon: Icons.language,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LanguagePage()),
              );
            },
          ),
          buildListTile(
            context,
            title: "Location",
            icon: Icons.location_on,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LocationPage()),
              );
            },
          ),

          // Personalization Section
          buildSectionTitle(context, "Personalization"),
          buildListTile(
            context,
            title: "Font Size",
            icon: Icons.text_fields,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FontSizePage()),
              );
            },
          ),
          buildListTile(
            context,
            title: "Light/Dark Mode",
            icon: Icons.brightness_4,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ThemeModePage()),
              );
            },
          ),

          // More Section
          buildSectionTitle(context, "More"),
          buildListTile(
            context,
            title: "About Us",
            icon: Icons.info,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsPage()),
              );
            },
          ),
          buildListTile(
            context,
            title: "Privacy Notice",
            icon: Icons.lock,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyNoticePage()),
              );
            },
          ),
          buildListTile(
            context,
            title: "Terms and Services",
            icon: Icons.description,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermsAndConditionsPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  // Section Title Widget
  Widget buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ), // Dynamic text style
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
      color: Theme.of(context).cardColor, // Dynamic card color
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).iconTheme.color, size: 28),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge, // Dynamic text style
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).iconTheme.color,
          size: 18,
        ),
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