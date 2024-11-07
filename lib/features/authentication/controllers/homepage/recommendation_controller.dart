import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/features/foodjournal/model/journal_model.dart';
import 'package:fyp_umakan/features/foodjournal/screen/food_journal_main_page.dart';
import 'package:fyp_umakan/features/moneyjournal/screens/money_journal_main_page.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_register.dart';
import 'package:fyp_umakan/features/vendor/vendor_repository.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class RecommendationController extends GetxController {
  static RecommendationController get instance => Get.find();

  final userController = UserController.instance;
  final vendorRepo = VendorRepository.instance;

  Future<List<CafeItem>> getRecommendedList(int averageCalories) async {
    final foodMoney = userController.user.value.actualRemainingFoodAllowance;
    final vendorRepo = VendorRepository.instance;

    List<CafeItem> items = await vendorRepo.getAllItemsFromAllCafes();

    // Filter the items based on average calories and food budget
    List<CafeItem> recommendedItems = items.where((item) {
      return item.itemCalories <= averageCalories &&
          item.itemPrice <= foodMoney;
    }).toList();

    print('Average Calories :$averageCalories');
    print('Food Money : $foodMoney');
    print("Recommended items: $recommendedItems");
    print("Total items: ${recommendedItems.length}");

    return recommendedItems; // Return the list of recommended items
  }

  @override
  void onInit() {
    super.onInit();
  }
}
