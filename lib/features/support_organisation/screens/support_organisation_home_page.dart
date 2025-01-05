import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_umakan/common/widgets/custom_shapes/curved_edges/curved_edges.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';

class SupportOrganisationHomePage extends StatefulWidget {
  const SupportOrganisationHomePage({super.key});

  @override
  State<SupportOrganisationHomePage> createState() => _SupportOrganisationHomePageState();
}

class _SupportOrganisationHomePageState extends State<SupportOrganisationHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? organisationName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrganisationName();
  }

  Future<void> _fetchOrganisationName() async {
    try {
      final userId = _auth.currentUser?.uid;

      if (userId != null) {
        final doc = await _firestore.collection('SupportOrganisation').doc(userId).get();

        if (doc.exists) {
          setState(() {
            organisationName = doc.data()?['Organisation Name'] ?? 'Support Organisation';
            isLoading = false;
          });
        } else {
          setState(() {
            organisationName = 'Support Organisation';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error fetching organisation name: $e");
      setState(() {
        organisationName = 'Support Organisation';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? TColors.darkGreen : TColors.cream,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                                      organisationName ?? 'Support Organisation',
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

                  // UM Highlights Section
                  _sectionHeader('UM Highlights', TColors.teal),
                  // Card #1
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
                        title: 'Cafes In Campus',
                        value: cafeCount.toString(),
                        icon: Iconsax.coffee,
                        color: TColors.forest,
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
                        title: 'Struggling Students',
                        value: strugglingCount.toString(),
                        icon: Iconsax.warning_2,
                        color: TColors.teal,
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
                            'Error loading average monthly allowances',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      final averageAllowance = snapshot.data ?? 0.0;
                      return _statCard(
                        title: 'Average Allowances',
                        value: 'RM ${averageAllowance.toStringAsFixed(2)}',
                        icon: Iconsax.wallet_2,
                        color: TColors.olive,
                      );
                    },
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
        final double monthlyAllowance = double.tryParse(monthlyAllowanceStr.trim()) ?? 0.0;

        totalAllowance += monthlyAllowance;
        studentCount++;
      }
    }

    return studentCount > 0 ? totalAllowance / studentCount : 0.0;
  }
}