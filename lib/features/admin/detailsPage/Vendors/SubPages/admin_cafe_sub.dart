// ignore_for_file: prefer_const_constructors

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

  // Main Page
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
              'Let\s Manage $cafeName',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 22),

            _sectionHeader('Choose One to Start', TColors.vermillion),

            _buildCard(
              context,
              'Items',
              Icons.fastfood,
              TColors.stark_blue,
              TColors.cream,
              AdminItemsPage(vendorId: vendorId, cafeId: cafeId),
            ),
            const SizedBox(height: 16),
            _buildCard(
              context,
              'Reviews',
              Icons.rate_review,
              TColors.forest,
              TColors.cream,
              AdminReviewsPage(vendorId: vendorId, cafeId: cafeId),
            ),
            const SizedBox(height: 16),
            _buildCard(
              context,
              'Advertisements',
              Icons.campaign,
              TColors.amber,
              TColors.cream,
              AdminAdvertisementsPage(vendorId: vendorId, cafeId: cafeId),
            ),
          ],
        ),
      ),
    );
  }

  // Section Header Widget
  Widget _sectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 4,
            height: 40,
            color: color,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
