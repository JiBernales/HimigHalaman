import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const NavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.eco), label: "Garden"),
        BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: "Capture"),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
      ],
    );
  }
}

