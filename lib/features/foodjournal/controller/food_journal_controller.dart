import 'package:fyp_umakan/features/foodjournal/model/food_journal_model.dart';
import 'package:get/get.dart';

class FoodJournalController extends GetxController {
  var lunchItems = <FoodJournalItem>[].obs; // Observable list of lunch items

  void addLunchItem(FoodJournalItem item) {
    lunchItems.add(item); // Adds an item to the lunchItems list
  }
}
