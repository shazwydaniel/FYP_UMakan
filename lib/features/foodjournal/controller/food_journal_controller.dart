import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_umakan/data/repositories/food_journal/food_journal_repository.dart';
import 'package:fyp_umakan/features/foodjournal/model/journal_model.dart';
import 'package:get/get.dart';

class FoodJournalController extends GetxController {
  static FoodJournalController get instance => Get.find();
  final FoodJournalRepository _foodJournalRepo = FoodJournalRepository.instance;
  var lunchItems = <JournalItem>[].obs;

  void addToLunch(JournalItem item) {
    lunchItems.add(item);
    // Optionally save to persistent storage if needed, e.g., GetStorage.
  }

  Future<void> addFoodToJournal(String userId, JournalItem journalItem) async {
    try {
      // Convert the journalItem to a map (JSON)
      final foodData = journalItem.toJson();

      // Call the repository to add the item to Firestore
      await _foodJournalRepo.addFood(userId, foodData);

      // Show success message if needed
      Get.snackbar('Success', 'Item added to food journal');
    } catch (e) {
      // Handle errors and show appropriate message
      Get.snackbar('Error', 'Failed to add item: $e');
    }
  }

  // Fetch
  Future<void> fetchFoodJournalItems() async {
    try {
      // Fetch list of cafes from the repository
      final foodJournalList =
          await _foodJournalRepo.getFoodJournalItem(getCurrentUserId());

      // Check if cafes were found
      if (foodJournalList.isNotEmpty) {
        // Assign the fetched cafes to the observable list
        lunchItems.assignAll(foodJournalList);
        print("Items Food Journal fetched: ${lunchItems.length}");
      } else {
        print('No items found in Food Journal');
        lunchItems.clear(); // Optionally clear if no cafes are found
      }
    } catch (e) {
      print('Error fetching cafes: $e');
      lunchItems.clear(); // Handle error by clearing the list
    }
  }

  String getCurrentUserId() {
    // Get the current user from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (user != null) {
      // Return the user ID (UID)
      return user.uid;
    } else {
      // Handle the case when there is no user logged in
      throw Exception('No user is currently signed in');
    }
  }
}
