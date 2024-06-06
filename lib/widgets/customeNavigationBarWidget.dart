import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      fixedColor: Color(0xFF9F5540),
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: currentIndex == 0 ? Color(0xFF9F5540): Colors.black  ),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sunny, color: currentIndex == 1 ? Color(0xFF9F5540): Colors.black),
          label: 'Univers',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: currentIndex == 2 ? Color(0xFF9F5540) : Colors.black),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message, color: currentIndex == 3 ? Color(0xFF9F5540) :Colors.black),
          label: 'Messages',
        ),

      ],
    );
  }
}
