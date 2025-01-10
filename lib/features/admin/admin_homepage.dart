// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/admin/user_pages/admin_authority.dart';
import 'package:fyp_umakan/features/admin/user_pages/admin_student.dart';
import 'package:fyp_umakan/features/admin/user_pages/admin_supportOrg.dart';
import 'package:fyp_umakan/features/admin/user_pages/admin_vendor.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fyp_umakan/common/widgets/custom_shapes/curved_edges/curved_edges.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? TColors.cream : TColors.cream,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Welcome" Label
            ClipPath(
              clipper: TCustomCurvedEdges(),
              child: Container(
                color: TColors.charcoal,
                child: SizedBox(
                  height: 270,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 110,
                        left: 40,
                        child: Text(
                          'Welcome,',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: TColors.cream,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 160,
                        left: 40,
                        child: Text(
                          "Admin!",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: TColors.cream,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Account Types - Header Label with Info Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _sectionHeader('Account Types', TColors.charcoal),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), 
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: TColors.cream,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Title
                                      Text(
                                        "Account Types",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: TColors.charcoal,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 15),

                                      // Description
                                      Text(
                                        "Choose One to Start Managing",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          color: TColors.charcoal,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                // Exit Button (Top-right corner)
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: const Color.fromARGB(0, 192, 186, 186),
                                      radius: 14,
                                      child: Icon(
                                        Icons.close,
                                        color: TColors.amber,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: const Color.fromARGB(0, 192, 186, 186),
                      child: Icon(
                        Icons.info_outline,
                        color: TColors.charcoal,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Account Types - Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                children: [
                  _buildCard(
                    context,
                    'Students',
                    Iconsax.personalcard,
                    TColors.forest,
                    TColors.cream,
                    AdminStudent(),
                  ),
                  const SizedBox(height: 14),
                  _buildCard(
                    context,
                    'Vendors',
                    Iconsax.shop,
                    TColors.vermillion,
                    TColors.cream,
                    AdminVendor(),
                  ),
                  const SizedBox(height: 14),
                  _buildCard(
                    context,
                    'Support Organizations',
                    Iconsax.heart_circle,
                    TColors.blush,
                    TColors.cream,
                    AdminSupportorg(),
                  ),
                  const SizedBox(height: 14),
                  _buildCard(
                    context,
                    'Authorities',
                    Iconsax.security_card,
                    TColors.stark_blue,
                    TColors.cream,
                    AdminAuthority(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Accounts Types Cards Widget
  Widget _buildCard(BuildContext context, String title, IconData icon, Color bgColor, Color textColor, Widget targetPage) {
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

  // Section Header Widget
  Widget _sectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10, top: 20),
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}