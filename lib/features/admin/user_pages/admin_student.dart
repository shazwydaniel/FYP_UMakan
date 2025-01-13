// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AdminStudent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.cream,
      appBar: AppBar(
        backgroundColor: TColors.cream,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            Text(
              'Let\'s Manage',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'Students',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 22),

            _sectionHeader('Users List', TColors.forest),

            // User List (Fetch from 'Users' (Student) Collection in Firebase)
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error fetching data.'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No students found.'),
                    );
                  }

                  final users = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                  width: 1.5,
                                ),
                              ),
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    child: Text(
                                      user['Username'][0].toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: TColors.forest,
                                    radius: 30,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user['FullName'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          user['Email'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    color: TColors.cream, // Popup background
                                    onSelected: (value) {
                                      if (value == 'Edit') {
                                        _showEditUserDialog(context, user);
                                      } else if (value == 'Delete') {
                                        _confirmDeleteUser(context, user.id);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'Edit',
                                        child: Row(
                                          children: [
                                            Text('Edit'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'Delete',
                                        child: Row(
                                          children: [
                                            Text('Delete'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Bottom Navbar
      bottomNavigationBar: BottomAppBar(
        color: TColors.forest,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: SizedBox(
          height: 80.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Iconsax.add_circle, color: Colors.white, size: 40),
                onPressed: () {
                  _showAddUserDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Add User Dialog
  void _showAddUserDialog(BuildContext context) {
    final fullNameController = TextEditingController();
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final phoneNumberController = TextEditingController();
    final matricsNumberController = TextEditingController();
    String selectedAccommodation = 'KK1';
    String selectedVehicleOwnership = 'No';
    String selectedMaritalStatus = 'Single';
    final childrenNumberController = TextEditingController();
    final monthlyAllowanceController = TextEditingController();
    final monthlyCommitmentsController = TextEditingController();
    final heightController = TextEditingController();
    final weightController = TextEditingController();
    DateTime? selectedBirthdate;

    // Page Index
    int pageIndex = 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final pages = [
              [
                TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: matricsNumberController,
                  decoration: InputDecoration(labelText: 'Matrics Number'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedAccommodation,
                  decoration: InputDecoration(labelText: 'Accommodation'),
                  dropdownColor: TColors.cream,
                  items: [
                    'KK1', 'KK2', 'KK3', 'KK4', 'KK5', 'KK6',
                    'KK7', 'KK8', 'KK9', 'KK10', 'KK11',
                    'KK12', 'KK13', 'Outside',
                  ].map((location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedAccommodation = value!;
                    });
                  },
                ),
              ],
              [
                DropdownButtonFormField<String>(
                  value: selectedVehicleOwnership,
                  decoration: InputDecoration(labelText: 'Vehicle Ownership'),
                  dropdownColor: TColors.cream,
                  items: ['Yes', 'No'].map((ownership) {
                    return DropdownMenuItem<String>(
                      value: ownership,
                      child: Text(ownership),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedVehicleOwnership = value!;
                    });
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedMaritalStatus,
                  decoration: InputDecoration(labelText: 'Marital Status'),
                  dropdownColor: TColors.cream,
                  items: ['Single', 'Married'].map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMaritalStatus = value!;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: childrenNumberController,
                  decoration: InputDecoration(labelText: 'Number of Children'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: monthlyAllowanceController,
                  decoration: InputDecoration(labelText: 'Monthly Allowance'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: monthlyCommitmentsController,
                  decoration: InputDecoration(labelText: 'Monthly Commitments'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: heightController,
                  decoration: InputDecoration(labelText: 'Height'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: weightController,
                  decoration: InputDecoration(labelText: 'Weight'),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedBirthdate = pickedDate;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: TextEditingController(
                        text: selectedBirthdate != null
                            ? "${selectedBirthdate!.day.toString().padLeft(2, '0')}/${selectedBirthdate!.month.toString().padLeft(2, '0')}/${selectedBirthdate!.year}"
                            : '',
                      ),
                      decoration: InputDecoration(labelText: 'Birthdate'),
                    ),
                  ),
                ),
              ],
            ];

            return AlertDialog(
              backgroundColor: TColors.cream,
              title: Text('Add Student'),
              content: SingleChildScrollView(
                child: Column(
                  children: pages[pageIndex],
                ),
              ),
              actions: [
                if (pageIndex > 0)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        pageIndex -= 1;
                      });
                    },
                    child: Text('Previous', style: TextStyle(color: TColors.textDark)),
                  ),
                if (pageIndex < pages.length - 1)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        pageIndex += 1;
                      });
                    },
                    child: Text('Next', style: TextStyle(color: TColors.stark_blue)),
                  ),
                if (pageIndex == pages.length - 1)
                  TextButton(
                    onPressed: () async {
                      try {
                        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );

                        final userId = userCredential.user!.uid;

                        await FirebaseFirestore.instance.collection('Users').doc(userId).set({
                          'Id': userId,
                          'FullName': fullNameController.text.trim(),
                          'Username': usernameController.text.trim(),
                          'Email': emailController.text.trim(),
                          'Role': 'Student',
                          'PhoneNumber': phoneNumberController.text.trim(),
                          'MatricsNumber': matricsNumberController.text.trim(),
                          'Accomodation': selectedAccommodation,
                          'Vehicle Ownership': selectedVehicleOwnership,
                          'Marital Status': selectedMaritalStatus,
                          'Number of Children': childrenNumberController.text.trim(),
                          'Monthly Allowance': monthlyAllowanceController.text.trim(),
                          'Monthly Commitments': monthlyCommitmentsController.text.trim(),
                          'Height': heightController.text.trim(),
                          'Weight': weightController.text.trim(),
                          'Birthdate': selectedBirthdate != null
                              ? "${selectedBirthdate!.day.toString().padLeft(2, '0')}/${selectedBirthdate!.month.toString().padLeft(2, '0')}/${selectedBirthdate!.year}"
                              : '',
                        });

                        Get.snackbar(
                          "Success",
                          "Student Successfully Registered!",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );

                        Navigator.of(context).pop();
                      } catch (e) {
                        Get.snackbar(
                          "Failed",
                          "Registration Failed!",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: Text('Add', style: TextStyle(color: Colors.green)),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel', style: TextStyle(color: TColors.amber)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Edit User Dialog
  void _showEditUserDialog(BuildContext context, QueryDocumentSnapshot user) {
    final fullNameController = TextEditingController(text: user['FullName']);
    final usernameController = TextEditingController(text: user['Username']);
    final emailController = TextEditingController(text: user['Email']);
    final phoneNumberController = TextEditingController(text: user['PhoneNumber']);
    final matricsNumberController = TextEditingController(text: user['MatricsNumber']);
    String selectedAccommodation = user['Accomodation'];
    String selectedVehicleOwnership = user['Vehicle Ownership'] ?? 'No';
    String selectedMaritalStatus = user['Marital Status'] ?? 'Single';
    final childrenNumberController = TextEditingController(text: user['Number of Children']);
    final monthlyAllowanceController = TextEditingController(text: user['Monthly Allowance']);
    final monthlyCommitmentsController = TextEditingController(text: user['Monthly Commitments']);
    final heightController = TextEditingController(text: user['Height']);
    final weightController = TextEditingController(text: user['Weight']);
    DateTime? selectedBirthdate;

    // Parse the Birthdate string if it exists
    if (user['Birthdate'] != null && user['Birthdate'].isNotEmpty) {
      final parts = user['Birthdate'].split('/'); // Split DD/MM/YYYY
      if (parts.length == 3) {
        selectedBirthdate = DateTime(
          int.parse(parts[2]), // Year
          int.parse(parts[1]), // Month
          int.parse(parts[0]), // Day
        );
      }
    }

    int pageIndex = 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final pages = [
              [
                TextField(controller: fullNameController, decoration: InputDecoration(labelText: 'Full Name')),
                const SizedBox(height: 10),
                TextField(controller: usernameController, decoration: InputDecoration(labelText: 'Username')),
                const SizedBox(height: 10),
                TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
                const SizedBox(height: 10),
                TextField(controller: phoneNumberController, decoration: InputDecoration(labelText: 'Phone Number')),
                const SizedBox(height: 10),
                TextField(controller: matricsNumberController, decoration: InputDecoration(labelText: 'Matrics Number')),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedAccommodation,
                  decoration: InputDecoration(labelText: 'Accommodation'),
                  dropdownColor: TColors.cream,
                  items: [
                    'KK1', 'KK2', 'KK3', 'KK4', 'KK5', 'KK6', 
                    'KK7', 'KK8', 'KK9', 'KK10', 'KK11', 
                    'KK12', 'KK13', 'Outside',
                  ].map((location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedAccommodation = value!;
                    });
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedVehicleOwnership,
                  decoration: InputDecoration(labelText: 'Vehicle Ownership'),
                  dropdownColor: TColors.cream,
                  items: ['Yes', 'No'].map((ownership) {
                    return DropdownMenuItem<String>(
                      value: ownership,
                      child: Text(ownership),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedVehicleOwnership = value!;
                    });
                  },
                ),
              ],
              [
                DropdownButtonFormField<String>(
                  value: selectedMaritalStatus,
                  decoration: InputDecoration(labelText: 'Marital Status'),
                  dropdownColor: TColors.cream,
                  items: ['Single', 'Married'].map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMaritalStatus = value!;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(controller: childrenNumberController, decoration: InputDecoration(labelText: 'Number of Children')),
                const SizedBox(height: 10),
                TextField(controller: monthlyAllowanceController, decoration: InputDecoration(labelText: 'Monthly Allowance')),
                const SizedBox(height: 10),
                TextField(controller: monthlyCommitmentsController, decoration: InputDecoration(labelText: 'Monthly Commitments')),
                const SizedBox(height: 10),
                TextField(controller: heightController, decoration: InputDecoration(labelText: 'Height')),
                const SizedBox(height: 10),
                TextField(controller: weightController, decoration: InputDecoration(labelText: 'Weight')),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedBirthdate ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedBirthdate = pickedDate;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: TextEditingController(
                        text: selectedBirthdate != null
                            ? "${selectedBirthdate!.day.toString().padLeft(2, '0')}/${selectedBirthdate!.month.toString().padLeft(2, '0')}/${selectedBirthdate!.year}"
                            : '',
                      ),
                      decoration: InputDecoration(labelText: 'Birthdate'),
                    ),
                  ),
                ),
              ],
            ];

            return AlertDialog(
              backgroundColor: TColors.cream,
              title: Text('Edit Student'),
              content: SingleChildScrollView(
                child: Column(
                  children: pages[pageIndex],
                ),
              ),
              actions: [
                if (pageIndex > 0)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        pageIndex -= 1;
                      });
                    },
                    child: Text('Previous', style: TextStyle(color: TColors.textDark)),
                  ),
                if (pageIndex < pages.length - 1)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        pageIndex += 1;
                      });
                    },
                    child: Text('Next', style: TextStyle(color: TColors.stark_blue)),
                  ),
                if (pageIndex == pages.length - 1)
                  TextButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance.collection('Users').doc(user.id).update({
                        'FullName': fullNameController.text.trim(),
                        'Username': usernameController.text.trim(),
                        'Email': emailController.text.trim(),
                        'PhoneNumber': phoneNumberController.text.trim(),
                        'MatricsNumber': matricsNumberController.text.trim(),
                        'Accomodation': selectedAccommodation,
                        'Vehicle Ownership': selectedVehicleOwnership,
                        'Marital Status': selectedMaritalStatus,
                        'Number of Children': childrenNumberController.text.trim(),
                        'Monthly Allowance': monthlyAllowanceController.text.trim(),
                        'Monthly Commitments': monthlyCommitmentsController.text.trim(),
                        'Height': heightController.text.trim(),
                        'Weight': weightController.text.trim(),
                        'Birthdate': selectedBirthdate != null
                            ? "${selectedBirthdate!.day.toString().padLeft(2, '0')}/${selectedBirthdate!.month.toString().padLeft(2, '0')}/${selectedBirthdate!.year}"
                            : '',
                      });
                      Get.snackbar(
                        "Success",
                        "User's Details Are Updated Successfully!",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                      Navigator.of(context).pop();
                    },
                    child: Text('Save', style: TextStyle(color: Colors.green)),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel', style: TextStyle(color: TColors.amber)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Confirm Delete User Dialog
  void _confirmDeleteUser(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: TColors.cream,
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('Users').doc(userId).delete();

                Get.snackbar(
                  "Success",
                  "Account Successfully Deleted!",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );

                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: TColors.vermillion)),
            ),
          ],
        );
      },
    );
  }

  // Section Header Widget
  Widget _sectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}