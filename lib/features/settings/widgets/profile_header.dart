// TODO Implement this library.
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String userName;
  final String userEmail;

  const ProfileHeader({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 60),
          ),
          const SizedBox(height: 16),
          Text(
            userName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userEmail,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
