import 'package:flutter/material.dart';

class VendorReviewsPage extends StatelessWidget {
  VendorReviewsPage({super.key});

  final List<Review> cafes = [
    Review(name: "Cafe Mocha", reviews: ["Great coffee!", "Nice ambiance."]),
    Review(name: "Latte Land", reviews: ["Good service.", "Loved the latte."]),
    Review(name: "Espresso Express", reviews: ["Best espresso in town."]),
    Review(name: "Brew Brothers", reviews: ["Cozy place, friendly staff."]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Review Page')),
      body: ListView.builder(
        itemCount: cafes.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60), // Full-width buttons
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CafeReviews(cafe: cafes[index]),
                  ),
                );
              },
              child: Text(cafes[index].name),
            ),
          );
        },
      ),
    );
  }
}

class CafeReviews extends StatelessWidget {
  final Review cafe;

  CafeReviews({required this.cafe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cafe.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reviews",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cafe.reviews.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(cafe.reviews[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Review {
  final String name;
  final List<String> reviews;

  Review({required this.name, required this.reviews});
}
