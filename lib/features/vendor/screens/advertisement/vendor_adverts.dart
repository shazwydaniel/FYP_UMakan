import 'package:flutter/material.dart';

class VendorAdverts extends StatelessWidget {
  VendorAdverts({super.key});
  final TextEditingController adName = TextEditingController();
  final TextEditingController adDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Advertisment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text Field for Item Name
            TextField(
              controller: adName,
              decoration: InputDecoration(
                labelText: 'Advertisment Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),

            // Text Field for Item Cost
            TextField(
              controller: adDescription,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Advertisement Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),

            // Add Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // You can add the logic to handle the form submission here
                  String name = adName.text;
                  String description = adDescription.text;

                  // Example of what to do with the data (could be saving to a database, etc.)
                  print('Item Added: $name, $description');

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
      ),
    );
  }
}
