// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:fyp_umakan/common/widgets/loaders/loaders.dart";
import "package:fyp_umakan/data/repositories/money_journal/money_journal_repository.dart";
import "package:fyp_umakan/features/authentication/controllers/homepage/journal_controller.dart";
import "package:fyp_umakan/features/student_management/controllers/user_controller.dart";
import "package:fyp_umakan/utils/constants/colors.dart";
import "package:fyp_umakan/utils/helpers/helper_functions.dart";
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import 'package:fyp_umakan/features/moneyjournal/controllers/money_journal_controller.dart';
import "package:intl/intl.dart";

class MoneyJournalMainPage extends StatelessWidget {
  const MoneyJournalMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    // Get instance Fix
    final controller = UserController.instance;
    final moneyJournalController = Get.put(MoneyJournalController());

    return Scaffold(
      backgroundColor: TColors.olive,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: dark ? TColors.olive : TColors.olive,
          elevation: 0,
          leading: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back,
                    color: dark ? Colors.white : Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          centerTitle: false,
          title: Container(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Container(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 0),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text and Description Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Money',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: dark ? Colors.white : Colors.white,
                            ),
                          ),
                          Text(
                            'Journal',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: dark ? Colors.white : Colors.white,
                            ),
                          ),
                          Text(
                            'Track and Log Your Expenses.',
                            style: TextStyle(
                              fontSize: 15,
                              color: dark ? Colors.white : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      // Icon
                      Padding(
                        padding: const EdgeInsets.only(top:15),
                        child: Icon(
                          Iconsax.money_recive,
                          size: 70,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Money Detail (Cards)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 30),
              child: Column(
                children: [
                  // Food Allowance Left (Card)
                  Container(
                    height: 150, // Height of the rectangle card
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: TColors.cream,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Stack(
                        children: [
                          // Left side text elements
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Title Text
                                Text(
                                  'Food Money',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'left for this month',
                                  style: TextStyle(
                                    color: TColors.olive,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: TColors.bubbleOlive.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '%',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Allowance Left (label) - Positioned at the bottom right
                          Positioned(
                            bottom: -10.0,
                            right: 0,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 25.0), // Adjust position
                                  child: Text(
                                    'RM',
                                    style: TextStyle(
                                      color: TColors.olive,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // Text(
                                //   '50',
                                //   style: TextStyle(
                                //     color: Colors.black,
                                //     fontSize: 60,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                Obx(
                                  () => Text(
                                    controller.user.value.actualRemainingFoodAllowance.toStringAsFixed(2),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Next Allowance Reset (Card)
                  Obx(() {
                    moneyJournalController.calculateDaysUntilReset(); // Update the countdown dynamically

                    return Container(
                      height: 150, // Height of the rectangle card
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: TColors.teal,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Stack(
                          children: [
                            // Left side text elements
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Title Text
                                  Text(
                                    'Next Allowance Reset!',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  // Allowance Reset Date (label)
                                  Text(
                                    '1 ${moneyJournalController.nextResetMonth.value} ${DateTime.now().year}',
                                    style: TextStyle(
                                      color: TColors.cream,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  // Monthly Allowance (label)
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: TColors.bubbleGreen.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Obx(() => Text(
                                      'RM${controller.user.value.monthlyAllowance}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                  ),
                                ],
                              ),
                            ),
                            // Days Counter (label) - Positioned at the bottom right
                            Positioned(
                              bottom: -10.0,
                              right: 0,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30.0), // Adjust position
                                    child: Text(
                                      'days',
                                      style: TextStyle(
                                        color: TColors.cream,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Obx(() => Text(
                                    '${moneyJournalController.daysUntilReset.value}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            // Today's Spending (Label with Total Expense)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
              child: Obx(() {
                if (controller.profileLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: controller.getExpenses(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 4, // Thin vertical line width
                            height: 40, // Adjust the height as needed
                            color: TColors.teal,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Today's Spending",
                            style: TextStyle(
                              fontSize: 16, // Adjust the font size as needed
                              fontWeight: FontWeight.normal,
                              color: dark ? Colors.white : Colors.white,
                            ),
                          ),
                        ],
                      );
                    }

                    final expenses = snapshot.data!;
                    final now = DateTime.now();
                    final todaysExpenses = expenses.where((expense) {
                      final createdAt = (expense['createdAt'] as Timestamp?)?.toDate();
                      return createdAt != null &&
                          createdAt.year == now.year &&
                          createdAt.month == now.month &&
                          createdAt.day == now.day;
                    }).toList();

                    final totalTodaySpending = todaysExpenses.fold<double>(
                      0.0,
                      (sum, item) => sum + (item['price'] ?? 0.0),
                    );

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4, // Thin vertical line width
                              height: 40, // Adjust the height as needed
                              color: TColors.teal,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Today's Spending",
                              style: TextStyle(
                                fontSize: 16, // Adjust the font size as needed
                                fontWeight: FontWeight.normal,
                                color: dark ? Colors.white : Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'RM ${totalTodaySpending.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: TColors.cream,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              Iconsax.money_send,
                              size: 18,
                              color: TColors.cream,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              }),
            ),
            // Retrieving Expense Items from Firebase - Today's Spending (Cards)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 20),
              child: Obx(() {
                if (controller.profileLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: controller.getExpenses(), // Fetch expenses
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text('No expenses found.'),
                      );
                    }

                    final expenses = snapshot.data!;
                    final now = DateTime.now();
                    final todaysExpenses = expenses.where((expense) {
                      final createdAt = (expense['createdAt'] as Timestamp?)?.toDate();
                      return createdAt != null && now.difference(createdAt).inHours < 24;
                    }).toList();

                    if (todaysExpenses.isEmpty) {
                      return Center(child: Text('No expenses found for today.'));
                    }

                    return Column(
                      children: todaysExpenses.map((expense) {
                        final createdAt = expense['createdAt'] ?? 'Unknown';
                        final price = (expense['price'] ?? '0').toString();
                        final itemName = expense['itemName'] ?? 'No item name';
                        final type = expense['type'] ?? 'Unknown';
                        final expenseID = expense['expense_ID'] ?? 'Unknown';

                        return Dismissible(
                          key: Key(expenseID),
                          direction: DismissDirection.endToStart,
                          background: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20.0),
                              color: TColors.amber,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: TColors.cream,
                                  title: Text(
                                    "Delete Confirmation",
                                    style: TextStyle(color: Colors.black, fontSize: 20),
                                  ),
                                  content: Text(
                                    "Are you sure you want to delete this expense?",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(color: TColors.textDark),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(color: TColors.amber),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onDismissed: (direction) async {
                            await controller.removeExpense(expenseID);
                            TLoaders.errorSnackBar(
                              title: 'Expense Deleted',
                              message: "Selected expense has been deleted!",
                            );
                          },
                          child: Container(
                            height: 100,
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: TColors.cream,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          itemName,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          type,
                                          style: TextStyle(
                                            color: TColors.darkGreen,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -16.0,
                                    right: 0,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 22.0),
                                          child: Text(
                                            'RM',
                                            style: TextStyle(
                                              color: TColors.darkGreen,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          price,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 50,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              }),
            ),
            // Yesterday's Spending (Label with Total Expense)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
              child: Obx(() {
                if (controller.profileLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: controller.getExpenses(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 4, // Thin vertical line width
                            height: 40, // Adjust the height as needed
                            color: TColors.bubbleOrange,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Yesterday's Spending",
                            style: TextStyle(
                              fontSize: 16, // Adjust the font size as needed
                              fontWeight: FontWeight.normal,
                              color: dark ? Colors.white : Colors.white,
                            ),
                          ),
                        ],
                      );
                    }

                    final expenses = snapshot.data!;
                    final yesterday = DateTime.now().subtract(const Duration(days: 1));
                    final yesterdayExpenses = expenses.where((expense) {
                      final createdAt = (expense['createdAt'] as Timestamp?)?.toDate();
                      return createdAt != null &&
                          createdAt.year == yesterday.year &&
                          createdAt.month == yesterday.month &&
                          createdAt.day == yesterday.day;
                    }).toList();

                    final totalYesterdaySpending = yesterdayExpenses.fold<double>(
                      0.0,
                      (sum, item) => sum + (item['price'] ?? 0.0),
                    );

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4, // Thin vertical line width
                              height: 40, // Adjust the height as needed
                              color: TColors.bubbleOrange,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Yesterday's Spending",
                              style: TextStyle(
                                fontSize: 16, // Adjust the font size as needed
                                fontWeight: FontWeight.normal,
                                color: dark ? Colors.white : Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'RM ${totalYesterdaySpending.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: TColors.cream,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              Iconsax.money_send,
                              size: 18,
                              color: TColors.cream,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              }),
            ),
            // Retrieving Expense Items from Firebase - Yesterday's Spending (Cards)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 20),
              child: Obx(() {
                if (controller.profileLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: controller.getExpenses(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No expenses found for yesterday.'));
                    }

                    final expenses = snapshot.data!;
                    final yesterday = DateTime.now().subtract(const Duration(days: 1));
                    final yesterdayExpenses = expenses.where((expense) {
                      final createdAt = (expense['createdAt'] as Timestamp?)?.toDate();
                      return createdAt != null &&
                          createdAt.year == yesterday.year &&
                          createdAt.month == yesterday.month &&
                          createdAt.day == yesterday.day;
                    }).toList();

                    if (yesterdayExpenses.isEmpty) {
                      return Center(
                        child: Text('No spending found for yesterday.'),
                      );
                    }

                    return Column(
                      children: yesterdayExpenses.map((expense) {
                        final itemName = expense['itemName'] ?? 'No item name';
                        final price = (expense['price'] ?? '0').toString();
                        final type = expense['type'] ?? 'Unknown';
                        final expenseID = expense['expense_ID'] ?? 'Unknown';

                        return Dismissible(
                          key: Key(expenseID),
                          direction: DismissDirection.endToStart,
                          background: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20.0),
                              color: TColors.amber,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: TColors.cream,
                                  title: Text(
                                    "Delete Confirmation",
                                    style: TextStyle(color: Colors.black, fontSize: 20),
                                  ),
                                  content: Text(
                                    "Are you sure you want to delete this expense?",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(color: TColors.textDark),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(color: TColors.amber),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onDismissed: (direction) async {
                            await controller.removeExpense(expenseID);
                            TLoaders.errorSnackBar(
                              title: 'Expense Deleted',
                              message: "Selected expense has been deleted!",
                            );
                          },
                          child: Container(
                            height: 100,
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: TColors.cream,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          itemName,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          type,
                                          style: TextStyle(
                                            color: TColors.darkGreen,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -16.0,
                                    right: 0,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 22.0),
                                          child: Text(
                                            'RM',
                                            style: TextStyle(
                                              color: TColors.darkGreen,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          price,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 50,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              }),
            ),
            // Spending History Section (Label)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    color: TColors.blush,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Spending History",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: dark ? Colors.white : Colors.white,
                      ),
                    ),
                  ),
                  // Filter Button
                  Theme(
                    data: Theme.of(context).copyWith(
                      popupMenuTheme: PopupMenuThemeData(
                        color: TColors.cream,
                      ),
                    ),
                    child: PopupMenuButton<String>(
                      icon: Container(
                        width: 50,
                        height: 35,
                        decoration: BoxDecoration(
                          color: TColors.bubbleOlive,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Iconsax.menu_board, color: Colors.white, size: 20),
                      ),
                      onSelected: (value) {
                        if (value == 'Date') {
                          print('Filter by Date selected');
                          // Add your logic to filter by date here
                        } else if (value == 'Expense Type') {
                          print('Filter by Expense Type selected');
                          // Add your logic to filter by expense type here
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 'Date',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Iconsax.calendar_1, color: TColors.bubbleOlive, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Date',
                                style: TextStyle(
                                  color: TColors.bubbleOlive,
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'Expense Type',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Iconsax.money_2, color: TColors.bubbleOlive, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Expense Type',
                                style: TextStyle(
                                  color: TColors.bubbleOlive,
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Grouping and Displaying Expenses by Date from Firebase - Spending History (Cards)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 0, bottom: 20),
              child: Obx(() {
                if (controller.profileLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: controller.getExpenses(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No expenses found in history.'));
                    }

                    final expenses = snapshot.data!;
                    final groupedExpenses = _groupExpensesByDate(
                      expenses.where((expense) {
                        final createdAt = (expense['createdAt'] as Timestamp?)?.toDate();
                        final yesterday = DateTime.now().subtract(const Duration(days: 1));
                        return createdAt == null ||
                            createdAt.year != yesterday.year ||
                            createdAt.month != yesterday.month ||
                            createdAt.day != yesterday.day;
                      }).toList(),
                    );

                    DateTime? lastMonth;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: groupedExpenses.entries.map((entry) {
                        final date = entry.key;
                        final items = entry.value;

                        // Calculate total spending for the day
                        final totalSpending = items.fold<double>(
                          0.0,
                          (sum, item) => sum + (item['price'] ?? 0.0),
                        );

                        // Check if we need to display a new month section
                        final currentMonth = DateTime(date.year, date.month);
                        final showMonthLabel = lastMonth == null || currentMonth != lastMonth;
                        if (showMonthLabel) lastMonth = currentMonth;

                        // Calculate total spending for the month
                        final totalMonthlySpending = groupedExpenses.entries
                            .where((e) =>
                                DateTime(e.key.year, e.key.month) == currentMonth)
                            .expand((e) => e.value)
                            .fold<double>(
                              0.0,
                              (sum, item) => sum + (item['price'] ?? 0.0),
                            );

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (showMonthLabel)
                            Container(
                              margin: const EdgeInsets.only(bottom: 20, top: 20),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: TColors.bubbleOlive.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Iconsax.quote_down,
                                        size: 22,
                                        color: TColors.blush,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        DateFormat('MMMM yyyy').format(currentMonth),
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: TColors.cream,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Text(
                                  //       'RM ${totalMonthlySpending.toStringAsFixed(2)}',
                                  //       style: TextStyle(
                                  //         fontSize: 18,
                                  //         fontWeight: FontWeight.bold,
                                  //         color: TColors.cream,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                            // Date and Total Spending Row
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('EEE, MMM d, yyyy').format(date),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: TColors.cream,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'RM ${totalSpending.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: TColors.cream,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Icon(
                                        Iconsax.money_send,
                                        size: 18,
                                        color: TColors.cream,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Expense Cards
                            ...items.map((expense) {
                              final itemName = expense['itemName'] ?? 'No item name';
                              final price = (expense['price'] ?? '0').toString();
                              final type = expense['type'] ?? 'Unknown';
                              final expenseID = expense['expense_ID'] ?? 'Unknown';

                              return Dismissible(
                                key: Key(expenseID),
                                direction: DismissDirection.endToStart,
                                background: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.only(right: 20.0),
                                    color: TColors.amber,
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                confirmDismiss: (direction) async {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: TColors.cream,
                                        title: Text(
                                          "Delete Confirmation",
                                          style: TextStyle(color: Colors.black, fontSize: 20),
                                        ),
                                        content: Text(
                                          "Are you sure you want to delete this expense?",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(color: TColors.textDark),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            child: Text(
                                              "Delete",
                                              style: TextStyle(color: TColors.amber),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                onDismissed: (direction) async {
                                  await controller.removeExpense(expenseID);
                                  TLoaders.errorSnackBar(
                                    title: 'Expense Deleted',
                                    message: "Selected expense has been deleted!",
                                  );
                                },
                                child: Container(
                                  height: 100,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    color: TColors.cream,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        offset: Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                itemName,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                type,
                                                style: TextStyle(
                                                  color: TColors.darkGreen,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          bottom: -16.0,
                                          right: 0,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 22.0),
                                                child: Text(
                                                  'RM',
                                                  style: TextStyle(
                                                    color: TColors.darkGreen,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                price,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 50,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        );
                      }).toList(),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      // Bottom Navbar
      bottomNavigationBar: BottomAppBar(
        color: TColors.darkGreen,
        shape: CircularNotchedRectangle(),
        notchMargin: 0.0,
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Iconsax.add_circle, color: TColors.cream, size: 40),
                      onPressed: () {
                        _showModal(context);
                      },
                    ),
                    // Text(
                    //   'Add Expense',
                    //   style: TextStyle(
                    //     color: TColors.cream,
                    //     fontSize: 12.0,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showModal(BuildContext context) {
    final TextEditingController priceController = TextEditingController();
    final TextEditingController itemNameController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    String selectedCategory = 'Non-Food';
    final MoneyJournalRepository repository = MoneyJournalRepository();

    final String userId = UserController.instance.currentUserId;

    showDialog(
      context: context,
      barrierDismissible: true, // Allows dismissal by tapping outside the dialog
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 500,
            width: 500,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: TColors.cream,
              borderRadius: BorderRadius.circular(20),
            ),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6, // Adjust max height as needed
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.black, size: 24),
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                  ),
                ),
                // Add content for your modal here
                Text(
                  'Add Expense',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30), // Spacing between the title and the input section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the Row horizontally
                  children: [
                    Text(
                      'RM',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10), // Spacing between the "RM" text and TextField
                    Container(
                      width: 150, // Adjust width as needed
                      child: 
                      // TextField(
                      //   keyboardType: TextInputType.number,
                      //   decoration: InputDecoration(
                      //     fillColor: Colors.white,
                      //     filled: true,
                      //     border: OutlineInputBorder(),
                      //     hintText: 'Enter Cost',
                      //   ),
                      // ),
                      TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter Cost',
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Name of Item',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10), // Spacing between the "Category" text and dropdown
                Container(
                  width: 300, // Adjust width as needed
                  child: 
                  // TextField(
                  //   decoration: InputDecoration(
                  //     fillColor: Colors.white,
                  //     filled: true,
                  //     border: OutlineInputBorder(),
                  //     hintText: 'Enter Name',
                  //   ),
                  // ),
                  TextField(
                    controller: itemNameController,
                    decoration: InputDecoration(
                      hintText: 'Item Name',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Category',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10), // Spacing between the "Category" text and dropdown
                Container(
                  width: 300, // Set custom width for the dropdown
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                    value: selectedCategory, // Default value
                    items: [
                      DropdownMenuItem(
                        value: 'Food',
                        child: Text('Food'),
                      ),
                      DropdownMenuItem(
                        value: 'Non-Food',
                        child: Text('Non-Food'),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      selectedCategory = newValue!; // Update the selected category
                    },
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  width: 120,
                  height: 50,
                  decoration: BoxDecoration(
                    color: TColors.bubbleOrange,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      try {
                        // Create the expense data
                        final expenseData = {
                          'price': double.parse(priceController.text),
                          'itemName': itemNameController.text,
                          // 'location': locationController.text,
                        };

                        print('----- Logging expense: $expenseData for category: $selectedCategory -----');

                        // Log the item
                        await UserController.instance.addExpense(
                          userId,
                          selectedCategory,
                          expenseData,
                        );

                        // Close the modal
                        // Navigator.pop(context);

                        // Success Message
                        TLoaders.successSnackBar( title: 'Expense Logged', message: "Your spending for today has been updated!.");

                        priceController.clear();
                        itemNameController.clear();

                        // Refresh the page
                        Get.off(() => const MoneyJournalMainPage(), preventDuplicates: false);
                      } catch (e) {
                        print('Error logging expense: $e');
                        TLoaders.errorSnackBar( title: 'Error Logging Expense', message: "Invalid Input");
                      }
                    },
                    child: Center(
                      child: Text(
                        'LOG ITEM',
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
            ),
          ),
        );
      },
    );
  }
  // Method to Group Expense by Date
  Map<DateTime, List<Map<String, dynamic>>> _groupExpensesByDate(List<Map<String, dynamic>> expenses) {
    final Map<DateTime, List<Map<String, dynamic>>> grouped = {};
    final now = DateTime.now();
    final currentDay = DateTime(now.year, now.month, now.day);

    for (var expense in expenses) {
      final createdAt = (expense['createdAt'] as Timestamp?)?.toDate();
      if (createdAt != null) {
        final dateKey = DateTime(createdAt.year, createdAt.month, createdAt.day);

        // Exclude current day's expenses
        if (dateKey == currentDay) {
          continue;
        }

        if (!grouped.containsKey(dateKey)) {
          grouped[dateKey] = [];
        }
        grouped[dateKey]?.add(expense);
      }
    }

    return grouped;
  }
}
