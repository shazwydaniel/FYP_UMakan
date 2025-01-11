import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/admin/detailsPage/Vendors/SubPages/admin_vendor_cafe_advertisment.dart';
import 'package:fyp_umakan/features/admin/detailsPage/Vendors/SubPages/admin_vendor_cafe_item.dart';
import 'package:fyp_umakan/features/admin/detailsPage/Vendors/SubPages/admin_vendor_cafe_review.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';

class CafeSubPage extends StatelessWidget {
  final String vendorId;
  final String cafeId;
  final String cafeName;

  CafeSubPage({
    required this.vendorId,
    required this.cafeId,
    required this.cafeName,
  });

  Widget _buildCard(BuildContext context, String title, IconData icon,
      Color bgColor, Color textColor, Widget targetPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => targetPage),
        );
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Icon(icon, color: textColor, size: 50),
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.cream,
      appBar: AppBar(
        backgroundColor: TColors.cream,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'View $cafeName info',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 22),
            _buildCard(
              context,
              'Items',
              Icons.fastfood,
              Colors.blue,
              Colors.white,
              AdminItemsPage(vendorId: vendorId, cafeId: cafeId),
            ),
            const SizedBox(height: 16),
            _buildCard(
              context,
              'Reviews',
              Icons.rate_review,
              Colors.green,
              Colors.white,
              AdminReviewsPage(vendorId: vendorId, cafeId: cafeId),
            ),
            const SizedBox(height: 16),
            _buildCard(
              context,
              'Advertisements',
              Icons.campaign,
              Colors.red,
              Colors.white,
              AdminAdvertisementsPage(vendorId: vendorId, cafeId: cafeId),
            ),
          ],
        ),
      ),
    );
  }
}
