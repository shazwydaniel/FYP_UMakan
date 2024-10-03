import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/authentication/controllers/homepage/journal_controller.dart';
import 'package:fyp_umakan/features/discover/controller/discover_controller.dart';
import 'package:fyp_umakan/features/foodjournal/controller/food_journal_controller.dart';
import 'package:fyp_umakan/features/foodjournal/model/journal_model.dart';
import 'package:get/get.dart';
import 'package:fyp_umakan/features/cafes/controller/cafe_controller.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/features/vendor/vendor_repository.dart';

class CafePage extends StatelessWidget {
  final CafeDetails cafe;
  final String vendorId;

  CafePage({required this.cafe, required this.vendorId, Key? key})
      : super(key: key);

  final FoodJournalController controller = Get.put(FoodJournalController());

  @override
  Widget build(BuildContext context) {
    final DiscoverController cafeController =
        Get.put(DiscoverController(VendorRepository()));

    // Fetch the menu items for this cafe using vendorId and cafeId
    cafeController.fetchMenuItems(vendorId, cafe.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(cafe.name),
      ),
      body: Obx(() {
        if (cafeController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (cafeController.menuItems.isEmpty) {
          return Center(child: Text('No menu items available'));
        }

        return ListView.builder(
          itemCount: cafeController.menuItems.length,
          itemBuilder: (context, index) {
            final item = cafeController.menuItems[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(item.itemName),
                subtitle: Text('Calories: ${item.itemCalories}'),
                trailing: Text('\RM${item.itemPrice.toStringAsFixed(2)}'),
                onTap: () async {
                  // Add selected item to the food journal

                  final journalItem = JournalItem(
                    '', // Provide an empty string or default image path
                    id: item.id, // Unique ID
                    name: item.itemName,
                    price: item.itemPrice,
                    calories: item.itemCalories,
                    cafe: cafe.name, // Cafe name
                  );

                  // Assuming userId is available, you can replace with the actual user ID
                  String userId =
                      FoodJournalController.instance.getCurrentUserId();

                  // Optionally, add the item to the local lunch list
                  controller.addFoodToJournal(userId, journalItem);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
