import 'package:flutter/material.dart';

class DarkCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const DarkCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800], // Set the background color to a dark shade
      elevation: 4, // Add a subtle shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Add rounded corners to the card
      ),
      child: Padding(
        padding: const EdgeInsets.all(16), // Add padding to the content inside the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              image,
              height: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
