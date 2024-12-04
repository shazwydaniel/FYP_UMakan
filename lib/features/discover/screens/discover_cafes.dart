import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/cafes/screens/cafe.dart';
import 'package:fyp_umakan/features/discover/controller/discover_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';

class LocationCafesScreen extends StatelessWidget {
  final String location;
  final String image;
  final DiscoverController discoverController;

  const LocationCafesScreen({
    Key? key,
    required this.location,
    required this.image,
    required this.discoverController,
  }) : super(key: key);

  // Helper function to parse time from 12-hour format to TimeOfDay
  TimeOfDay parseTime(String time) {
    final isPM = time.contains('PM');
    final parts = time.split(' ')[0].split(':'); // Split "HH:MM"
    int hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    if (isPM && hour != 12) hour += 12; // Convert PM to 24-hour format
    if (!isPM && hour == 12) hour = 0; // Convert 12 AM to 0-hour

    return TimeOfDay(hour: hour, minute: minute);
  }

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
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.asset(
                      image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cafes in $location',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Cafe List Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: cafesInLocation.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 150),
                        child: Text(
                          'No cafes available in $location',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cafesInLocation.length,
                      itemBuilder: (context, index) {
                        final cafe = cafesInLocation[index];

                        final openingTime = parseTime(cafe.openingTime);
                        final closingTime = parseTime(cafe.closingTime);

                        final now = TimeOfDay.now();

                        final isOpen = now.hour > openingTime.hour ||
                            (now.hour == openingTime.hour &&
                                    now.minute >= openingTime.minute) &&
                                (now.hour < closingTime.hour ||
                                    (now.hour == closingTime.hour &&
                                        now.minute <= closingTime.minute));

                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: isOpen ? TColors.cream : Colors.grey[300],
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                cafe.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isOpen ? Colors.black : Colors.grey[600],
                                ),
                              ),
                              subtitle: Text(
                                "From ${cafe.openingTime} to ${cafe.closingTime}",
                                style: TextStyle(
                                  color:
                                      isOpen ? Colors.black : Colors.grey[600],
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: isOpen ? Colors.black : Colors.grey[600],
                              ),
                              enabled: isOpen,
                              onTap: isOpen
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CafePage(
                                            cafe: cafe,
                                            vendorId: cafe.vendorId,
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                            ),
                          ),
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
