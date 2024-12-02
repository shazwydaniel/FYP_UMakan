import 'package:cloud_firestore/cloud_firestore.dart';

class MoneyJournalRepository {
  static MoneyJournalRepository get instance => MoneyJournalRepository();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Initialize the money journal for a user
  Future<void> initializeUserJournal(String userId) async {
    try {
      final docRef = _db.collection('Users').doc(userId).collection('money_journal').doc('meta');
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
      final docRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('money_journal')
          .doc(); // Adds expense directly under 'money_journal'

      await docRef.set({
        'expense_ID': docRef.id,
        'type': expenseType,
        ...expenseData,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding expense: $e');
    }
  }

  // Get All Expenses For a Specific User
  Future<List<Map<String, dynamic>>> getExpenses(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('money_journal') // Directly fetch expenses
          .orderBy('createdAt', descending: true)
          .get();

      // Filter out the 'meta' document by its ID
      return snapshot.docs
          .where((doc) => doc.id != 'meta') // Exclude meta document
          .map((doc) => {
                'expense_ID': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      print('Error fetching expenses: $e');
      return [];
    }
  }

  // Update a Specific Expense
  Future<void> updateExpense(String userId, String expenseId, Map<String, dynamic> updatedData) async {
    try {
      await _db
          .collection('Users')
          .doc(userId)
          .collection('money_journal')
          .doc()
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
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('money_journal') // Directly access the 'money_journal' subcollection
          .doc(expenseId) // Reference the specific expense document
          .delete();
    } catch (e) {
      print('Error removing expense: $e');
      throw 'Failed to remove expense: $e';
    }
  }

  // Add Extra Allowance to Actual Food Allowance
  Future<void> addExtraAllowance(String userId, double extraAmount) async {
    try {
      final userDoc = _db.collection('Users').doc(userId);

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