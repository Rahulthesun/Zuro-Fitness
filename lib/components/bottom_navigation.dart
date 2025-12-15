import 'package:flutter/material.dart';
import '../app.dart';

class BottomNavigation extends StatelessWidget {
  final Screen activeScreen;
  final Function(Screen) onNavigate;
  final Color accentColor;

  const BottomNavigation({
    super.key,
    required this.activeScreen,
    required this.onNavigate,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', Screen.home),
          _buildNavItem(Icons.credit_card, 'Wallet', Screen.wallet),
          _buildNavItem(Icons.calendar_today, 'Bookings', Screen.bookings),
          _buildNavItem(Icons.person, 'Profile', Screen.profile),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, Screen screen) {
    final isActive = activeScreen == screen;
    return GestureDetector(
      onTap: () => onNavigate(screen),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? accentColor : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? accentColor : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}