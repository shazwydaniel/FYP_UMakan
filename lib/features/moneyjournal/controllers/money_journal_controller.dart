import 'package:fyp_umakan/data/repositories/money_journal/money_journal_repository.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MoneyJournalController extends GetxController {
  final MoneyJournalRepository _moneyJournalRepo = MoneyJournalRepository.instance;

  var expenses = <Map<String, dynamic>>[].obs;
  var daysUntilReset = 0.obs; // Observable for countdown
  var nextResetMonth = ''.obs; // Observable for the next reset month

  Future<void> loadExpenses(String userId) async {
    try {
      final expenseData = await _moneyJournalRepo.getExpenses(userId);
      expenses.assignAll(expenseData);
    } catch (e) {
      print('Error loading expenses: $e');
    }
  }

  void calculateDaysUntilReset() {
    final now = DateTime.now();
    final nextMonth = now.month == 12
        ? DateTime(now.year + 1, 1, 1)
        : DateTime(now.year, now.month + 1, 1);

    // Calculate difference in days, rounding up
    final difference = nextMonth.difference(now);
    daysUntilReset.value = (difference.inHours / 24).ceil(); // Rounds up to the next whole day

    // Update next reset month name
    nextResetMonth.value = DateFormat.MMMM().format(nextMonth);
  }
  
}