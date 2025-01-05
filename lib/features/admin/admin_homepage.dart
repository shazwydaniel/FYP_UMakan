import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/admin/user_management_page.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, int>>(
          future: _fetchUserCounts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final userCounts = snapshot.data!;
              return GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildCard(context, 'Students', Icons.school, Colors.green,
                      'students', userCounts['students']),
                  _buildCard(context, 'Vendors', Icons.store, Colors.orange,
                      'vendors', userCounts['vendors']),
                  _buildCard(
                      context,
                      'Support Organizations',
                      Icons.support,
                      Colors.purple,
                      'supportOrganizations',
                      userCounts['supportOrganizations']),
                  _buildCard(context, 'Authorities', Icons.security, Colors.red,
                      'authorities', userCounts['authorities']),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<Map<String, int>> _fetchUserCounts() async {
    final firestore = FirebaseFirestore.instance;

    final studentsCount = await firestore.collection('Users').get();
    final vendorsCount = await firestore.collection('Vendors').get();
    final supportOrganizationsCount =
        await firestore.collection('SupportOrganisation').get();
    final authoritiesCount = await firestore.collection('Authority').get();

    return {
      'students': studentsCount.docs.length,
      'vendors': vendorsCount.docs.length,
      'supportOrganizations': supportOrganizationsCount.docs.length,
      'authorities': authoritiesCount.docs.length,
    };
  }

  Widget _buildCard(BuildContext context, String title, IconData icon,
      Color color, String userType, int? count) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => UserManagementPage(userType: userType)),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 50),
              const SizedBox(height: 10),
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 5),
              Text(
                '$count Users',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
