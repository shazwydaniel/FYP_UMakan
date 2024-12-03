import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> addAuthorityAccount() async {
  try {
    // Firestore reference to the Authority collection
    final authorityCollection = FirebaseFirestore.instance.collection('Authority');

    // Check if the Authority account already exists
    final existingAuthority = await authorityCollection
        .where('email', isEqualTo: 'shzwydniel@gmail.com') // Check by email
        .get();

    if (existingAuthority.docs.isEmpty) {
      // Create the Authority account in Firebase Authentication
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: 'shzwydniel@gmail.com', // Replace with your desired email
        password: 'Daniel_2154!', // Replace with a secure password
      );

      final authUid = userCredential.user?.uid;

      // Add the Authority account details to Firestore
      await authorityCollection.doc(authUid).set({
        'Id': authUid, // Use auth_uid as the Firestore document ID
        'Username': 'Authority',
        'Email': 'shzwydniel@gmail.com',
        'Role': 'Authority',
      });

      print('Authority account created successfully.');
    } else {
      print('Authority account already exists.');
    }
  } catch (e) {
    print('Error creating Authority account: $e');
  }
}