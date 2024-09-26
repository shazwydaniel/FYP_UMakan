import 'package:flutter/material.dart';

class AddMenuCategory extends StatelessWidget {
  AddMenuCategory({super.key});

  final TextEditingController categoryName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Add New Category")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: categoryName,
                decoration: InputDecoration(
                  labelText: "Category Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24.0),
              // Add Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // You can add the logic to handle the form submission here
                    String category = categoryName.text;

                    // Example of what to do with the data (could be saving to a database, etc.)
                    print('Item Added: $category');

                    // Close the page and return the entered data (optional)
                    Navigator.pop(context);
                  },
                  child: Text('Add Item'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
