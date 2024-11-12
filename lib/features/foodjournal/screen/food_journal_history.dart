import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/foodjournal/model/journal_model.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:intl/intl.dart';

class JournalHistoryPage extends StatelessWidget {
  final String mealType;
  final List<JournalItem> items;

  const JournalHistoryPage({
    Key? key,
    required this.mealType,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.mustard,
      appBar: AppBar(
        title: Text('$mealType History'),
        backgroundColor: TColors.mustard,
      ),
      body: items.isEmpty
          ? Center(
              child: Text(
                'No items logged for $mealType',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  decoration: BoxDecoration(
                    color: TColors.cream,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                    title: Text(
                      item.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item.calories} cal - ${item.cafe}',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'RM${item.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: TColors.amber,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: Text(
                      DateFormat('yyyy-MM-dd \'at\' hh:mm a')
                          .format(item.timestamp),
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
