import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_umakan/data/repositories/authentication/authentication_repository.dart';

class MoneyJournalRepository {
  static MoneyJournalRepository get instance => MoneyJournalRepository();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Initialize the money journal for a user
  Future<void> initializeUserJournal(String userId) async {
    try {
      final docRef = _db.collection('money_journal').doc(userId);
      await docRef.set({'initialized': true}, SetOptions(merge: true)); // Ensure the document is created
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw 'Failed to initialize user journal: ${e.message}';
    } catch (e) {
      print('Unknown error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Add New Expense to Money Journal
  Future<void> addExpense(String userId, String expenseType, Map<String, dynamic> expenseData) async {
    try {
      await _db
          .collection('money_journal')
          .doc(userId)
          .collection('expenses')
          .doc()
          .set({
            'type': expenseType,
            ...expenseData,
            'createdAt': FieldValue.serverTimestamp(),
          });
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw 'Failed to add expense: ${e.message}';
    } catch (e) {
      print('Unknown error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Get All Expenses For a Specific User
  Future<List<Map<String, dynamic>>> getExpenses(String userId) async {
    try {
      final snapshot = await _db
          .collection('money_journal')
          .doc(userId)
          .collection('expenses')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw 'Failed to retrieve expenses: ${e.message}';
    } catch (e) {
      print('Unknown error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Update a Specific Expense
  Future<void> updateExpense(String userId, String expenseId, Map<String, dynamic> updatedData) async {
    try {
      await _db
          .collection('money_journal')
          .doc(userId)
          .collection('expenses')
          .doc(expenseId)
          .update(updatedData);
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw 'Failed to update expense: ${e.message}';
    } catch (e) {
      print('Unknown error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Remove a Specific Expense
  Future<void> removeExpense(String userId, String expenseId) async {
    try {
      await _db
          .collection('money_journal')
          .doc(userId)
          .collection('expenses')
          .doc(expenseId)
          .delete();
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw 'Failed to delete expense: ${e.message}';
    } catch (e) {
      print('Unknown error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Add Extra Allowance to Actual Food Allowance
  Future<void> addExtraAllowance(String userId, double extraAmount) async {
    try {
      final userDoc = _db.collection('Users').doc(userId);

      // Use a transaction to safely increment the actual food allowance
      await _db.runTransaction((transaction) async {
        final snapshot = await transaction.get(userDoc);

        if (!snapshot.exists) {
          throw 'User not found';
        }

        final currentAllowance = snapshot.data()?['actualRemainingFoodAllowance'] ?? 0.0;
        final updatedAllowance = currentAllowance + extraAmount;

        transaction.update(userDoc, {'actualRemainingFoodAllowance': updatedAllowance});
      });
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw 'Failed to add extra allowance: ${e.message}';
    } catch (e) {
      print('Unknown error: $e');
      throw 'Something went wrong. Please try again';
    }
  }
}