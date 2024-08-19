import 'package:fyp_umakan/features/foodjournal/screen/food_journal_main_page.dart';
import 'package:fyp_umakan/features/moneyjournal/screens/money_journal_main_page.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class JournalController extends GetxController {
  final Rx<String> selectedJournal = ''.obs;

  void navigateToJournal(String journal) {
    selectedJournal.value = journal;
    if (journal == 'Money Journal') {
      Get.to(() => MoneyJournalMainPage());
    } else if (journal == 'Food Journal') {
      Get.to(() => FoodJournalMainPage());
    }
  }
}