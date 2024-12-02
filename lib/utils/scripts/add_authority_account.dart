import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> addAuthorityAccount() async {
  try {
    // Firestore reference to the Authority collection
    final authorityCollection = FirebaseFirestore.instance.collection('Authority');

    // Check if the Authority account already exists
    final existingAuthority = await authorityCollection.doc('authority001').get();

    if (!existingAuthority.exists) {
      // Create the Authority account in Firebase Authentication
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: 'authority@example.com', // Replace with your desired email
        password: 'SecurePassword123!', // Replace with a secure password
      );

      // Add the Authority account details to Firestore
      await authorityCollection.doc('authority001').set({
        'id': 'authority001',
        'username': 'Authority',
        'email': 'authority@example.com',
        'role': 'Authority',
        'auth_uid': userCredential.user?.uid, // Firebase Auth UID for cross-reference
      });

      print('Authority account created successfully.');
    } else {
      print('Authority account already exists.');
    }
  } catch (e) {
    print('Error creating Authority account: $e');
  }
}