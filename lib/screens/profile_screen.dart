import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final Color accentColor;

  const ProfileScreen({super.key, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[800],
            child: Icon(
              Icons.person,
              size: 50,
              color: accentColor,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'John Doe',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              _buildProfileItem(Icons.email, 'john.doe@example.com'),
              const SizedBox(height: 20),
              _buildProfileItem(Icons.phone, '+1 234 567 8900'),
              const SizedBox(height: 20),
              _buildProfileItem(Icons.location_on, 'New York, USA'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileItem(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: accentColor),
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}