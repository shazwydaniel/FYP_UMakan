import 'package:fyp_umakan/features/foodjournal/model/journal_model.dart';
import 'package:fyp_umakan/features/foodjournal/screen/food_journal_main_page.dart';
import 'package:fyp_umakan/features/moneyjournal/screens/money_journal_main_page.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class JournalController extends GetxController {
  final box = GetStorage(); //
  final Rx<String> selectedJournal = ''.obs;
  var lunchItems = <JournalItem>[].obs; // Observable list of lunch items

  @override
  void onInit() {
    super.onInit();
    // Load stored lunch items from GetStorage
    // Read the stored list of JSON objects
    List<dynamic>? storedItems = box.read<List<dynamic>>('lunchItems');

    if (storedItems != null) {
      // Convert the list of JSON objects back into JournalItem objects
      lunchItems.value =
          storedItems.map((json) => JournalItem.fromJson(json)).toList();
    }
  }

  void navigateToJournal(String journal) {
    selectedJournal.value = journal;
    if (journal == 'Money Journal') {
      Get.to(() => MoneyJournalMainPage());
    } else if (journal == 'Food Journal') {
      Get.to(() => FoodJournalMainPage());
    }
  }

  void addLunchItem(JournalItem item) {
    lunchItems.add(item); // Adds an item to the lunchItems list
    // Convert the list of lunchItems to a list of JSON objects
    List<Map<String, dynamic>> jsonList =
        lunchItems.map((item) => item.toJson()).toList();

    // Save the list to GetStorage
    box.write('lunchItems', jsonList);
  }
}
