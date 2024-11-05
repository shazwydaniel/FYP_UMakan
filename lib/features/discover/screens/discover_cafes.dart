import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/cafes/screens/cafe.dart';
import 'package:fyp_umakan/features/discover/controller/discover_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/sizes.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';

class LocationCafesScreen extends StatelessWidget {
  final String location;
  final DiscoverController discoverController;

  const LocationCafesScreen({
    Key? key,
    required this.location,
    required this.discoverController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    // Filter cafes by location
    final cafesInLocation = discoverController.cafe
        .where((cafe) => cafe.location == location)
        .toList();

    return Scaffold(
        backgroundColor: TColors.mustard,
        appBar: AppBar(
          backgroundColor: TColors.mustard,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cafes in ', // Header text
                            style: TextStyle(
                              fontSize: 30, // Adjust font size
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Text color
                            ),
                          ),
                          Text(
                            '$location', // Header text
                            style: TextStyle(
                              fontSize: 30, // Adjust font size
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Text color
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(
                left: 30,
                right: 30,
              ), // Add padding around the ListView
              child: cafesInLocation.isEmpty
                  ? Center(
                      child: Padding(
                      padding: const EdgeInsets.only(top: 150),
                      child: Text(
                        'No cafes available in $location',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ))
                  : ListView.builder(
                      shrinkWrap:
                          true, // Allow ListView to take only necessary space
                      physics:
                          NeverScrollableScrollPhysics(), // Disable scrolling for the ListView
                      itemCount: cafesInLocation.length,
                      itemBuilder: (context, index) {
                        final cafe = cafesInLocation[index];
                        return Card(
                          elevation: 5, // Set the elevation to add shadow
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20), // Rounded corners
                          ),
                          color: TColors.cream,
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(cafe.name),
                              trailing: Icon(Icons.arrow_forward_ios_rounded,
                                  color: Colors.black),
                              onTap: () {
                                // Navigate to CafePage
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CafePage(
                                      cafe: cafe,
                                      vendorId: cafe.vendorId,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        )));
  }
}
