import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/widgets/loaders/loaders.dart';
import 'package:fyp_umakan/data/repositories/money_journal/money_journal_repository.dart';
import 'package:fyp_umakan/data/repositories/user/user_repository.dart';
import 'package:fyp_umakan/features/authentication/models/user_model.dart';
import 'package:fyp_umakan/features/moneyjournal/screens/money_journal_main_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;
  final userRepository = Get.put(UserRepository());
  final moneyJournalRepository = Get.put(MoneyJournalRepository());

  String get currentUserId => user.value.id;

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  Future<void> refreshUserData() async {
    try {
      await fetchUserRecord();
      await updateCalculatedFields();
      print('------- Page is refreshed! -------');
    } catch (e) {
      print('Error refreshing user data: $e');
    }
  }

  // Fetch User Record
  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
      updateAge();
      updateStatus();
      await updateCalculatedFields();
      await setupUser(user.id);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  // Setup the Money Journal for a user
  Future<void> setupUser(String userId) async {
    try {
      await moneyJournalRepository.initializeUserJournal(userId);
    } catch (e) {
      print('Error initializing user journal: $e');
      // Handle any specific error handling you need here
    }
  }

  Future<void> addExpense(String userId, String expenseType,
      Map<String, dynamic> expenseData) async {
    try {
      // Add the expense
      await moneyJournalRepository.addExpense(userId, expenseType, expenseData);

      // Retrieve the price from the expenseData
      double price = double.tryParse(expenseData['price'].toString()) ?? 0.0;

      // Update the user model directly
      user.update((user) {
        if (user != null) {
          user.additionalExpense += price;

          // Print the updated allowance and price to the console
          print('Price: $price');
          print('Updated additionalExpense: ${user.additionalExpense}');
        }
      });

      // Save the updated user data back to Firestore
      await userRepository.updateUserDetails(user.value);
    } catch (e) {
      // Handle error
      print('Error adding expense: $e');
    }
  }

  Future<void> removeExpense(String expenseId) async {
    final userId = currentUserId;
    await moneyJournalRepository.removeExpense(userId, expenseId);
    // await refreshExpenses(); // Assuming you have a method to refresh the expense list after deletion
  }

  // Method to Get Expenses
  Future<List<Map<String, dynamic>>> getExpenses() async {
    try {
      final userId = currentUserId;
      return await moneyJournalRepository.getExpenses(userId);
    } catch (e) {
      print('Error fetching expenses: $e');
      return [];
    }
  }

  // Calculate age from birthdate and update the user model
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

  // Method to calculate the status based on vehicle, maritalStatus, and childrenNumber
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

  // Update the status and save it in the user model
  void updateStatus() {
    user.update((user) {
      if (user != null) {
        user.status = calculateStatus();
      }
    });
  }

  // Calculate and update the recommendedCalorieIntake, recommendedMoneyAllowance, and actualRemainingFoodAllowance
  Future<void> updateCalculatedFields() async {
    final currentUser = user.value;

    // Convert String fields to double
    double monthlyAllowance = double.tryParse(currentUser.monthlyAllowance) ?? 0.0;
    double monthlyCommittments = double.tryParse(currentUser.monthlyCommittments) ?? 0.0;

    // Ensure additionalAllowance and additionalExpense are not null
    double additionalAllowance = currentUser.additionalAllowance ?? 0.0;
    double additionalExpense = currentUser.additionalExpense ?? 0.0;

    // Calculate Recommended Daily Calories Intake
    double recommendedCalorieIntake = getDailyCaloriesIntake(currentUser.gender, currentUser.age);

    // Calculate Recommended Monthly Budget Allocation for Food
    double recommendedMoneyAllowance = getFoodBudgetAllocation(currentUser.status) * monthlyAllowance;

    // Calculate Actual Monthly Food Allocation
    double actualRemainingFoodAllowance = (monthlyAllowance + additionalAllowance) - (monthlyCommittments + additionalExpense);

    // Update the user model with the calculated values
    user.update((user) {
      if (user != null) {
        user.recommendedCalorieIntake = recommendedCalorieIntake;
        user.recommendedMoneyAllowance = recommendedMoneyAllowance;
        user.actualRemainingFoodAllowance = actualRemainingFoodAllowance;

        print('Updated actualRemainingFoodAllowance with new formula: ${user.actualRemainingFoodAllowance}');
      }
    });

    // Save the updated user data back to Firestore
    await saveUserDetails();
  }

  // Logic for daily calorie intake based on gender and age
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

  // Logic for food budget allocation based on status
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

  // Save the updated user details to Firestore
  Future<void> saveUserDetails() async {
    try {
      await userRepository.updateUserDetails(user.value);
    } catch (e) {
      // Handle error
    }
  }
}
