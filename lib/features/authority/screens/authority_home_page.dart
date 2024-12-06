import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_umakan/common/widgets/custom_shapes/curved_edges/curved_edges.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthorityHomePage extends StatelessWidget {
  const AuthorityHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? TColors.darkGreen : TColors.cream,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: TCustomCurvedEdges(),
              child: Container(
                color: TColors.stark_blue,
                padding: const EdgeInsets.all(0),
                child: SizedBox(
                  height: 270,
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            // Title 1
                            Positioned(
                              top: 110,
                              left: 40,
                              child: Text(
                                'Welcome,',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: dark ? Colors.white : Colors.white,
                                ),
                              ),
                            ),

                            // Title 2
                            Positioned(
                              top: 160,
                              left: 40,
                              child: Text(
                                "Authority !",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: dark ? Colors.white : Colors.white,
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

            // Financially Struggling Students Section
            _sectionHeader('Financially Struggling Students', TColors.amber),
            FutureBuilder<List<Map<String, String>>>(
              future: _fetchStrugglingStudents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                final students = snapshot.data ?? [];
                return Container(
                  margin: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                    bottom: 20,
                    top: 10,
                  ),
                  decoration: BoxDecoration(
                    color: TColors.cobalt,
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
                    child: Column(
                      children: [
                        // List of Students or "No Students Found" Message
                        if (students.isEmpty)
                          Center(
                            child: Text(
                              'No students found.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: TColors.cream,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: students.asMap().entries.map((entry) {
                                final index = entry.key + 1;
                                final student = entry.value;

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "$index. ${student['FullName']}",
                                        style: TextStyle(
                                          color: TColors.textDark,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        student['MatricsNumber'] ?? 'N/A',
                                        style: TextStyle(
                                          color: TColors.textDark,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        const SizedBox(height: 20),
                        // Centered Download PDF Button
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                              color: TColors.bubbleBlue,
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                // Add download PDF logic here
                                print('Download PDF');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Iconsax.export,
                                      color: Colors.black, size: 20),
                                  SizedBox(width: 10),
                                  Text(
                                    'Download PDF',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Vendor Highlights Section
            _sectionHeader('Vendor Highlights', TColors.mustard),
            Container(
              height: 200,
              margin: const EdgeInsets.only(
                left: 30,
                right: 30,
                bottom: 20,
                top: 10,
              ),
              decoration: BoxDecoration(
                color: TColors.mustard,
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
              child: Center(
                child: Text(
                  'Display Best-Selling Menus Here',
                  style: TextStyle(
                    fontSize: 18,
                    color: TColors.marigold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Statistical Highlights Section
            _sectionHeader('Statistical Highlights', TColors.teal),
            _statCard(
              title: 'Financially Struggling',
              value: '37%',
              icon: Iconsax.trend_up,
              color: TColors.forest,
            ),
            _statCard(
              title: 'Nutritionally Struggling',
              value: '21%',
              icon: Iconsax.flash_1,
              color: TColors.blush,
            ),
            _statCard(
              title: 'Average Monthly Expenses',
              value: 'RM 450',
              icon: Iconsax.wallet_2,
              color: TColors.vermillion,
            ),
            SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  // Fetch Struggling Students
  Future<List<Map<String, String>>> _fetchStrugglingStudents() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('Users').get();

    List<Map<String, String>> strugglingStudents = [];

    for (var doc in snapshot.docs) {
      final role = doc.data()['Role'] ?? '';
      if (role != 'Student') continue;

      final financialStatusSnapshot = await doc.reference
          .collection('financial_status')
          .doc('current')
          .get();

      final financialStatus = financialStatusSnapshot.data()?['status'] ?? '';
      if (financialStatus == 'Deficit') {
        final fullName = doc.data()['FullName'] ?? 'Unknown';
        final matricsNumber = doc.data()['MatricsNumber'] ?? 'N/A';
        strugglingStudents.add({
          'FullName': fullName,
          'MatricsNumber': matricsNumber,
        });
      }
    }

    return strugglingStudents;
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