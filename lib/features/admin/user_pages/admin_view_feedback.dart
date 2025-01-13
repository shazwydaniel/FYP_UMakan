import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminFeedbackViewerPage extends StatefulWidget {
  const AdminFeedbackViewerPage({Key? key}) : super(key: key);

  @override
  State<AdminFeedbackViewerPage> createState() =>
      _AdminFeedbackViewerPageState();
}

class _AdminFeedbackViewerPageState extends State<AdminFeedbackViewerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: TColors.cream,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            const SizedBox(height: 60),
            Text(
              'Admin',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: dark ? Colors.black : Colors.black,
              ),
            ),
            Text(
              'Feedbacks',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: dark ? Colors.black : Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // Tabs Section
            TabBar(
              controller: _tabController,
              indicatorColor: TColors.teal,
              indicatorWeight: 3,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: "Unresolved"),
                Tab(text: "Resolved"),
              ],
            ),

            // StreamBuilder for both tabs
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Admins")
                    .doc("feedbacks")
                    .collection("userFeedbacks")
                    .orderBy("timestamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        _selectedTabIndex == 0
                            ? "No unresolved feedbacks yet."
                            : "No resolved feedbacks yet.",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: TColors.teal,
                        ),
                      ),
                    );
                  }

                  final allFeedbackDocs = snapshot.data!.docs;

                  // Filter feedback based on tab selection
                  final filteredFeedbackDocs = allFeedbackDocs.where((doc) {
                    final resolved = doc['resolved'] as bool;
                    return _selectedTabIndex == 0
                        ? !resolved // Unresolved tab
                        : resolved; // Resolved tab
                  }).toList();

                  if (filteredFeedbackDocs.isEmpty) {
                    return Center(
                      child: Text(
                        _selectedTabIndex == 0
                            ? "No unresolved feedbacks yet."
                            : "No resolved feedbacks yet.",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: TColors.teal,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: filteredFeedbackDocs.length,
                    itemBuilder: (context, index) {
                      final feedback = filteredFeedbackDocs[index];
                      final feedbackText = feedback['feedback'];
                      final username = feedback['username'];
                      final timestamp = feedback['timestamp'] as Timestamp;
                      final feedbackId = feedback.id;
                      final isResolved = feedback['resolved'] as bool;

                      return FeedbackCard(
                        username: username,
                        feedbackText: feedbackText,
                        date: timestamp.toDate(),
                        feedbackId: feedbackId,
                        isResolved: isResolved,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedbackCard extends StatelessWidget {
  final String username;
  final String feedbackText;
  final DateTime date;
  final String feedbackId;
  final bool isResolved;

  const FeedbackCard({
    Key? key,
    required this.username,
    required this.feedbackText,
    required this.date,
    required this.feedbackId,
    required this.isResolved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Section: Feedback Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  feedbackText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 10),
                Text(
                  "Submitted on: ${DateFormat('dd-MM-yyyy').format(date)} at ${DateFormat('hh:mm a').format(date)}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 91, 91, 91),
                  ),
                ),
              ],
            ),
          ),

          // Right Section: Popup Menu
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            color: TColors.cream,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            itemBuilder: (context) => isResolved
                ? [
                    PopupMenuItem(
                      value: 'unresolve',
                      child: Row(
                        children: const [
                          Icon(Icons.undo, color: Colors.orange),
                          SizedBox(width: 8),
                          Text("Unresolve Feedback"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: const [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text("Delete Feedback"),
                        ],
                      ),
                    ),
                  ]
                : [
                    PopupMenuItem(
                      value: 'resolve',
                      child: Row(
                        children: const [
                          Icon(Icons.check_circle, color: TColors.teal),
                          SizedBox(width: 8),
                          Text("Resolve Feedback"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: const [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text("Delete Feedback"),
                        ],
                      ),
                    ),
                  ],
            onSelected: (value) async {
              if (value == 'resolve') {
                await FirebaseFirestore.instance
                    .collection("Admins")
                    .doc("feedbacks")
                    .collection("userFeedbacks")
                    .doc(feedbackId)
                    .update({"resolved": true});

                Get.snackbar(
                  "Feedback Resolved",
                  "Feedback has been marked as resolved.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } else if (value == 'unresolve') {
                await FirebaseFirestore.instance
                    .collection("Admins")
                    .doc("feedbacks")
                    .collection("userFeedbacks")
                    .doc(feedbackId)
                    .update({"resolved": false});

                Get.snackbar(
                  "Feedback Unresolved",
                  "Feedback has been marked as unresolved.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
              } else if (value == 'delete') {
                _deleteFeedback(context, feedbackId);
              }
            },
          ),
        ],
      ),
    );
  }

  void _deleteFeedback(BuildContext context, String feedbackId) async {
    bool confirmDelete = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm Delete"),
            content:
                const Text("Are you sure you want to delete this feedback?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Delete"),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmDelete) {
      await FirebaseFirestore.instance
          .collection("Admins")
          .doc("feedbacks")
          .collection("userFeedbacks")
          .doc(feedbackId)
          .delete();
      Get.snackbar(
        "Deleted",
        "Feedback has been deleted.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
