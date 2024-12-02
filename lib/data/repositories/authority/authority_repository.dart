import 'package:cloud_firestore/cloud_firestore.dart';

class AuthorityRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get instance
  static AuthorityRepository get instance => AuthorityRepository();

  // Fetch a single Authority account details by ID
  Future<Map<String, dynamic>> fetchAuthorityDetails(String authorityId) async {
    try {
      final doc = await _db.collection('Authority').doc(authorityId).get();
      if (doc.exists) {
        print('Authority account fetched successfully: ${doc.id}');
        return doc.data()!;
      } else {
        throw 'Authority details not found!';
      }
    } catch (e) {
      print('Error fetching Authority details: $e');
      throw e;
    }
  }

  // Fetch all Authority accounts and print the count
  Future<List<Map<String, dynamic>>> fetchAllAuthorityAccounts() async {
    try {
      final snapshot = await _db.collection('Authority').get();
      final authorityAccounts = snapshot.docs.map((doc) => doc.data()).toList();
      print('Number of Authority accounts fetched: ${authorityAccounts.length}');
      return authorityAccounts;
    } catch (e) {
      print('Error fetching Authority accounts: $e');
      throw e;
    }
  }

  // Update Authority details
  Future<void> updateAuthorityDetails(String authorityId, Map<String, dynamic> updates) async {
    try {
      await _db.collection('Authority').doc(authorityId).update(updates);
      print('Authority details updated.');
    } catch (e) {
      print('Error updating Authority details: $e');
      throw e;
    }
  }
}