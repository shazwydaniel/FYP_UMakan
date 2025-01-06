import 'package:flutter/material.dart';
import 'package:fyp_umakan/data/repositories/authentication/authentication_repository.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({Key? key}) : super(key: key);

  void _logout(BuildContext context) {
    // Handle logout logic here
    Get.offAllNamed('/login'); // Example: Redirect to login page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                          'assets/admin_avatar.png'), // Placeholder image
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Admin Name',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'admin@example.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Account Details Section
              Text(
                'Account Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.person, color: Colors.blue),
                title: Text('Name'),
                subtitle: Text('Admin Name'),
              ),
              ListTile(
                leading: Icon(Icons.email, color: Colors.blue),
                title: Text('Email'),
                subtitle: Text('admin@example.com'),
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.blue),
                title: Text('Role'),
                subtitle: Text('Administrator'),
              ),

              const SizedBox(height: 20),

              // Statistics or Management Options (Optional)
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.dashboard, color: Colors.green),
                title: Text('View Dashboard'),
                onTap: () {
                  Get.toNamed('/dashboard'); // Navigate to dashboard
                },
              ),
              ListTile(
                leading: Icon(Icons.group, color: Colors.orange),
                title: Text('Manage Users'),
                onTap: () {
                  Get.toNamed('/manage-users'); // Navigate to user management
                },
              ),

              const SizedBox(height: 30),

              // Logout Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: TColors.cream,
                          title: const Text('Confirm Logout'),
                          content:
                              const Text('Are you sure you want to log out?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Log Out'),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm == true) {
                      await AuthenticatorRepository.instance.logout();
                    }
                  },
                  icon: Icon(Icons.logout),
                  label: Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
