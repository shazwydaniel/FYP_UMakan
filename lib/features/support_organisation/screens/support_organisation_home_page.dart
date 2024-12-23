import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_umakan/common/widgets/custom_shapes/curved_edges/curved_edges.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';

class SupportOrganisationHomePage extends StatelessWidget {
  const SupportOrganisationHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? TColors.darkGreen : TColors.cream,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Header with Curved Edges
            ClipPath(
              clipper: TCustomCurvedEdges(),
              child: Container(
                color: TColors.blush,
                padding: const EdgeInsets.all(0),
                child: SizedBox(
                  height: 270,
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            // Welcome Message
                            Positioned(
                              top: 110,
                              left: 40,
                              child: Text(
                                'Welcome,',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 160,
                              left: 40,
                              child: Text(
                                "SZA!",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // // Pending Requests Section
            // _sectionHeader('Pending Requests', TColors.amber),
            // Container(
            //   margin: const EdgeInsets.all(20),
            //   decoration: BoxDecoration(
            //     color: TColors.cobalt,
            //     borderRadius: BorderRadius.circular(20),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.2),
            //         spreadRadius: 2,
            //         blurRadius: 10,
            //         offset: Offset(0, 8),
            //       ),
            //     ],
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.all(20.0),
            //     child: Column(
            //       children: [
            //         // Placeholder Text for Requests
            //         Text(
            //           'No pending requests at the moment.',
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 16,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //         const SizedBox(height: 20),
            //         // Button for Viewing Requests
            //         Align(
            //           alignment: Alignment.center,
            //           child: Container(
            //             width: 200,
            //             height: 50,
            //             decoration: BoxDecoration(
            //               color: TColors.bubbleBlue,
            //               borderRadius: BorderRadius.circular(20.0),
            //               border: Border.all(
            //                 color: Colors.black,
            //                 width: 2.0,
            //               ),
            //             ),
            //             child: TextButton(
            //               onPressed: () {
            //                 // Add logic for viewing requests
            //                 print('View Requests');
            //               },
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Icon(Iconsax.document, color: Colors.black, size: 20),
            //                   SizedBox(width: 10),
            //                   Text(
            //                     'View Requests',
            //                     style: TextStyle(
            //                       color: Colors.black,
            //                       fontSize: 16.0,
            //                       fontWeight: FontWeight.bold,
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // Key Highlights Section
            _sectionHeader('Key Highlights', TColors.teal),
            _statCard(
              title: 'Support Provided',
              value: '75%',
              icon: Iconsax.people,
              color: TColors.forest,
            ),
            _statCard(
              title: 'Active Campaigns',
              value: '12',
              icon: Iconsax.star,
              color: TColors.teal,
            ),
            _statCard(
              title: 'Funds Raised',
              value: 'RM 12,000',
              icon: Iconsax.wallet_2,
              color: TColors.olive,
            ),
            SizedBox(height: 35),
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

  // Statistical Highlight Card Widget
  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}