import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/widgets/loaders/loaders.dart';
import 'package:fyp_umakan/data/repositories/food_journal/badge_repository.dart';
import 'package:fyp_umakan/data/repositories/money_journal/money_journal_repository.dart';
import 'package:fyp_umakan/data/repositories/user/user_repository.dart';
import 'package:fyp_umakan/features/authentication/controllers/homepage/recommendation_controller.dart';
import 'package:fyp_umakan/features/authentication/models/user_model.dart';
import 'package:fyp_umakan/features/authentication/screens/homepage/homepage.dart';
import 'package:fyp_umakan/features/authority/screens/authority_home_page.dart';
import 'package:fyp_umakan/features/vendor/screens/home/vendors_home.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;
  final userRepository = Get.put(UserRepository());
  final moneyJournalRepository = Get.put(MoneyJournalRepository());
  final BadgeRepository badgeRepo = Get.put(BadgeRepository());

  String get currentUserId => user.value.id;

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
    print('UserController initialized');
    print('Firebase Auth User ID: ${FirebaseAuth.instance.currentUser?.uid}');
  }

  Future<void> refreshUserData() async {
    try {
      await fetchUserRecord();
      await updateCalculatedFields();
      await calculateAndUpdateRecommendedAllowance();
      print('------- Page is refreshed! -------');
    } catch (e) {
      print('Error refreshing user data: $e');
    }
  }

  // Fetch User Record
  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final userFromDb = await userRepository.fetchUserDetails();

      if (userFromDb != null) {
        user(userFromDb);
        updateAge();
        updateStatus();

        // Calculate total expenses for the current month
        final totalExpenses = await moneyJournalRepository.calculateTotalExpensesForCurrentMonth(userFromDb.id);

        // Update User Model with Calculated additionalExpense
        user.update((u) {
            if (u != null) {
                u.additionalExpense = totalExpenses;

                // Recalculate actualRemainingFoodAllowance
                double monthlyAllowance = double.tryParse(u.monthlyAllowance) ?? 0.0;
                double monthlyCommittments = double.tryParse(u.monthlyCommittments) ?? 0.0;
                double additionalAllowance = u.additionalAllowance ?? 0.0;

                u.actualRemainingFoodAllowance = (monthlyAllowance + additionalAllowance) - (monthlyCommittments + totalExpenses);
            }
        });

        // Calculated Field
        await updateCalculatedFields();

        // MoneyJournalHistory
        await initializeMoneyJournalHistoryIfNeeded(userFromDb.id);
        // Sync current day’s data
        await syncCurrentDayData();
        // Start the daily scheduler
        startDailyUpdateScheduler();
        // Fetch Daily Log
        await fetchDailyLog();

        // Recommended Allowance (Dynamic - Daily)
        await calculateAndUpdateRecommendedAllowance();

        // Financial and Calorie Status 
        await initializeStatusSubcollections(userFromDb.id);
        // Sync Status
        await syncStatuses(userFromDb.id);

        // Setup User
        await setupUser(userFromDb.id);

        // Badges
        badgeRepo.initializeAchievements(currentUserId);
        badgeRepo.initializeMealStates(currentUserId);

        // Access RecommendationController lazily if needed
        final recommendationController = Get.put(RecommendationController());
        recommendationController; // Call only if needed

      } else {
        this.user(UserModel.empty());
        print('No user document found.');
      }
    } catch (e) {
      this.user(UserModel.empty());
      print('Error fetching user record: $e');
    } finally {
      profileLoading.value = false;
    }
  }

  // Method to Setup the Money Journal for a user ------------------------------------
  Future<void> setupUser(String userId) async {
    try {
      await moneyJournalRepository.initializeUserJournal(userId);
    } catch (e) {
      print('Error initializing user journal: $e');
    }
  }

  // Method to Add Expense ------------------------------------
  Future<void> addExpense(String userId, String expenseType,
      Map<String, dynamic> expenseData) async {
    try {
      // Add the expense
      await moneyJournalRepository.addExpense(userId, expenseType, expenseData);

      // Retrieve the price from the expenseData
      double price = double.tryParse(expenseData['price'].toString()) ?? 0.0;

      // Update the user model
      user.update((user) {
        if (user != null) {
          user.additionalExpense = (user.additionalExpense ?? 0.0) + price;
          print('Price: $price');
          print('Updated additionalExpense: ${user.additionalExpense}');
        }
      });

      // Save the updated user data back to Firestore
      await saveUserDetails();

      // Update calculated fields after adding expense
      await updateCalculatedFields();
    } catch (e) {
      print('Error adding expense: $e');
    }
  }

  // Method to Remove Expense ------------------------------------
  Future<void> removeExpense(String expenseId) async {
    final userId = currentUserId;
    try {
      await moneyJournalRepository.removeExpense(userId, expenseId);
    } catch (e) {
      print('Error removing expense: $e');
    }
  }

  // Method to Get Expenses ------------------------------------
  Future<List<Map<String, dynamic>>> getExpenses() async {
    try {
      final userId = currentUserId;
      return await moneyJournalRepository.getExpenses(userId);
    } catch (e) {
      print('Error fetching expenses: $e');
      return [];
    }
  }

  // Method to Calculate age from birthdate and update the user model ------------------------------------
  void updateAge() {
    final currentUser = user.value;

    if (currentUser.birthdate.isNotEmpty) {
      final birthDate = DateFormat('dd/MM/yyyy').parse(currentUser.birthdate);
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }

      user.update((user) {
        if (user != null) {
          user.age = age;
        }
      });
    }
  }

  // Method to calculate the status based on vehicle, maritalStatus, and childrenNumber ------------------------------------
  int calculateStatus() {
    int status = 0;
    final currentUser = user.value;

    // Check vehicle ownership
    if (currentUser.vehicle.toLowerCase().contains('yes')) {
      status += 1;
    } else if (currentUser.vehicle.toLowerCase().contains('no')) {
      status += 2;
    }

    // Check marital status
    if (currentUser.maritalStatus.toLowerCase() == 'married') {
      status += 3;
    } else if (currentUser.maritalStatus.toLowerCase() == 'single') {
      status += 1;
    }

    // Check number of children
    int children = int.tryParse(currentUser.childrenNumber) ?? 0;
    if (children > 0) {
      status += children;
    }

    return status;
  }

  // Method to Update the status and save it in the user model ------------------------------------
  void updateStatus() {
    user.update((user) {
      if (user != null) {
        user.status = calculateStatus();
      }
    });
  }

  // Method to Calculate User's BMR ------------------------------------
  double calculateBMR() {
    final weight = double.tryParse(user.value.weight) ??
        0.0; // Default to 0.0 if weight is null
    final height = double.tryParse(user.value.height) ??
        0.0; // Default to 0.0 if height is null
    final age = user.value.age ?? 0; // Default to 0 if age is null
    final gender = user.value.gender
        ?.toLowerCase(); // Convert gender to lowercase for consistency

    // Calculate BMR based on gender
    double bmr;
    if (gender == 'male') {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }

    return bmr;
  }

  // Method to Calculate and update the recommendedCalorieIntake, recommendedMoneyAllowance, and actualRemainingFoodAllowance ------------------------------------
  Future<void> updateCalculatedFields() async {
    final currentUser = user.value;

    // await fetchFinancialStatus(currentUser.id);
    // await fetchCalorieStatus(currentUser.id);

    // Convert String fields to double
    double monthlyAllowance = double.tryParse(currentUser.monthlyAllowance) ?? 0.0;
    double monthlyCommittments = double.tryParse(currentUser.monthlyCommittments) ?? 0.0;

    // Ensure additionalAllowance and additionalExpense are not null
    double additionalAllowance = currentUser.additionalAllowance ?? 0.0;
    double additionalExpense = currentUser.additionalExpense ?? 0.0;

    // Calculate Food Money
    double actualRemainingFoodAllowance = (monthlyAllowance + additionalAllowance) - (monthlyCommittments + additionalExpense);

    if (currentUser != null) {
      user.update((u) {
          if (u != null) {
              u.actualRemainingFoodAllowance = actualRemainingFoodAllowance;
          }
      });

      // Log the updated daily snapshot
      await logDailySnapshot();
    }

    // Calculate Recommended Daily Calories Intake
    double recommendedCalorieIntake = calculateBMR();

    // Calculate Recommended Monthly Budget Allocation for Food
    double recommendedMoneyAllowance = getFoodBudgetAllocation(currentUser.status) * monthlyAllowance;

    // Calculate Updated Recommended Allowance
    DateTime now = DateTime.now();
    int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    double dailyAllowance = recommendedMoneyAllowance / daysInMonth;
    int daysElapsed = now.day - 1;
    double updatedRecommendedAllowance = recommendedMoneyAllowance - (daysElapsed * dailyAllowance);

    // Ensure allowance does not go below zero
    updatedRecommendedAllowance = updatedRecommendedAllowance < 0 ? 0 : updatedRecommendedAllowance;

    // Calculate financial status using updatedRecommendedAllowance
    String financialStatus = calculateFinancialStatus(actualRemainingFoodAllowance, updatedRecommendedAllowance);
    await updateFinancialStatus(currentUser.id, financialStatus);

    // Update the user model with the calculated values
    user.update((user) {
      if (user != null) {
        user.recommendedCalorieIntake = recommendedCalorieIntake;
        user.recommendedMoneyAllowance = recommendedMoneyAllowance;
        user.actualRemainingFoodAllowance = actualRemainingFoodAllowance;
        user.updatedRecommendedAllowance = updatedRecommendedAllowance;
        user.additionalExpense = additionalExpense;
        user.additionalAllowance = additionalAllowance;

        print(
            'Updated actualRemainingFoodAllowance with new formula: ${user.actualRemainingFoodAllowance}');
      }
    });

    // Save the updated user data back to Firestore
    await userRepository.updateUserDetails(user.value);
  }

  // Logic for daily calorie intake based on gender and age ------------------------------------
  double getDailyCaloriesIntake(String gender, int age) {
    if (gender.toLowerCase() == "male") {
      if (age >= 14 && age <= 18) {
        return 2533;
      } else if (age >= 19 && age <= 30) {
        return 2667;
      } else if (age >= 31 && age <= 50) {
        return 2467;
      } else if (age > 50) {
        return 2200;
      }
    } else if (gender.toLowerCase() == "female") {
      if (age >= 14 && age <= 18) {
        return 2067;
      } else if (age >= 19 && age <= 30) {
        return 2067;
      } else if (age >= 31 && age <= 50) {
        return 2000;
      } else if (age > 50) {
        return 1800;
      }
    }
    return 0.0; // Default or fallback value
  }

  // Logic for food budget allocation based on status ------------------------------------
  double getFoodBudgetAllocation(int status) {
    switch (status) {
      case 1:
        return 0.36; // Single PTU
      case 2:
        return 0.2346; // Single Car Owner
      case 3:
        return 0.2073; // Married (w/o Children)
      case 4:
        return 0.2375; // Married (1 Child)
      case 5:
        return 0.2453; // Married (2 Children)
      case 6:
        return 0.2236; // Single Parent (1 Child)
      case 7:
        return 0.2354; // Single Parent (2 Children)
      default:
        return 0.0; // Default or fallback value
    }
  }

  // Method to Save the updated user details to Firestore ------------------------------------
  Future<void> saveUserDetails() async {
    try {
      print('Saving additionalAllowance: ${user.value.additionalAllowance}');
      print('Saving additionalExpense: ${user.value.additionalExpense}');
      await userRepository.updateUserDetails(user.value);
    } catch (e) {
      print('Error saving user details: $e');
    }
  }

  // Method to Update Financial Status in Firebase ------------------------------------
  Future<void> updateFinancialStatus(String userId, String status) async {
    try {
      final userRef = _firestore
          .collection('Users')
          .doc(userId)
          .collection('financial_status');

      // Update the "current" document
      await userRef.doc('current').set({
        'status': status,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Also update the "status" document
      await userRef.doc('status').update({
        'status': status,
      });

      print("Financial status updated: $status");
    } catch (e) {
      print("Error updating financial status: $e");
    }
  }

  // Method to Update Calorie Intake Status in Firebase ------------------------------------
  Future<void> updateCalorieIntakeStatus(
      String userId, String status, double totalCalories) async {
    try {
      final userRef = _firestore
          .collection('Users')
          .doc(userId)
          .collection('calorie_intake_status');

      // Update the "current" document
      await userRef.doc('current').set({
        'status': status,
        'total_calories_logged': totalCalories,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Also update the "status" document
      await userRef.doc('status').update({
        'status': status,
      });

      print("Calorie intake status updated: $status");
    } catch (e) {
      print("Error updating calorie intake status: $e");
    }
  }

  // Method to Sync Financial and Calorie Status ------------------------------------
  Future<void> syncStatuses(String userId) async {
    try {
      final userRef = _firestore.collection('Users').doc(userId);

      // Fetch financial status from "current"
      final financialCurrent =
          await userRef.collection('financial_status').doc('current').get();
      final financialStatus = financialCurrent.data()?['status'];

      if (financialStatus != null) {
        // Sync to "status" document
        await userRef.collection('financial_status').doc('status').update({
          'status': financialStatus,
        });
      }

      // Fetch calorie intake status from "current"
      final calorieCurrent = await userRef
          .collection('calorie_intake_status')
          .doc('current')
          .get();
      final calorieStatus = calorieCurrent.data()?['status'];

      if (calorieStatus != null) {
        // Sync to "status" document
        await userRef.collection('calorie_intake_status').doc('status').update({
          'status': calorieStatus,
        });
      }

      print("Statuses synchronized successfully.");
    } catch (e) {
      print("Error synchronizing statuses: $e");
    }
  }

  // Method to Calculate Financial Status ------------------------------------
  String calculateFinancialStatus(
      double actualRemaining, double recommendedAllowance) {
    if (actualRemaining >= recommendedAllowance * 1.2) {
      return "Surplus";
    } else if (actualRemaining >= recommendedAllowance * 0.9) {
      return "Moderate";
    } else {
      return "Deficit";
    }
  }

  // Method to Calculate Calorie Status ------------------------------------
  String calculateCalorieStatus(
      double totalCalories, double recommendedIntake) {
    if (totalCalories < recommendedIntake * 0.9) {
      return "Deficit";
    } else if (totalCalories <= recommendedIntake * 1.1) {
      return "Met Target";
    } else {
      return "Overconsumed";
    }
  }

  // Method to Initialise Status Subcollections ------------------------------------
  Future<void> initializeStatusSubcollections(String userId) async {
    try {
      print('Initializing status subcollections for user: $userId');

      final userRef =
          FirebaseFirestore.instance.collection('Users').doc(userId);

      // Financial Status Subcollection
      final financialStatusDoc =
          userRef.collection('financial_status').doc('status');
      final financialStatusSnapshot = await financialStatusDoc.get();

      if (!financialStatusSnapshot.exists) {
        await financialStatusDoc.set({
          'status': 'Moderate', // Default status
          'actualRemainingFoodAllowance': 0.0, // Initialize with 0
          'recommendedMoneyAllowance': 0.0, // Initialize with 0
        });
        print('Financial Status Subcollection initialized for user: $userId');
      } else {
        print(
            'Financial Status Subcollection already exists for user: $userId');
      }

      // Calorie Intake Status Subcollection
      final calorieIntakeDoc =
          userRef.collection('calorie_intake_status').doc('status');
      final calorieIntakeSnapshot = await calorieIntakeDoc.get();

      if (!calorieIntakeSnapshot.exists) {
        await calorieIntakeDoc.set({
          'status': 'Met Target', // Default status
          'totalCaloriesLogged': 0.0, // Initialize with 0
          'recommendedCalorieIntake': 0.0, // Initialize with 0
        });
        print(
            'Calorie Intake Status Subcollection initialized for user: $userId');
      } else {
        print(
            'Calorie Intake Status Subcollection already exists for user: $userId');
      }

      // Money Journal Subcollection
      final moneyJournalCollection = userRef.collection('money_journal');
      final moneyJournalSnapshot = await moneyJournalCollection.limit(1).get();

      if (moneyJournalSnapshot.size == 0) {
        await moneyJournalCollection.doc('example').set({
          'itemName': 'Example Item',
          'price': 0.0,
          'date': FieldValue.serverTimestamp(),
          'type': 'Food', // Example entry
        });
        print('Money Journal Subcollection initialized for user: $userId');
      } else {
        print('Money Journal Subcollection already exists for user: $userId');
      }

      // Food Journal Subcollection
      final foodJournalCollection = userRef.collection('food_journal');
      final foodJournalSnapshot = await foodJournalCollection.limit(1).get();

      if (foodJournalSnapshot.size == 0) {
        await foodJournalCollection.doc('example').set({
          'itemName': 'Example Food',
          'calories': 0.0,
          'date': FieldValue.serverTimestamp(),
        });
        print('Food Journal Subcollection initialized for user: $userId');
      } else {
        print('Food Journal Subcollection already exists for user: $userId');
      }
    } catch (e) {
      print('Error initializing subcollections: $e');
    }
  }

  // Method to update user preferences in Firebase ------------------------------------
  Future<void> updateUserPreferences() async {
    try {
      // Fetch the current user ID
      final String userId = user.value.id ?? '';

      if (userId.isEmpty) {
        throw Exception("User ID is not available.");
      }

      // Update the preferences in the Firestore `users` collection
      await _firestore.collection('users').doc(userId).update({
        'prefSpicy': user.value.prefSpicy,
        'prefVegetarian': user.value.prefVegetarian,
        'prefLowSugar': user.value.prefLowSugar,
      });

      // Notify the user of success
      Get.snackbar(
        'Preferences Updated',
        'Your preferences have been successfully updated.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      // Handle any errors and notify the user
      Get.snackbar(
        'Error',
        'Failed to update preferences: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Method to Update Telegram Handle Locally ------------------------------------
  void updateTelegramHandle(String handle) {
    user.update((user) {
      if (user != null) {
        user.telegramHandle = handle;
      }
    });
  }

  // Method to Save Telegram Handle to Firestore ------------------------------------
  Future<void> saveTelegramHandle() async {
    try {
      if (user.value.id.isEmpty) {
        throw Exception("User ID is empty. Cannot save Telegram handle.");
      }
      await userRepository.updateSingleField({
        'telegramHandle': user.value.telegramHandle ?? '',
      });
      print("Telegram handle updated successfully.");
    } catch (e) {
      print("Error saving Telegram handle: $e");
      throw Exception("Failed to save Telegram handle.");
    }
  }

  // Method to calculate and update updatedRecommendedAllowance ------------------------------------
  Future<void> calculateAndUpdateRecommendedAllowance() async {
    try {
      final currentUser = user.value;

      if (currentUser.recommendedMoneyAllowance <= 0.0) {
        print("Recommended Money Allowance is not set or is zero.");
        return;
      }

      DateTime now = DateTime.now();
      int daysInMonth = DateTime(now.year, now.month + 1, 0).day;

      // Calculate daily allowance and the days elapsed in the current month
      double dailyAllowance =
          currentUser.recommendedMoneyAllowance / daysInMonth;
      int daysElapsed = now.day - 1;

      // Calculate the updated recommended allowance
      double updatedAllowance = currentUser.recommendedMoneyAllowance -
          (daysElapsed * dailyAllowance);

      // Ensure the allowance doesn't go below zero
      updatedAllowance = updatedAllowance < 0 ? 0 : updatedAllowance;

      // Update the user model locally
      user.update((user) {
        if (user != null) {
          user.updatedRecommendedAllowance = updatedAllowance;
        }
      });

      // Save the updated value to Firestore
      await userRepository.updateSingleField({
        'updatedRecommendedAllowance': updatedAllowance,
      });

      print("Updated Recommended Allowance: $updatedAllowance");
    } catch (e) {
      print("Error calculating updated recommended allowance: $e");
    }
  }

  // Method to Fetch Daily Log ------------------------------------
  Future<void> fetchDailyLog() async {
    try {
        final dailyLog = await userRepository.getLastLoggedData(currentUserId);

        if (dailyLog.isNotEmpty) {
            user.update((u) {
                if (u != null) {
                    u.additionalAllowance = dailyLog['additionalAllowance'] ?? 0.0;
                    u.additionalExpense = dailyLog['additionalExpense'] ?? 0.0;
                    u.actualRemainingFoodAllowance = dailyLog['actualRemainingFoodAllowance'] ?? 0.0;
                }
            });
            print('Daily log fetched and applied: $dailyLog');
        } else {
            print('No daily log available. Starting fresh.');
        }
    } catch (e) {
        print('Error fetching daily log: $e');
    }
  }

  // Method to Log Daily Snapshot ------------------------------------
  Future<void> logDailySnapshot() async {
    try {
        final currentUser = user.value;

        if (currentUser != null) {
            final dailyData = {
                'monthlyAllowance': currentUser.monthlyAllowance,
                'monthlyCommittments': currentUser.monthlyCommittments,
                'additionalAllowance': currentUser.additionalAllowance,
                'additionalExpense': currentUser.additionalExpense,
                'actualRemainingFoodAllowance': currentUser.actualRemainingFoodAllowance,
                'recommendedMoneyAllowance': currentUser.recommendedMoneyAllowance,
                'updatedRecommendedAllowance': currentUser.updatedRecommendedAllowance,
            };

            await userRepository.logDailyData(currentUserId, dailyData);
            print('Daily snapshot logged: $dailyData');
        }
    } catch (e) {
        print('Error logging daily snapshot: $e');
    }
  }

  // Method to Initialize MoneyJournalHistory ------------------------------------
  Future<void> initializeMoneyJournalHistoryIfNeeded(String userId) async {
    try {
        final userDoc = await _firestore.collection('Users').doc(userId).get();

        // Check if the flag exists or is set to false
        if (userDoc.exists && !(userDoc.data()?['isMoneyJournalInitialized'] ?? false)) {
            final now = DateTime.now();
            final year = now.year.toString();
            final month = now.month.toString().padLeft(2, '0');
            final day = now.day.toString().padLeft(2, '0');

            // Default values for the first day
            final initialData = {
                'monthlyAllowance': 0.0,
                'monthlyCommittments': 0.0,
                'additionalAllowance': 0.0,
                'additionalExpense': 0.0,
                'actualRemainingFoodAllowance': 0.0,
                'recommendedMoneyAllowance': 0.0,
                'updatedRecommendedAllowance': 0.0,
            };

            // Initialize the MoneyJournalHistory subcollection
            await _firestore
                .collection('Users')
                .doc(userId)
                .collection('MoneyJournalHistory')
                .doc(year)
                .collection('Months')
                .doc(month)
                .collection('Days')
                .doc(day)
                .set(initialData);

            // Update the flag to true
            await _firestore.collection('Users').doc(userId).update({
                'isMoneyJournalInitialized': true,
            });

            print('MoneyJournalHistory initialized for user: $userId');
        } else {
            print('MoneyJournalHistory already initialized for user: $userId');
        }
    } catch (e) {
        print('Error initializing MoneyJournalHistory: $e');
    }
  }

  // Daily Scheduler ------------------------------------
  void startDailyUpdateScheduler() {
    DateTime lastLoggedDate = DateTime.now();

    Timer.periodic(Duration(minutes: 1), (timer) async {
        DateTime currentDate = DateTime.now();
        
        // Check if the date has changed
        if (currentDate.day != lastLoggedDate.day) {
            print("Date has changed. Logging new day's data.");
            
            // Log the current values into the new day's log
            await logNewDayData();
            
            // Update the last logged date
            lastLoggedDate = currentDate;
        }
    });
  }

  // Method to Log a New Day’s Data ------------------------------------
  Future<void> logNewDayData() async {
    try {
        final currentUser = user.value;
        final now = DateTime.now();
        final year = now.year.toString();
        final month = now.month.toString().padLeft(2, '0');
        final day = now.day.toString().padLeft(2, '0');

        final dailyData = {
            'monthlyAllowance': currentUser.monthlyAllowance,
            'monthlyCommittments': currentUser.monthlyCommittments,
            'additionalAllowance': currentUser.additionalAllowance,
            'additionalExpense': currentUser.additionalExpense,
            'actualRemainingFoodAllowance': currentUser.actualRemainingFoodAllowance,
            'recommendedMoneyAllowance': currentUser.recommendedMoneyAllowance,
            'updatedRecommendedAllowance': currentUser.updatedRecommendedAllowance,
        };

        await userRepository.logDailyData(currentUserId, dailyData);
        print("New day's data logged: $dailyData");
    } catch (e) {
        print("Error logging new day's data: $e");
    }
  }

  // Method to Sync Current Day’s Data ------------------------------------
  Future<void> syncCurrentDayData() async {
    try {
        final currentUser = user.value;
        final now = DateTime.now();
        final year = now.year.toString();
        final month = now.month.toString().padLeft(2, '0');
        final day = now.day.toString().padLeft(2, '0');

        final dailyData = {
            'monthlyAllowance': currentUser.monthlyAllowance,
            'monthlyCommittments': currentUser.monthlyCommittments,
            'additionalAllowance': currentUser.additionalAllowance,
            'additionalExpense': currentUser.additionalExpense, // Use the dynamically calculated value
            'actualRemainingFoodAllowance': currentUser.actualRemainingFoodAllowance,
            'recommendedMoneyAllowance': currentUser.recommendedMoneyAllowance,
            'updatedRecommendedAllowance': currentUser.updatedRecommendedAllowance,
        };

        await userRepository.logDailyData(currentUserId, dailyData);
        print("Current day's data synced: $dailyData");
    } catch (e) {
        print("Error syncing current day's data: $e");
    }
  }


}
