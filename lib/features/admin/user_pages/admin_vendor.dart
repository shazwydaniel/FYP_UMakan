import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_umakan/features/admin/detailsPage/Vendors/admin_vendor_details.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:get/get.dart';

class AdminVendor extends StatefulWidget {
  @override
  _AdminVendor createState() => _AdminVendor();
}

class _AdminVendor extends State<AdminVendor> {
  late Stream<QuerySnapshot> _vendorsStream;
  final VendorController _vendorController = Get.put(VendorController());

  @override
  void initState() {
    super.initState();
    _vendorsStream =
        FirebaseFirestore.instance.collection('Vendors').snapshots();
  }

  void _deleteVendor(String vendorId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Vendor'),
        content: const Text('Are you sure you want to delete this vendor?'),
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
            .doc(vendorId)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vendor deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete vendor: $e')),
        );
      }
    }
  }

  void _addVendor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Vendor'),
        content: Form(
          key: _vendorController.vendorFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _vendorController.vendorName,
                decoration: const InputDecoration(labelText: 'Vendor Name'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Vendor Name is required'
                    : null,
              ),
              TextFormField(
                controller: _vendorController.vendorEmail,
                decoration: const InputDecoration(labelText: 'Vendor Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty
                    ? 'Vendor Email is required'
                    : null,
              ),
              TextFormField(
                controller: _vendorController.vendorPassword,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value == null || value.isEmpty
                    ? 'Password is required'
                    : null,
              ),
              TextFormField(
                controller: _vendorController.contactInfo,
                decoration: const InputDecoration(labelText: 'Contact Info'),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty
                    ? 'Contact Info is required'
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
              try {
                await _vendorController.register();
                Navigator.pop(context); // Close the dialog on success
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vendor added successfully')),
                );
              } catch (e) {
                Navigator.pop(context); // Close the dialog on error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to add vendor: $e')),
                );
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
        title: const Text('Manage Vendors'),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _vendorsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No vendors found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final vendorDoc = snapshot.data!.docs[index];
              final vendorData = vendorDoc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VendorDetailsPage(vendorData: vendorData),
                      ),
                    );
                  },
                  title: Text(vendorData['Vendor Name'] ?? 'No Name'),
                  subtitle: Text(vendorData['Vendor Email'] ?? 'No Email'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteVendor(vendorDoc.id);
                    },
                  ),
                ),
              );
            },
          );
        },
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
                onPressed: _addVendor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
