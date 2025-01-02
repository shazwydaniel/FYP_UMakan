// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_umakan/common/widgets/custom_shapes/curved_edges/curved_edges.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_filex/open_filex.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';

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
                              onPressed: () async {
                                try {
                                  // Load the UM logo
                                  final Uint8List logoBytes = await rootBundle
                                      .load('assets/logos/UM_Logo.png')
                                      .then((value) => value.buffer.asUint8List());

                                  // Get the current date for the file name
                                  final DateTime now = DateTime.now();
                                  final String formattedDate =
                                      '${now.day.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.year}';

                                  // Fetch the students data
                                  final students = await _fetchStrugglingStudents();

                                  // Generate the PDF with the logo
                                  final pdfData = await _createPDF(students, logoBytes);

                                  // Save the PDF locally
                                  final tempDir = await getTemporaryDirectory();
                                  final file = File('${tempDir.path}/Financially_Struggling_Students_$formattedDate.pdf');
                                  await file.writeAsBytes(pdfData, flush: true);

                                  print('PDF saved at: ${file.path}');

                                  // Open the PDF using the system's default viewer
                                  final result = await OpenFilex.open(file.path);
                                  print('Result: $result');
                                } catch (e) {
                                  print('Error generating PDF: $e');
                                  Get.snackbar('Error', 'Failed to generate PDF. Please try again.');
                                }
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

            // Students Statistics Section
            _sectionHeader('Student Statistics', TColors.teal),
            // Card #1
            FutureBuilder<int>(
              future: _fetchUserCount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading user count',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                final userCount = snapshot.data ?? 0;
                return _statCard(
                  title: 'Students Registered',
                  value: userCount.toString(),
                  icon: Iconsax.people,
                  color: TColors.blush,
                );
              },
            ),
            // Card #2
            FutureBuilder<int>(
              future: _fetchFinanciallyStrugglingCount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading financially struggling count',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                final strugglingCount = snapshot.data ?? 0;
                return _statCard(
                  title: 'Financially Struggling',
                  value: strugglingCount.toString(),
                  icon: Iconsax.warning_2,
                  color: TColors.vermillion,
                );
              },
            ),
            // Card #3
            FutureBuilder<double>(
              future: _fetchAverageMonthlyAllowance(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading average monthly expenses',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                final averageAllowance = snapshot.data ?? 0.0;
                return _statCard(
                  title: 'Average Monthly Expenses',
                  value: 'RM ${averageAllowance.toStringAsFixed(2)}',
                  icon: Iconsax.wallet_2,
                  color: TColors.forest,
                );
              },
            ),

            SizedBox(height: 20),

            // Vendor Statistics Section
            _sectionHeader('Vendor Statistics', TColors.mustard),
            // Card #1
            FutureBuilder<int>(
              future: _fetchVendorCount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading vendor count',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                final vendorCount = snapshot.data ?? 0;
                return _statCard(
                  title: 'Vendors Registered',
                  value: vendorCount.toString(),
                  icon: Iconsax.shop,
                  color: TColors.coffee,
                );
              },
            ),
            // Card #2
            FutureBuilder<int>(
              future: _fetchCafeCount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading cafe count',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                final cafeCount = snapshot.data ?? 0;
                return _statCard(
                  title: 'Cafes Registered',
                  value: cafeCount.toString(),
                  icon: Iconsax.coffee,
                  color: TColors.bubbleOrange,
                );
              },
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
        final accomodation = doc.data()['Accomodation'] ?? 'Unknown';
        strugglingStudents.add({
          'FullName': fullName,
          'MatricsNumber': matricsNumber,
          'Accomodation' : accomodation,
        });
      }
    }

    return strugglingStudents;
  }

  // Statistical Highlight Card Widget
  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    Color? iconColor,
    Color? titleColor,
    Color? valueColor,
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
              color: iconColor ?? Colors.white,
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
                    color: titleColor ?? Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor ?? Colors.white,
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

  // Generate PDF - List of Student
  Future<Uint8List> _createPDF(List<Map<String, String>> students, Uint8List logoBytes) async {
    // Get the current date
    final DateTime now = DateTime.now();
    final String formattedDate =
        '${now.day.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.year}';
    final String displayDate =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

    // Create a PDF document
    PdfDocument document = PdfDocument();

    // Add a page
    final page = document.pages.add();

    // Draw the university logo at the top right
    if (logoBytes.isNotEmpty) {
      PdfBitmap logo = PdfBitmap(logoBytes);
      page.graphics.drawImage(
        logo,
        Rect.fromLTWH(
          page.getClientSize().width - 170, // Adjusted x position to leave some padding
          10, // Adjusted y position for better alignment
          160, // Increased width
          50, // Decreased height
        ),
      );
    }

    // Draw the title
    page.graphics.drawString(
      'Financially Struggling Students',
      PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(0, 10, page.getClientSize().width, 30),
    );

    // Draw the generation date under the title
    page.graphics.drawString(
      'This list is generated on: $displayDate',
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      bounds: Rect.fromLTWH(0, 40, page.getClientSize().width, 20),
    );

    // Create a PdfGrid for the table
    PdfGrid pdfGrid = PdfGrid();

    // Add columns to the grid
    pdfGrid.columns.add(count: 4);

    // Add header row
    PdfGridRow header = pdfGrid.headers.add(1)[0];
    header.cells[0].value = 'No.';
    header.cells[1].value = 'Full Name';
    header.cells[2].value = 'Student ID';
    header.cells[3].value = 'Place of Stay';

    // Style the header
    header.style = PdfGridCellStyle(
      backgroundBrush: PdfSolidBrush(PdfColor(64, 64, 64)), // Dark grey background
      textBrush: PdfBrushes.white, // White text
      font: PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold),
    );

    // Add rows for student data
    for (int i = 0; i < students.length; i++) {
      PdfGridRow row = pdfGrid.rows.add();
      row.cells[0].value = (i + 1).toString(); // Index
      row.cells[1].value = students[i]['FullName'] ?? 'N/A'; // Full Name
      row.cells[2].value = students[i]['MatricsNumber'] ?? 'N/A'; // Student ID
      row.cells[3].value = students[i]['Accomodation'] ?? 'N/A'; // Place of Stay
    }

    // Style rows
    pdfGrid.style = PdfGridStyle(
      font: PdfStandardFont(PdfFontFamily.helvetica, 12),
      cellPadding: PdfPaddings(left: 5, right: 5, top: 5, bottom: 5),
    );

    // Draw the grid on the page
    pdfGrid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, 100, page.getClientSize().width, page.getClientSize().height - 120),
    );

    // Add footer text
    page.graphics.drawString(
      'Generated Through UMakan Mobile App',
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      bounds: Rect.fromLTWH(0, page.getClientSize().height - 20, page.getClientSize().width, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
    );

    // Save the document as a byte array
    List<int> bytes = await document.save();

    // Dispose the document to free resources
    document.dispose();

    // Return the byte array as Uint8List
    return Uint8List.fromList(bytes);
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

  // News Cards Data Fetching
  // Total Students Registered
  Future<int> _fetchUserCount() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('Users').get();
    return snapshot.docs.length;
  }
  // Financially Struggling Total
  Future<int> _fetchFinanciallyStrugglingCount() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('Users').get();

    int strugglingCount = 0;

    for (var doc in snapshot.docs) {
      final role = doc.data()['Role'] ?? '';
      if (role != 'Student') continue;

      final financialStatusSnapshot = await doc.reference
          .collection('financial_status')
          .doc('current')
          .get();

      final financialStatus = financialStatusSnapshot.data()?['status'] ?? '';
      if (financialStatus == 'Deficit') {
        strugglingCount++;
      }
    }

    return strugglingCount;
  }
  // Average Monthly Expenses
  Future<double> _fetchAverageMonthlyAllowance() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('Users').get();

    double totalAllowance = 0.0;
    int studentCount = 0;

    for (var doc in snapshot.docs) {
      final role = doc.data()['Role'] ?? '';
      if (role == 'Student') {
        final monthlyAllowanceStr = doc.data()['Monthly Allowance'] ?? '0';
          print('monthlyAllowance: $monthlyAllowanceStr');
        final double monthlyAllowance = double.tryParse(monthlyAllowanceStr.trim()) ?? 0.0;

        totalAllowance += monthlyAllowance;
        studentCount++;
      }
    }

    return studentCount > 0 ? totalAllowance / studentCount : 0.0;
  }
  // Total Vendors Registered
  Future<int> _fetchVendorCount() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('Vendors').get();
    return snapshot.docs.length;
  }
  // Total Cafes Registered
  Future<int> _fetchCafeCount() async {
    final firestore = FirebaseFirestore.instance;
    int totalCafes = 0;

    // Fetch vendors
    final vendorsSnapshot = await firestore.collection('Vendors').get();

    for (var vendorDoc in vendorsSnapshot.docs) {
      // For each vendor, fetch cafes subcollection
      final cafesSnapshot = await vendorDoc.reference.collection('Cafe').get();
      totalCafes += cafesSnapshot.docs.length;
    }

    return totalCafes;
  }
}