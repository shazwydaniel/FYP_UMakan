import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
// Import the CafeDetails model

class CafePage extends StatelessWidget {
  final CafeDetailsData cafe; // Accept CafeDetails instead of CafePage

  const CafePage({super.key, required this.cafe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cafe.name)), // Display the cafe name
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(cafe.logoPath), // Display the cafe logo
            SizedBox(height: 16),
            Text(
              cafe.details, // Display cafe details
              style: TextStyle(fontSize: 16),
            ),
            // Add more details or widgets as needed
          ],
        ),
      ),
    );
  }
}
