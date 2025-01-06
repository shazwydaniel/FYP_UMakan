import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_umakan/features/admin/detailsPage/Vendors/SubPages/admin_cafe_sub.dart';
import 'package:fyp_umakan/features/admin/detailsPage/Vendors/admin_vendor_cafe_edit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:get/get.dart';

class VendorDetailsPage extends StatefulWidget {
  final Map<String, dynamic> vendorData;

  VendorDetailsPage({required this.vendorData});

  @override
  _VendorDetailsPageState createState() => _VendorDetailsPageState();
}

class _VendorDetailsPageState extends State<VendorDetailsPage> {
  late Stream<QuerySnapshot> _cafeStream;
  final VendorController _vendorController = Get.put(VendorController());
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _cafeStream = FirebaseFirestore.instance
        .collection('Vendors')
        .doc(widget.vendorData['Id'])
        .collection('Cafe')
        .snapshots();
  }

  void _deleteCafe(String cafeId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Cafe'),
        content: const Text('Are you sure you want to delete this cafe?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance
            .collection('Vendors')
            .doc(widget.vendorData['Id'])
            .collection('Cafe')
            .doc(cafeId)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cafe deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete cafe: $e')),
        );
      }
    }
  }

  void _addCafePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Cafe'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _vendorController.cafeName,
                decoration: const InputDecoration(labelText: 'Cafe Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Name is required' : null,
              ),
              TextFormField(
                controller: _vendorController.cafeLocation,
                decoration: const InputDecoration(labelText: 'Cafe Location'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Location is required'
                    : null,
              ),
              TextFormField(
                controller: _vendorController.openingTime,
                decoration: const InputDecoration(labelText: 'Opening Time'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Opening time is required'
                    : null,
              ),
              TextFormField(
                controller: _vendorController.closingTime,
                decoration: const InputDecoration(labelText: 'Closing Time'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Closing time is required'
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  final cafeData = {
                    'cafeName': _vendorController.cafeName.text.trim(),
                    'cafeLocation': _vendorController.cafeLocation.text.trim(),
                    'openingTime': _vendorController.openingTime.text.trim(),
                    'closingTime': _vendorController.closingTime.text.trim(),
                    // Add more fields as needed
                  };

                  await _vendorController.addCafe(
                      widget.vendorData['Id'], null); // Pass imageUrl if needed

                  Navigator.pop(context); // Close the popup on success
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cafe added successfully')),
                  );
                } catch (e) {
                  Navigator.pop(context); // Close the popup on error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add cafe: $e')),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vendorData['Vendor Name'] ?? 'Vendor Details'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Cafes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _cafeStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No cafes found.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final cafeDoc = snapshot.data!.docs[index];
                    final cafeData = cafeDoc.data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(cafeData['cafeName'] ?? 'No Name'),
                        subtitle:
                            Text(cafeData['cafeLocation'] ?? 'No Location'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                // Navigate to Edit Cafe page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminVendorCafeEdit(
                                      cafeData: cafeData,
                                      vendorId: widget
                                          .vendorData['Id'], // Pass vendorId
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteCafe(cafeDoc.id),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CafeSubPage(
                                cafeId: cafeData['cafe_ID'],
                                vendorId: widget.vendorData['Id'],
                                cafeName: cafeData['cafeName'],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.orange,
        shape: const CircularNotchedRectangle(),
        notchMargin: 0.0,
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Iconsax.add_circle, color: Colors.white, size: 40),
                onPressed: () => _addCafePopup(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
