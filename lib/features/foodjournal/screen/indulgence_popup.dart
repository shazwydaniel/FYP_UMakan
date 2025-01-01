import 'package:flutter/material.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';

class IndulgencePopup extends StatelessWidget {
  final String mealName;
  final String mealImage;

  const IndulgencePopup({
    Key? key,
    required this.mealName,
    required this.mealImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: TColors.cream,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Heads up!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border:
                    Border.all(color: Colors.black, width: 2), // Black border
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: mealImage.isNotEmpty
                    ? Image.network(
                        mealImage,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 150,
                        width: 150,
                        color: Colors.grey,
                        child: Icon(
                          Icons.fastfood,
                          color: Colors.orange,
                          size: 50,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "You've logged $mealName multiple times today.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              "Consider diversifying your meals for better nutrition.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.black,
                side: BorderSide(
                    color: Colors.black, // Border color of the button
                    width: 2.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "Close",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
