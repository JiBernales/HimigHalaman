import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeModePage extends StatelessWidget {
  const ThemeModePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
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
          "Theme Mode",
          style: Theme.of(context).textTheme.titleLarge, // Use theme's text style
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SwitchListTile(
          title: const Text("Enable Dark Mode"),
          value: themeManager.themeMode == ThemeMode.dark,
          onChanged: (value) {
            themeManager.toggleTheme(); // Toggle the theme
          },
        ),
      ),
    );
  }
}

class ThemeManager extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // Notify listeners to update theme
  }
}

class AppThemes {
  // Common colors for light and dark themes
  static const Color primaryColor = Colors.green;
  static const Color accentColor = Colors.greenAccent;
  static const Color lightBackgroundColor = Colors.white;
  static const Color darkBackgroundColor = Color(0xFF303030);
  static Color? lightCardColor = Colors.green[100];
  static Color? darkCardColor = Colors.grey[800];
  static Color? lightIconColor = Colors.green[900];
  static const Color darkIconColor = Colors.greenAccent;

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: lightBackgroundColor,
    appBarTheme: const AppBarTheme(
      foregroundColor: primaryColor, // AppBar text and icon color
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.green[900], fontSize: 16),
      bodyMedium: TextStyle(color: Colors.green[900], fontSize: 14),
      displayLarge: TextStyle(
        color: Colors.green[900],
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: Colors.green[900],
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
    cardColor: lightCardColor,
    iconTheme: IconThemeData(color: lightIconColor),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackgroundColor,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.green, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.green, fontSize: 14),
      displayLarge: TextStyle(
        color: Colors.green,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: Colors.green,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.black,
        textStyle: const TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
    cardColor: darkCardColor,
    iconTheme: const IconThemeData(color: darkIconColor),
  );
}
