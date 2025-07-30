import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_advert_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';

class AllAdvertisementsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final advertController = Get.find<AdvertController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("All Advertisements"),
        backgroundColor: TColors.cream,
      ),
      backgroundColor: TColors.cream,
      body: Obx(() {
        final advertisements = advertController.allAdvertisements
            .where((ad) => ad.status == "Promotion")
            .toList();

        if (advertisements.isEmpty) {
          return Center(
            child: Text(
              "No advertisements currently available.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Text color for better contrast
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: advertisements.length,
          itemBuilder: (context, index) {
            final advertisement = advertisements[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: index.isEven
                    ? TColors.tangerine
                    : TColors.cobalt, // Rectangle background color
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Shadow color
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: Offset(0, 3), // Offset for shadow
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Text(
                  advertisement.detail,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Text color
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${advertisement.cafeName} (${advertisement.location})",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                        height:
                            8), // Add spacing between the text and container
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: index.isEven
                            ? TColors.bubbleOrange
                            : TColors.bubbleBlue.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${advertisement.startDate != null ? "${advertisement.startDate!.day}-${advertisement.startDate!.month}-${advertisement.startDate!.year}" : "No Start Date"} until ${advertisement.endDate != null ? "${advertisement.endDate!.day}-${advertisement.endDate!.month}-${advertisement.endDate!.year}" : "No End Date"}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
