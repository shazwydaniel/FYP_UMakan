import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/admin/user_pages/admin_authority.dart';
import 'package:fyp_umakan/features/admin/user_pages/admin_student.dart';
import 'package:fyp_umakan/features/admin/user_pages/admin_supportOrg.dart';
import 'package:fyp_umakan/features/admin/user_pages/admin_vendor.dart';

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
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildCard(context, 'Students', Icons.school, Colors.green,
                AdminStudent()),
            _buildCard(
                context, 'Vendors', Icons.store, Colors.orange, AdminVendor()),
            _buildCard(context, 'Support Organizations', Icons.support,
                Colors.purple, AdminSupportorg()),
            _buildCard(context, 'Authorities', Icons.security, Colors.red,
                AdminAuthority()),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon,
      Color color, Widget targetPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => targetPage),
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
            ],
          ),
        ),
      ),
    );
  }
}
