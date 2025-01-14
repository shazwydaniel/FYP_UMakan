import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/data/repositories/food_journal/food_journal_repository.dart';
import 'package:fyp_umakan/features/foodjournal/model/journal_model.dart';
import 'package:fyp_umakan/features/foodjournal/screen/food_journal_main_page.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';
import 'package:fyp_umakan/features/student_management/screens/badge_unlock_popup.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/image_strings.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/repositories/food_journal/badge_repository.dart';

class BadgeController extends GetxController {
  static BadgeController get instance => Get.find();

  final BadgeRepository badgeRepo = Get.put(BadgeRepository());
  final UserController userController = UserController.instance;

  @override
  void onInit() {
    super.onInit();
    ever(userController.user, (user) {
      if (user != null && user.id.isNotEmpty) {
        print(
            "User data is ready. Initializing setupUser for userId: ${user.id}");
        setupUser(user.id);
      } else {
        print("User data not ready yet.");
      }
    });
  }

  // Setup the Money Journal for a user
  Future<void> setupUser(String userId) async {
    try {
      await badgeRepo.initializeAchievements(userId);
      await badgeRepo.initializeMealStates(userId);
      await badgeRepo.initializeStreaks(userId);
    } catch (e) {
      print('Error initializing user journal: $e');
    }
  }
}
