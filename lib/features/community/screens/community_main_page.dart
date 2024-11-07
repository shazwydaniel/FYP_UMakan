// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:fyp_umakan/data/repositories/authentication/authentication_repository.dart";
import "package:fyp_umakan/utils/constants/colors.dart";
import "package:fyp_umakan/utils/helpers/helper_functions.dart";
import "package:get/get.dart";
import "package:get/get_core/src/get_main.dart";
import "../controllers/helping_organisation_controller.dart";
import "../models/helping_organisation_model.dart";
import "package:iconsax/iconsax.dart";

class CommunityMainPageScreen extends StatelessWidget {
  const CommunityMainPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    HelpingOrganisationController orgController = HelpingOrganisationController();

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
            // Helping Organisations (Label)
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
                    'Helping Organisations',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Fetch and display Helping Organisations (Firebase)
            FutureBuilder<List<HelpingOrganisation>>(
              future: orgController.fetchOrganisations(),
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
                        return Container(
                          height: 150,
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
                                        org.name,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        org.contact,
                                        style: TextStyle(
                                          color: TColors.bubbleOlive,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: TColors.bubbleOlive.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          org.location,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 0.0,
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 45,
                                    backgroundImage: AssetImage(org.imagePath),
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
                  return Container(); // Display nothing if no data is found
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
              stream: FirebaseFirestore.instance
                  .collection('community_news')
                  .snapshots(),
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

                return Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
                  child: Column(
                    children: newsList.map((doc) {
                      final newsType = doc['type_of_news_message'];
                      final color = newsType == 'Offer Help' ? TColors.teal : TColors.amber;
                      final newsId = doc.id; // Get the document ID
                      final postedUserId = doc['user_id'];

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('Users').doc(postedUserId).get(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                            return Text('Unknown User'); // Fallback if the user record is missing
                          }

                          final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                          final username = userData['Username'] ?? 'Unknown User'; // Fetch the 'Username' field

                          return Dismissible(
                            key: Key(newsId),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete Message'),
                                    content: Text('Are you sure you want to delete this message?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false); // Cancel deletion
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true); // Confirm deletion
                                        },
                                        child: Text('Delete'),
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
                            background: Container(
                              color: Colors.red,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              margin: const EdgeInsets.only(bottom: 10),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '"${doc['news_message']}"',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Posted by: $username',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
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
                );
              },
            ),
            // Post A Message (Button)
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 40),
              child: Center(
                child: OutlinedButton(
                  onPressed: () => _showPostMessageModal(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Post A Message',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Iconsax.message_text, color: Colors.white, size: 20),
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
    String anonymityStatus = 'Public'; // Default value
    final String? userId = AuthenticatorRepository.instance.authUser?.uid; // Get the current user ID

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
            child: Column(
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
                    fontSize: 18.0,
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
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: TColors.bubbleOrange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      try {
                        await FirebaseFirestore.instance.collection('community_news').add({
                          'news_message': messageController.text,
                          'type_of_news_message': selectedType,
                          'news_duration': selectedDuration,
                          'timestamp': Timestamp.now(),
                          'user_id': userId,
                          'anonymity_status': anonymityStatus, // Add anonymity status to Firebase
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
            ),
          ),
        );
      },
    );
  }
}
