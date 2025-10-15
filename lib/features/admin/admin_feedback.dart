import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/admin/controller/admin_controller.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';

class FeedbackPage extends StatelessWidget {
  final TextEditingController feedbackController = TextEditingController();
  final userController = Get.find<UserController>();
  final adminController = Get.put(AdminController());

  FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.forest,
      appBar: AppBar(
        backgroundColor: TColors.forest,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "UMakan App Feedback",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            const Text(
              "Write your feedback below:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),

            // Input card
            Card(
              color: TColors.cream,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.black12, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: TextField(
                  controller: feedbackController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Enter your feedback here...",
                    hintStyle: const TextStyle(color: Colors.black54),
                    filled: true,
                    fillColor: TColors.cream,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black26),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black26),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Submit button – match "Logout" style (outlined, rounded, icon on right)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  if (feedbackController.text.isEmpty) {
                    Get.snackbar(
                      "Error",
                      "Feedback cannot be empty",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  await FirebaseFirestore.instance
                      .collection("Admins")
                      .doc("feedbacks")
                      .collection("userFeedbacks")
                      .add({
                    "userId": userController.user.value.id,
                    "username": userController.user.value.username,
                    "feedback": feedbackController.text.trim(),
                    "timestamp": Timestamp.now(),
                    "resolved": false,
                  });

                  feedbackController.clear();

                  Get.snackbar(
                    "Thank you!",
                    "Your feedback has been submitted successfully.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black, width: 2.0),
                  backgroundColor: TColors.vermillion,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Submit Feedback",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Iconsax.send_2, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // List heading
            const Text(
              "Your Feedbacks:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),

            // List of feedbacks
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Admins")
                    .doc("feedbacks")
                    .collection("userFeedbacks")
                    .where("userId", isEqualTo: userController.user.value.id)
                    .orderBy("timestamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No feedbacks submitted yet.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: TColors.cream,
                        ),
                      ),
                    );
                  }

                  final feedbackDocs = snapshot.data!.docs;

                  return ListView.separated(
                    itemCount: feedbackDocs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final feedback = feedbackDocs[index];
                      final feedbackText = feedback['feedback'] as String;
                      final feedbackId = feedback.id;
                      final bool resolved = feedback['resolved'] == true;
                      final ts = (feedback['timestamp'] as Timestamp).toDate();

                      return Card(
                        color: TColors.cream,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Colors.black12, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top row: status pill + menu
                              Row(
                                children: [
                                  _StatusPill(resolved: resolved),
                                  const Spacer(),
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert, color: Colors.black),
                                    color: TColors.cream,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    itemBuilder: (context) => const [
                                      PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, color: Colors.teal, size: 18), // use TColors.teal if it's const
                                            SizedBox(width: 8),
                                            Text(
                                              'Edit',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete, color: Colors.red, size: 18),
                                            SizedBox(width: 8),
                                            Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    onSelected: (value) async {
                                      if (value == 'edit') {
                                        _editFeedback(context, feedbackId, feedbackText);
                                      } else if (value == 'delete') {
                                        _deleteFeedback(context, feedbackId);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Feedback text
                              Text(
                                feedbackText,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Timestamp
                              Text(
                                "Submitted on: ${DateFormat('dd-MM-yyyy, hh:mm a').format(ts)}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 91, 91, 91),
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
            ),
          ],
        ),
      ),
    );
  }

  // Delete
  void _deleteFeedback(BuildContext context, String feedbackId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: TColors.cream,
        title: const Text(
          "Confirm Delete",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure you want to delete this feedback?",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection("Admins")
                  .doc("feedbacks")
                  .collection("userFeedbacks")
                  .doc(feedbackId)
                  .delete();
              Navigator.pop(context);
              Get.snackbar(
                "Deleted",
                "Your feedback has been deleted.",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.black, width: 2.0),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  // Edit
  void _editFeedback(BuildContext context, String feedbackId, String currentFeedback) {
    final editController = TextEditingController(text: currentFeedback);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: TColors.cream,
        title: const Text(
          "Edit Feedback",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: 320,
          child: TextField(
            controller: editController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Update your feedback here...",
              filled: true,
              fillColor: Colors.white,
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black26),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black),
              ),
            ),
            style: const TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (editController.text.trim().isEmpty) {
                Get.snackbar(
                  "Feedback cannot be empty",
                  "Write a feedback",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }

              await FirebaseFirestore.instance
                  .collection("Admins")
                  .doc("feedbacks")
                  .collection("userFeedbacks")
                  .doc(feedbackId)
                  .update({
                "feedback": editController.text.trim(),
                "timestamp": Timestamp.now(),
              });

              Navigator.pop(context);

              Get.snackbar(
                "Updated",
                "Your feedback has been updated.",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool resolved;
  const _StatusPill({required this.resolved});

  @override
  Widget build(BuildContext context) {
    final bg = resolved ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2);
    final fg = resolved ? Colors.green.shade800 : Colors.red.shade800;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg, width: 1),
      ),
      child: Text(
        resolved ? "Resolved" : "Unresolved",
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}