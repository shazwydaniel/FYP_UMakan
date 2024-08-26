import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/features/foodjournal/controller/food_journal_controller.dart';
import 'package:get/get.dart';

import '../../foodjournal/model/food_journal_model.dart';

class CafePage extends StatelessWidget {
  final CafeDetailsData cafe;
  final FoodJournalController foodJournalController =
      Get.find<FoodJournalController>();

  CafePage({
    super.key,
    required this.cafe,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cafe.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(cafe.logoPath),
            SizedBox(height: 16),
            Text(
              cafe.details,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Menu Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: cafe.items.length,
                itemBuilder: (context, index) {
                  final item = cafe.items[index];
                  return InkWell(
                    onTap: () {
                      // Create a new FoodJournalItem from the selected cafe item
                      final foodJournalItem = FoodJournalItem(
                        name: item.item,
                        price: item.price,
                        calories: item.calories,
                        imagePath: item.image,
                        cafe: item.location,
                      );
                      // Add the item to the lunch section using the controller
                      foodJournalController.addLunchItem(foodJournalItem);

                      // Provide feedback to the user, e.g., snackbar or toast
                      Get.snackbar('Item Added', '${item.item} added to Food');
                    },
                    child: ListTile(
                      leading: Image.asset(
                        item.image, // Path to the image asset
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                      title: Text(item.item),
                      subtitle: Text('${item.calories} calories'),
                      trailing: Text('\$${item.price.toStringAsFixed(2)}'),
                    ),
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
