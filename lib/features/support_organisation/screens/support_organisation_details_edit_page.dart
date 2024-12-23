import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/features/support_organisation/controller/support_organisation_controller.dart';

class SupportOrganisationDetailsEditPage extends StatefulWidget {
  const SupportOrganisationDetailsEditPage({super.key});

  @override
  State<SupportOrganisationDetailsEditPage> createState() =>
      _SupportOrganisationDetailsEditPageState();
}

class _SupportOrganisationDetailsEditPageState
    extends State<SupportOrganisationDetailsEditPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SupportOrganisationController _controller =
      Get.put(SupportOrganisationController());

  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final doc = await _firestore
            .collection('SupportOrganisation')
            .doc(userId)
            .get();

        if (doc.exists) {
          final data = doc.data();
          setState(() {
            _controller.organisationNameController.text = data?['Organisation Name'] ?? '';
            _controller.contactNumberController.text = data?['Contact Number'] ?? '';
            _controller.location.value = data?['Location'] ?? 'In Campus';
            _controller.activeStatus.value = data?['Active Status'] ?? 'Active';
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateDetails() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        await _firestore.collection('SupportOrganisation').doc(userId).update({
          'Organisation Name': _controller.organisationNameController.text.trim(),
          'Contact Number': _controller.contactNumberController.text.trim(),
          'Location': _controller.location.value,
          'Active Status': _controller.activeStatus.value,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Details updated successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print("Error updating details: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update details. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.cream,
      appBar: AppBar(
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  const SizedBox(height: 20), // Space below AppBar
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Organisation Name
                        TextFormField(
                          controller: _controller.organisationNameController,
                          decoration: InputDecoration(
                            labelText: 'Organisation Name',
                            prefixIcon: Icon(Icons.business),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter organisation name'
                              : null,
                        ),
                        const SizedBox(height: 20),

                        // Contact Number
                        TextFormField(
                          controller: _controller.contactNumberController,
                          decoration: InputDecoration(
                            labelText: 'Contact Number',
                            prefixIcon: Icon(Icons.phone),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter contact number'
                              : null,
                        ),
                        const SizedBox(height: 20),

                        // Password
                        // TextFormField(
                        //   controller: _controller.organisationNameController,
                        //   decoration: InputDecoration(
                        //     labelText: 'Password',
                        //     prefixIcon: Icon(Icons.business),
                        //   ),
                        //   validator: (value) => value == null || value.isEmpty
                        //       ? 'Please enter password'
                        //       : null,
                        // ),
                        // const SizedBox(height: 20),

                        // Location (Dropdown)
                        Obx(
                          () => DropdownButtonFormField<String>(
                            value: _controller.location.value,
                            items: _controller.locationOptions
                                .map(
                                  (loc) => DropdownMenuItem(
                                    value: loc,
                                    child: Text(loc),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) =>
                                _controller.location.value =
                                    value ?? 'In Campus',
                            decoration: InputDecoration(
                              labelText: 'Location',
                              prefixIcon: Icon(Icons.location_on),
                            ),
                            dropdownColor: TColors.cream,
                            validator: (value) =>
                                value == null || value.isEmpty
                                    ? 'Please select a location'
                                    : null,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Active Status (Dropdown)
                        Obx(
                          () => DropdownButtonFormField<String>(
                            value: _controller.activeStatus.value,
                            items: _controller.statusOptions
                                .map(
                                  (status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) =>
                                _controller.activeStatus.value =
                                    value ?? 'Active',
                            decoration: InputDecoration(
                              labelText: 'Active Status',
                              prefixIcon: Icon(Icons.info),
                            ),
                            dropdownColor: TColors.cream,
                            validator: (value) =>
                                value == null || value.isEmpty
                                    ? 'Please select a status'
                                    : null,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Update Button
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 40),
                          child: Center(
                            child: Container(
                              width: 200, // Button width
                              height: 50, // Button height
                              decoration: BoxDecoration(
                                color: TColors.teal, // Original button color
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              child: TextButton(
                                onPressed: _updateDetails,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.white, size: 20), // Use a relevant icon
                                    const SizedBox(width: 10),
                                    Text(
                                      'Update Details',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}