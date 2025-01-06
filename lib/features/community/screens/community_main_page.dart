// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import "dart:convert";
import "dart:io";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:dart_sentiment/dart_sentiment.dart";
import "package:file_picker/file_picker.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:fyp_umakan/data/repositories/authentication/authentication_repository.dart";
import "package:fyp_umakan/features/support_organisation/controller/support_organisation_controller.dart";
import "package:fyp_umakan/features/support_organisation/model/support_organisation_model.dart";
import "package:fyp_umakan/utils/constants/colors.dart";
import "package:fyp_umakan/utils/helpers/helper_functions.dart";
import "package:get/get.dart";
import "package:get/get_core/src/get_main.dart";
import "package:url_launcher/url_launcher.dart";
import "package:iconsax/iconsax.dart";
import 'package:http/http.dart' as http;

class CommunityMainPageScreen extends StatelessWidget {
  const CommunityMainPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final supportOrganisationController = Get.put(SupportOrganisationController());

    return Scaffold(
      backgroundColor: TColors.cobalt,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Container(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Campus',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                  Text(
                    'Community',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Supporting Organisations (Label)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    color: TColors.teal,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Supporting Organisations',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Fetch and display Supporting Organisations (Firebase)
            FutureBuilder<List<SupportOrganisationModel>>(
              future: supportOrganisationController.fetchAllOrganisations(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading data'));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final organisations = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
                    child: Column(
                      children: organisations.map((org) {
                        // Determine the style based on the active status
                        final isActive = org.activeStatus == 'Active';
                        final activeStatusColor = isActive ? TColors.forest.withOpacity(0.5) : TColors.amber.withOpacity(0.5);
                        final activeStatusIcon = isActive ? Iconsax.tick_circle : Iconsax.warning_2;

                        // Determine the style based on the location
                        final isInCampus = org.location == 'In Campus';
                        final locationColor = isInCampus ? TColors.stark_blue.withOpacity(0.5) : TColors.blush.withOpacity(0.5);
                        final locationIcon = isInCampus ? Iconsax.location : Iconsax.location_add;

                        return Container(
                          height: 220,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: TColors.cream,
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
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        org.organisationName,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.phone,
                                            color: TColors.bubbleOlive,
                                            size: 16,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            org.contactNumber,
                                            style: TextStyle(
                                              color: TColors.bubbleOlive,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      if (org.telegramHandle?.isNotEmpty == true)
                                        GestureDetector(
                                          onTap: () async {
                                            final url = "https://t.me/${org.telegramHandle}";
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              Get.snackbar(
                                                'Error',
                                                'Failed to open Telegram link.',
                                                snackPosition: SnackPosition.BOTTOM,
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white,
                                              );
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/icons/telegram.png',
                                                height: 20,
                                                width: 20,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                'Contact via Telegram',
                                                style: TextStyle(
                                                  color: TColors.bubbleOlive,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      const SizedBox(height: 20),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Active Status Tag with Icon
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: activeStatusColor,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(activeStatusIcon, size: 16, color: Colors.black),
                                                const SizedBox(width: 5),
                                                Text(
                                                  org.activeStatus,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),

                                          // Location Tag with Icon
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: locationColor,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(locationIcon, size: 16, color: Colors.black),
                                                const SizedBox(width: 5),
                                                Text(
                                                  org.location,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  return Center(child: Text('No Supporting Organisations found.'));
                }
              },
            ),

            // Community News (Label)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    color: TColors.amber,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Community News',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Fetch and display Community News (Firebase)
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('community_news').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading community news'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No community news available'));
                }

                // Filter to exclude expired news
                final newsList = snapshot.data!.docs.where((doc) {
                  final duration = doc['news_duration'];
                  final timestamp = (doc['timestamp'] as Timestamp).toDate();
                  DateTime expiry = timestamp;

                  switch (duration) {
                    case '1 Day':
                      expiry = expiry.add(Duration(days: 1));
                      break;
                    case '3 Days':
                      expiry = expiry.add(Duration(days: 3));
                      break;
                    case '1 Week':
                      expiry = expiry.add(Duration(days: 7));
                      break;
                  }

                  return expiry.isAfter(DateTime.now());
                }).toList();

                if (newsList.isEmpty) {
                  return Center(child: Text('No community news available'));
                }

                bool isExpanded = false; // State to track if container is expanded

                return StatefulBuilder(
                  builder: (context, setState) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: TColors.bubbleBlue, // Outer container color
                          borderRadius: BorderRadius.circular(20), // Rounded corners
                        ),
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Container(
                              constraints: BoxConstraints(
                                maxHeight: isExpanded ? double.infinity : 380, // Expandable height
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: newsList.map((doc) {
                                    final newsType = doc['type_of_news_message'];
                                    final tagColor = newsType == 'Offer Help' ? TColors.teal : TColors.amber;
                                    final newsId = doc.id; // Document ID
                                    final postedUserId = doc['user_id'];
                                    final anonymityStatus = doc['anonymity_status'] ?? 'Public';
                                    final includeTelegram = doc['include_telegram'] ?? 'Yes';

                                    // Cross Reference
                                    return FutureBuilder<DocumentSnapshot>(
                                      future: _fetchUserRole(postedUserId),
                                      builder: (context, userSnapshot) {
                                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                                          return Center(child: CircularProgressIndicator());
                                        }
                                        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                                          return Container(); // Display nothing if user data is not found
                                        }

                                        final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                                        final username = userData?['Username'] ?? 'Unknown User';
                                        final userRole = userData?['Role'] ?? 'Unknown';

                                        return Dismissible(
                                          key: Key(newsId),
                                          direction: DismissDirection.endToStart,
                                          confirmDismiss: (direction) async {
                                            return await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor: TColors.cream,
                                                  title: Text('Delete Message'),
                                                  content: Text('Are you sure you want to delete this message?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop(false); // Cancel deletion
                                                      },
                                                      child: Text(
                                                        "Cancel",
                                                        style: TextStyle(color: TColors.textDark),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop(true); // Confirm deletion
                                                      },
                                                      child: Text(
                                                        "Delete",
                                                        style: TextStyle(color: TColors.amber),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          onDismissed: (direction) async {
                                            if (postedUserId == AuthenticatorRepository.instance.authUser?.uid) {
                                              await FirebaseFirestore.instance
                                                  .collection('community_news')
                                                  .doc(newsId)
                                                  .delete();
                                              Get.snackbar('Success', 'Message deleted successfully.',
                                                  backgroundColor: Colors.green, colorText: Colors.white);
                                            } else {
                                              Get.snackbar('Error', 'You can only delete your own messages.',
                                                  backgroundColor: Colors.red, colorText: Colors.white);
                                            }
                                          },
                                          // News Card Template
                                          background: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 20),
                                            alignment: Alignment.centerRight,
                                            child: Icon(Icons.delete, color: Colors.white),
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            constraints: BoxConstraints(minHeight: 100),
                                            margin: const EdgeInsets.only(bottom: 20),
                                            decoration: BoxDecoration(
                                              color: TColors.cream,
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(
                                                color: userRole == 'Support Organisation'
                                                    ? TColors.teal
                                                    : (userRole == 'Authority' ? TColors.stark_blue : Colors.transparent),
                                                width: 4.0,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.07),
                                                  spreadRadius: 2,
                                                  blurRadius: 10,
                                                  offset: Offset(0, 8),
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(20.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // News Message
                                                  Text(
                                                    doc['news_message'],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    softWrap: true,
                                                  ),
                                                  SizedBox(height: 10),
                                                  
                                                  // Display Attached Image (if exists)
                                                  if ((doc.data() as Map<String, dynamic>).containsKey('attached_image') &&
                                                      doc['attached_image'] != null &&
                                                      doc['attached_image'].toString().isNotEmpty)
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
                                                        child: Image.network(
                                                          doc['attached_image'],
                                                          fit: BoxFit.cover,
                                                          width: double.infinity,
                                                          errorBuilder: (context, error, stackTrace) {
                                                            return Center(
                                                              child: Text(
                                                                'Image failed to load',
                                                                style: TextStyle(
                                                                  color: Colors.red,
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),

                                                  SizedBox(height: 5),

                                                  // Username/Anonymity Information
                                                  Text(
                                                    anonymityStatus == 'Anonymous'
                                                        ? 'Posted by: Anonymous'
                                                        : (() {
                                                            if (userRole == 'Support Organisation') {
                                                              // Fetch organisation name
                                                              final organisationName = userData?['Organisation Name'] ?? 'Unknown Organisation';
                                                              return 'Posted by: $organisationName';
                                                            } else {
                                                              return 'Posted by: $username';
                                                            }
                                                          })(),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.normal,
                                                    ),
                                                  ),
                                                  SizedBox(height: 20),

                                                  // Bottom Action Row
                                                  Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        // Telegram Icon (Only if include_telegram is 'Yes')
                                                        if ((doc.data() as Map<String, dynamic>).containsKey('include_telegram') &&
                                                            doc['include_telegram'] == 'Yes')
                                                          GestureDetector(
                                                            onTap: () async {
                                                              if (userData != null) {
                                                                // Check for Telegram Handle across all collections
                                                                final telegramHandle = userData['telegramHandle'] ?? 
                                                                                      userData['Telegram Handle']; // Handles different key naming conventions
                                                                if (telegramHandle != null && telegramHandle.toString().isNotEmpty) {
                                                                  final url = "https://t.me/$telegramHandle";
                                                                  await launchUrl(Uri.parse(url));
                                                                } else {
                                                                  Get.snackbar(
                                                                    'Error',
                                                                    'Telegram handle not found',
                                                                    snackPosition: SnackPosition.BOTTOM,
                                                                  );
                                                                }
                                                              }
                                                            },
                                                            child: Image.asset(
                                                              'assets/icons/telegram.png',
                                                              height: 20,
                                                            ),
                                                          )
                                                        else
                                                          SizedBox(width: 20),

                                                        // Tags Row
                                                        Row(
                                                          children: [
                                                            // Role Tag
                                                            if (userRole == 'Support Organisation' || userRole == 'Authority')
                                                              Container(
                                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                decoration: BoxDecoration(
                                                                  color: userRole == 'Support Organisation'
                                                                      ? TColors.blush
                                                                      : TColors.stark_blue,
                                                                  borderRadius: BorderRadius.circular(15),
                                                                ),
                                                                child: Text(
                                                                  userRole, // Display the role
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 12,
                                                                  ),
                                                                ),
                                                              ),

                                                            const SizedBox(width: 5), // Spacing between tags

                                                            // Primary Tag (Offer Help/Need Help)
                                                            Container(
                                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                              decoration: BoxDecoration(
                                                                color: tagColor,
                                                                borderRadius: BorderRadius.circular(15),
                                                              ),
                                                              child: Text(
                                                                newsType,
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isExpanded = !isExpanded; // Toggle expand/collapse
                                });
                              },
                              child: Text(
                                isExpanded ? 'See less' : 'See more',
                                style: TextStyle(
                                  color: TColors.cream,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            // Post A Message (Button)
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 40),
              child: Center(
                child: TextButton(
                  onPressed: () => _showPostMessageModal(context),
                  style: TextButton.styleFrom(
                    backgroundColor: TColors.mustard,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.black, width: 2.0),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Iconsax.message_text, color: Colors.black, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Post A Message',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
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
  }
  
  void _showPostMessageModal(BuildContext context) {
    final TextEditingController messageController = TextEditingController();
    String selectedType = 'Offer Help';
    String selectedDuration = '1 Day';
    String anonymityStatus = 'Public';
    String includeTelegram = 'Yes';
    final String? userId = AuthenticatorRepository.instance.authUser?.uid;
    String? attachedImageUrl;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: TColors.cream,
              borderRadius: BorderRadius.circular(20),
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Text(
                      'Post a Message',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: messageController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Enter your message',
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      value: selectedType,
                      items: [
                        DropdownMenuItem(value: 'Offer Help', child: Text('Offer Help')),
                        DropdownMenuItem(value: 'Need Help', child: Text('Need Help')),
                      ],
                      onChanged: (String? newValue) {
                        selectedType = newValue!;
                      },
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      value: selectedDuration,
                      items: [
                        DropdownMenuItem(value: '1 Day', child: Text('1 Day')),
                        DropdownMenuItem(value: '3 Days', child: Text('3 Days')),
                        DropdownMenuItem(value: '1 Week', child: Text('1 Week')),
                      ],
                      onChanged: (String? newValue) {
                        selectedDuration = newValue!;
                      },
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      value: anonymityStatus,
                      items: [
                        DropdownMenuItem(value: 'Public', child: Text('Public')),
                        DropdownMenuItem(value: 'Anonymous', child: Text('Anonymous')),
                      ],
                      onChanged: (String? newValue) {
                        anonymityStatus = newValue!;
                      },
                    ),
                    SizedBox(height: 20),
                    // Label for Include Telegram Dropdown
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Want to Link Your Telegram?",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: TColors.textDark,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      value: includeTelegram,
                      items: [
                        DropdownMenuItem(value: 'Yes', child: Text('Yes')),
                        DropdownMenuItem(value: 'No', child: Text('No')),
                      ],
                      onChanged: (String? newValue) {
                        includeTelegram = newValue!;
                      },
                    ),
                    SizedBox(height: 20),
                    // Attach Image Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          attachedImageUrl != null ? 'Image Selected' : 'Attach an Image',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () async {
                            final result = await FilePicker.platform.pickFiles(type: FileType.image);
                            if (result != null && result.files.isNotEmpty) {
                              final path = result.files.first.path!;
                              try {
                                final imageUrl = await _uploadImageToFirebase(path);
                                setState(() {
                                  attachedImageUrl = imageUrl;
                                });
                                Get.snackbar('Success', 'Image uploaded successfully!',
                                    snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
                              } catch (e) {
                                Get.snackbar('Error', 'Failed to upload image.',
                                    snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
                              }
                            }
                          },
                          child: Text(
                            attachedImageUrl != null ? 'Change' : 'Attach',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColors.forest),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: TColors.bubbleOrange,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          try {
                            // === Sensitive Sentiment Detection Integration ===
                            final message = messageController.text;

                            // Call the backup method for sentiment detection
                            final isSensitive = await isMessageSensitiveWithDartSentiment(message);

                            if (isSensitive) {
                              Get.snackbar(
                                'Warning',
                                'Your message contains inappropriate content and cannot be posted.',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return; // Prevent further execution
                            }
                            // === End of Sensitive Sentiment Detection Integration ===

                            // Fetch the current user's role from all collections
                            String? userRole;

                            final userDoc = await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(userId)
                                .get();
                            if (userDoc.exists) {
                              userRole = userDoc.data()?['Role'];
                            } else {
                              final authorityDoc = await FirebaseFirestore.instance
                                  .collection('Authority')
                                  .doc(userId)
                                  .get();
                              if (authorityDoc.exists) {
                                userRole = 'Authority';
                              } else {
                                final supportOrgDoc = await FirebaseFirestore.instance
                                    .collection('SupportOrganisation')
                                    .doc(userId)
                                    .get();
                                if (supportOrgDoc.exists) {
                                  userRole = 'Support Organisation';
                                }
                              }
                            }

                            if (userRole == null) {
                              throw Exception('User role not found');
                            }

                            // Add the news message to the community_news collection
                            await FirebaseFirestore.instance.collection('community_news').add({
                              'news_message': messageController.text,
                              'type_of_news_message': selectedType,
                              'news_duration': selectedDuration,
                              'timestamp': Timestamp.now(),
                              'user_id': userId,
                              'anonymity_status': anonymityStatus,
                              'user_role': userRole,
                              'include_telegram': includeTelegram,
                              'attached_image': attachedImageUrl, // Add image URL
                            });

                            Get.snackbar('Success', 'Your message has been posted!',
                                backgroundColor: Colors.green, colorText: Colors.white);

                            Navigator.pop(context);
                          } catch (e) {
                            Get.snackbar('Error', 'Failed to post the message',
                                backgroundColor: Colors.red, colorText: Colors.white);
                          }
                        },
                        child: Text(
                          'Post',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Function to Upload Image to Firebase Storage
  Future<String> _uploadImageToFirebase(String filePath) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final firebaseStorageRef = FirebaseStorage.instance.ref().child('community_news_images/$fileName');
    await firebaseStorageRef.putFile(File(filePath));
    return await firebaseStorageRef.getDownloadURL();
  }

  // Helper Method to Fetch User Role
  Future<DocumentSnapshot<Object?>> _fetchUserRole(String userId) async {
    try {
      // Check "Users" collection
      DocumentSnapshot<Object?> userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(userId).get();
      if (userDoc.exists) return userDoc;

      // Check "Authority" collection
      DocumentSnapshot<Object?> authorityDoc =
          await FirebaseFirestore.instance.collection('Authority').doc(userId).get();
      if (authorityDoc.exists) return authorityDoc;

      // Check "SupportOrganisation" collection
      DocumentSnapshot<Object?> supportOrgDoc = await FirebaseFirestore.instance
          .collection('SupportOrganisation')
          .doc(userId)
          .get();
      if (supportOrgDoc.exists) return supportOrgDoc;

      // Return an empty DocumentSnapshot if no match is found
      return FirebaseFirestore.instance
          .collection('Users') // Or any default collection path
          .doc()
          .get(); // Return an empty document snapshot
    } catch (e) {
      print('Error fetching user role: $e');
      // Throw an exception if necessary or handle it appropriately
      throw Exception('Error fetching user role');
    }
  }

  // Sensitive Sentiment Detection Model using Moderation Endpoint
  // Future<bool> isMessageSensitive(String message) async {
  //   final apiKey = dotenv.env['OPENAI_API_KEY']; // Load API Key from .env
  //   final url = Uri.parse("https://api.openai.com/v1/moderations");

  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $apiKey',
  //       },
  //       body: jsonEncode({
  //         "model": "omni-moderation-latest", // Updated model for moderation
  //         "input": message,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final result = jsonDecode(response.body);

  //       // Extract the 'flagged' field
  //       final flagged = result['results'][0]['flagged'];
        
  //       // Log the response for debugging
  //       print('Moderation API Response: $result');

  //       return flagged; // Return if content is flagged
  //     } else {
  //       // Log API errors for debugging
  //       print('OpenAI API error: ${response.statusCode} - ${response.body}');
  //       return false; // Default to false on API failure
  //     }
  //   } catch (e) {
  //     // Log exceptions for debugging
  //     print('Error during OpenAI API call: $e');
  //     return false; // Default to false on exception
  //   }
  // }

  // Backup Sensitive Sentiment Detection using Dart Sentiment Package
  Future<bool> isMessageSensitiveWithDartSentiment(String message) async {
    final sentiment = Sentiment();
    final analysis = sentiment.analysis(message);

    // Example threshold for detecting sensitivity based on sentiment score
    final negativityThreshold = -0.5;

    print('Sentiment Analysis: $analysis'); // Log sentiment analysis details

    // Check if sentiment score is below the negativity threshold
    if (analysis['score'] <= negativityThreshold) {
      return true; // Mark the message as sensitive
    }

    return false; // Message is not sensitive
  }
}
