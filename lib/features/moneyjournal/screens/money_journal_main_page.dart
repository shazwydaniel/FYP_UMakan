// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import "package:flutter/material.dart";
import "package:fyp_umakan/features/student_management/controllers/user_controller.dart";
import "package:fyp_umakan/utils/constants/colors.dart";
import "package:fyp_umakan/utils/helpers/helper_functions.dart";
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";

class MoneyJournalMainPage extends StatelessWidget {
  const MoneyJournalMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    // Get instance Fix
    final controller = UserController.instance;

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
              child: Column(
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
                                  'Food Allowance Left',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'for this month',
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
                                    '7%',
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
                                      top: 30.0), // Adjust position
                                  child: Text(
                                    'RM',
                                    style: TextStyle(
                                      color: TColors.olive,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  '50',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 60,
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

                  // Next Allowance Reset (Card)
                  Container(
                    height: 150, // Height of the rectangle card
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: TColors.teal,
                      borderRadius: BorderRadius.circular(20),
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
                                  '1 September 2024',
                                  style: TextStyle(
                                    color: TColors.cream,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 15),
                                // Monthly Allowance (label)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: TColors.bubbleGreen.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Obx(
                                    () => Text(
                                      'RM' +
                                          controller
                                              .user.value.monthlyAllowance,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
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
                                  padding: const EdgeInsets.only(
                                      top: 30.0), // Adjust position
                                  child: Text(
                                    'days',
                                    style: TextStyle(
                                      color: TColors.cream,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  '10',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 60,
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
                ],
              ),
            ),
            // Today's Spending (Label)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4, // Thin vertical line width
                    height: 40, // Adjust the height as needed
                    color: TColors.teal,
                  ),
                  const SizedBox(width: 10), // Space between the line and text
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
            ),
            // Today's Spendings (Cards)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
              child: Column(
                children: [
                  // First Item (Card)
                  Container(
                    height: 100,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: TColors.cream,
                      borderRadius: BorderRadius.circular(20),
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
                                Text(
                                  'Chicken Chop',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'FSKTM',
                                  style: TextStyle(
                                    color: TColors.olive,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Item Price (label) - Positioned at the bottom right
                          Positioned(
                            bottom: -16.0,
                            right: 0,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30.0), // Adjust position
                                  child: Text(
                                    'RM',
                                    style: TextStyle(
                                      color: TColors.olive,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  '10',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 60,
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

                  // Second Item (Card)
                  Container(
                    height: 100,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: TColors.cream,
                      borderRadius: BorderRadius.circular(20),
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
                                Text(
                                  'Nasi Ayam Penyet',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'KK7',
                                  style: TextStyle(
                                    color: TColors.olive,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Item Price (label) - Positioned at the bottom right
                          Positioned(
                            bottom: -16.0,
                            right: 0,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30.0), // Adjust position
                                  child: Text(
                                    'RM',
                                    style: TextStyle(
                                      color: TColors.olive,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  '6',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 60,
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

                  // Third Item (Card)
                  Container(
                    height: 100,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: TColors.cream,
                      borderRadius: BorderRadius.circular(20),
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
                                Text(
                                  'Oden',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'KK MART',
                                  style: TextStyle(
                                    color: TColors.olive,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Item Price (label) - Positioned at the bottom right
                          Positioned(
                            bottom: -16.0,
                            right: 0,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30.0), // Adjust position
                                  child: Text(
                                    'RM',
                                    style: TextStyle(
                                      color: TColors.olive,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  '11',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 60,
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
                ],
              ),
            ),
            // Add Expense (Button)
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
                      child: TextField(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          hintText: 'Enter Cost',
                        ),
                        keyboardType: TextInputType.number,
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
                  child: TextField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      hintText: 'Enter Name',
                    ),
                        keyboardType: TextInputType.number,
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
                      value: 'Food', // Default value
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
                        // Handle the dropdown value change
                      },
                    ),
                ),
                SizedBox(height: 25),
                Container(
                  width: 120, // Adjust width of the button
                  height: 50, // Adjust height of the button
                  decoration: BoxDecoration(
                    color: TColors.bubbleOrange, // Background color
                    borderRadius: BorderRadius.circular(20.0), // Rounded corners
                    border: Border.all(
                      color: Colors.black, // Black border color
                      width: 2.0, // Border width
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      // Handle button press
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
}
