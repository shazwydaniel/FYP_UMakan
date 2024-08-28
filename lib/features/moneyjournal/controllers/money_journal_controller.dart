import 'package:fyp_umakan/data/repositories/money_journal/money_journal_repository.dart';
import 'package:get/get.dart';

class MoneyJournalController extends GetxController {
  final MoneyJournalRepository _moneyJournalRepo = MoneyJournalRepository.instance;

  var expenses = <Map<String, dynamic>>[].obs;

  Future<void> loadExpenses(String userId) async {
    try {
      final expenseData = await _moneyJournalRepo.getExpenses(userId);
      expenses.assignAll(expenseData);
    } catch (e) {
      print('Error loading expenses: $e');
    }
  }
}
