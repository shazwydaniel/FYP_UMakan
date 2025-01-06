import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditVendorPage extends StatelessWidget {
  final Map<String, dynamic> vendorData;

  EditVendorPage({required this.vendorData});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Initialize controllers with current vendor data
    _nameController.text = vendorData['Vendor Name'];
    _emailController.text = vendorData['Vendor Email'];
    _contactInfoController.text = vendorData['Contact Info'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${vendorData['Vendor Name']}'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Vendor Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Vendor Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Email is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactInfoController,
                decoration: InputDecoration(labelText: 'Contact Info'),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty
                    ? 'Contact Info is required'
                    : null,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await FirebaseFirestore.instance
                            .collection('Vendors')
                            .doc(vendorData[
                                'id']) // Ensure vendorData includes the ID
                            .update({
                          'Vendor Name': _nameController.text.trim(),
                          'Vendor Email': _emailController.text.trim(),
                          'Contact Info': _contactInfoController.text.trim(),
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Vendor updated successfully')),
                        );

                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Failed to update vendor: $e')),
                        );
                      }
                    }
                  },
                  child: Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
