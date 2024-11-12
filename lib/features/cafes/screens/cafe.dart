import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/authentication/controllers/homepage/journal_controller.dart';
import 'package:fyp_umakan/features/discover/controller/discover_controller.dart';
import 'package:fyp_umakan/features/foodjournal/controller/food_journal_controller.dart';
import 'package:fyp_umakan/features/foodjournal/model/journal_model.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
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
      backgroundColor: TColors.mustard,
      appBar: AppBar(
        backgroundColor: TColors.mustard,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cafe.name,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Obx(() {
              if (cafeController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (cafeController.menuItems.isEmpty) {
                return Center(child: Text('No menu items available'));
              }
              return Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: ListView.builder(
                  shrinkWrap: false,
                  itemCount: cafeController.menuItems.length,
                  itemBuilder: (context, index) {
                    final item = cafeController.menuItems[index];
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: TColors.cream,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(item.itemName),
                          subtitle: Text('Calories: ${item.itemCalories}'),
                          trailing:
                              Text('\RM${item.itemPrice.toStringAsFixed(2)}'),
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Add Meal",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.close),
                                        color: Colors.black,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                  backgroundColor: TColors.cream,
                                  content: Text(
                                    'Do you want to add "${item.itemName}" to your journal?',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  actions: [
                                    Center(
                                      child: Container(
                                        width: 100,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: TColors.bubbleOrange,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            // Add selected item to the food journal
                                            final journalItem = JournalItem(
                                              '', // Image path or empty
                                              id: item.id,
                                              name: item.itemName,
                                              price: item.itemPrice,
                                              calories: item.itemCalories,
                                              cafe: cafe.name,
                                            );

                                            // Assuming userId is available
                                            String userId =
                                                FoodJournalController.instance
                                                    .getCurrentUserId();

                                            controller.addFoodToJournal(
                                                userId, journalItem);
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: Text(
                                            'ADD',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
