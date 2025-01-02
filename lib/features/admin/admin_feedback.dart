import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FeedbackPage extends StatelessWidget {
  final TextEditingController feedbackController = TextEditingController();
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.teal,
      appBar: AppBar(
        title: Text("Help/Feedback"),
        backgroundColor: TColors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Write your feedback below:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Enter your feedback here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: TColors.cream,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
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

                  // Submit feedback to Firebase
                  await FirebaseFirestore.instance
                      .collection("Admin")
                      .doc("feedbacks")
                      .collection("userFeedbacks")
                      .add({
                    "userId": userController.user.value.id,
                    "username": userController.user.value.username,
                    "feedback": feedbackController.text.trim(),
                    "timestamp": Timestamp.now(),
                  });

                  // Clear the text field
                  feedbackController.clear();

                  // Show success message
                  Get.snackbar(
                    "Thank you!",
                    "Your feedback has been submitted successfully.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(
                    color: TColors.cream, // Border color
                    width: 2, // Border width
                  ),
                ),
                child: Text(
                  "Submit Feedback",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: TColors.cream,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Your Feedbacks:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Admin")
                    .doc("feedbacks")
                    .collection("userFeedbacks")
                    .where("userId", isEqualTo: userController.user.value.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No feedbacks submitted yet.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: TColors.cream,
                        ),
                      ),
                    );
                  }

                  final feedbackDocs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: feedbackDocs.length,
                    itemBuilder: (context, index) {
                      final feedback = feedbackDocs[index];
                      final feedbackText = feedback['feedback'];
                      final feedbackId = feedback.id;

                      return Card(
                        color: TColors.cream,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                            title: Text(
                              feedbackText,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: Text(
                              "Submitted on: ${DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch((feedback['timestamp'] as Timestamp).millisecondsSinceEpoch))} at ${DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch((feedback['timestamp'] as Timestamp).millisecondsSinceEpoch))}",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: const Color.fromARGB(255, 91, 91, 91)),
                            ),
                            trailing: PopupMenuButton<String>(
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.black, // Icon color
                              ),
                              color: TColors.cream, // Popup background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Rounded corners for the popup
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit,
                                          color: TColors.teal), // Icon for Edit
                                      SizedBox(width: 8),
                                      Text(
                                        'Edit',
                                        style: TextStyle(
                                          color: Colors.black, // Text color
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete,
                                          color: Colors.red), // Icon for Delete
                                      SizedBox(width: 8),
                                      Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Colors.black, // Text color
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) async {
                                if (value == 'edit') {
                                  _editFeedback(
                                      context, feedbackId, feedbackText);
                                } else if (value == 'delete') {
                                  await FirebaseFirestore.instance
                                      .collection("Admin")
                                      .doc("feedbacks")
                                      .collection("userFeedbacks")
                                      .doc(feedbackId)
                                      .delete();
                                  Get.snackbar(
                                    "Deleted",
                                    "Your feedback has been deleted.",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                            )),
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

  void _editFeedback(
      BuildContext context, String feedbackId, String currentFeedback) {
    final editController = TextEditingController(text: currentFeedback);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: TColors.cream, // Dialog background color
        title: Text(
          "Edit Feedback",
          style: TextStyle(
            color: Colors.black, // Title text color
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: 300, // Set the fixed width for the dialog
          child: TextField(
            controller: editController,
            maxLines: 5,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: "Update your feedback here...",
              filled: true,
              fillColor: Colors.grey[200], // TextField background color
              hintStyle: TextStyle(color: Colors.grey), // Hint text color
            ),
            style: TextStyle(color: Colors.black), // Text color
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, // Text color
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text("Cancel"),
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
                  .collection("Admin")
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
              backgroundColor: TColors.teal, // Button background color
              foregroundColor: Colors.white, // Text color
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text("Update"),
          ),
        ],
      ),
    );
  }
}
