import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/admin/detailsPage/Vendors/SubPages/admin_vendor_cafe_advertisment.dart';
import 'package:fyp_umakan/features/admin/detailsPage/Vendors/SubPages/admin_vendor_cafe_item.dart';
import 'package:fyp_umakan/features/admin/detailsPage/Vendors/SubPages/admin_vendor_cafe_review.dart';

class CafeSubPage extends StatelessWidget {
  final String vendorId;
  final String cafeId;
  final String cafeName;

  CafeSubPage({
    required this.vendorId,
    required this.cafeId,
    required this.cafeName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cafeName),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to Items page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminItemsPage(
                      vendorId: vendorId,
                      cafeId: cafeId,
                    ),
                  ),
                );
              },
              child: const Text('Items'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to Reviews page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminReviewsPage(
                      vendorId: vendorId,
                      cafeId: cafeId,
                    ),
                  ),
                );
              },
              child: const Text('Reviews'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to Advertisements page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminAdvertisementsPage(
                      vendorId: vendorId,
                      cafeId: cafeId,
                    ),
                  ),
                );
              },
              child: const Text('Advertisements'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
