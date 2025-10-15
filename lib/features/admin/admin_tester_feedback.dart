import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';

class TesterQuestionsPage extends StatefulWidget {
  @override
  State<TesterQuestionsPage> createState() => _TesterQuestionsPageState();
}

class _TesterQuestionsPageState extends State<TesterQuestionsPage> {
  final userController = Get.find<UserController>();

  /// FINAL 15 QUESTIONS (Community & Cafe)
  /// Types: 'yesno' | 'slider' (1–5)
  final List<Map<String, dynamic>> questions = [
    // Community (1–7)
    {
      'type': 'yesno',
      'question': "1. Were you able to open and access the Community page?"
    },
    {
      'type': 'yesno',
      'question': "2. Could you clearly see the Supporting Organisations?"
    },
    {
      'type': 'yesno',
      'question': "3. Were you able to contact a Supporting Organisation via Telegram?"
    },
    {
      'type': 'slider',
      'question':
          "4. Rate the visibility and layout of Vendor News and Community News (1=poor, 5=excellent).",
      'legend': true,
    },
    {
      'type': 'slider',
      'question': "5. How easy was it to post a message in Community News?",
      'legend': true,
    },
    {
      'type': 'yesno',
      'question': "6. Were you able to include a picture when posting a message?"
    },
    {
      'type': 'slider',
      'question': "7. How easy was it to edit or update your post (message or status)?",
      'legend': true,
    },

    // Cafe (8–15)
    {
      'type': 'yesno',
      'question': "8. Were you able to open and view a Cafe location?"
    },
    {
      'type': 'slider',
      'question': "9. How easy was it to browse cafe menus (open/closed cafes)?",
      'legend': true,
    },
    {
      'type': 'yesno',
      'question': "10. Could you view all menu details (name, calories, cost, type)?"
    },
    {
      'type': 'slider',
      'question': "11. How easy was it to give a review and star rating?",
      'legend': true,
    },
    {
      'type': 'yesno',
      'question': "12. Were you able to set your anonymity preference when submitting feedback?"
    },
    {
      'type': 'slider',
      'question':
          "13. How useful was the feedback & reviews section for understanding a cafe’s quality?",
      'legend': true,
    },
    {
      'type': 'yesno',
      'question': "14. Were you able to view and manage your past reviews on the Cafe main page?"
    },
    {
      'type': 'slider',
      'question': "15. Overall, how would you rate your experience using Community & Cafe?",
      'legend': true,
    },
  ];

  final Map<int, double> sliderAnswers = {};
  final Map<int, String?> yesNoAnswers = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      if (q['type'] == 'slider') {
        sliderAnswers[i] = 3; // default mid
      } else if (q['type'] == 'yesno') {
        yesNoAnswers[i] = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.forest,
      appBar: AppBar(
        backgroundColor: TColors.forest,
        title: const Text(
          "UMakan Survey: Community & Cafe",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Column(
          children: [
            // Small legend for sliders
            _ScaleLegend(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: questions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final q = questions[index];
                  final type = q['type'] as String;

                  return Card(
                    color: TColors.cream,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Colors.black12, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            q['question'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Slider question
                          if (type == 'slider') ...[
                            Slider(
                              value: sliderAnswers[index]!,
                              onChanged: (val) => setState(() {
                                sliderAnswers[index] = val;
                              }),
                              min: 1,
                              max: 5,
                              divisions: 4,
                              label: sliderAnswers[index]!.toStringAsFixed(0),
                              activeColor: Colors.black,
                              inactiveColor: Colors.black26,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Rating: ${sliderAnswers[index]!.toStringAsFixed(0)} / 5",
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ]

                          // Yes/No question
                          else if (type == 'yesno') ...[
                            _YesNoPicker(
                              value: yesNoAnswers[index],
                              onChanged: (v) => setState(() => yesNoAnswers[index] = v),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _submitResponses,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black, width: 2.0),
                    backgroundColor: TColors.vermillion,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Submit Survey",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Iconsax.tick_circle, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitResponses() async {
    // Ensure all Yes/No are answered
    for (int i = 0; i < questions.length; i++) {
      if (questions[i]['type'] == 'yesno' && (yesNoAnswers[i] == null)) {
        Get.snackbar(
          "Incomplete",
          "Please answer all Yes/No questions.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
    }

    final data = <String, dynamic>{
      'userId': userController.user.value.id,
      'username': userController.user.value.username,
      'timestamp': Timestamp.now(),
    };

    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      final type = q['type'] as String;
      if (type == 'slider') {
        data['Q${i + 1}'] = {
          'question': q['question'],
          'answer': sliderAnswers[i]!.toStringAsFixed(0),
        };
      } else if (type == 'yesno') {
        data['Q${i + 1}'] = {
          'question': q['question'],
          'answer': yesNoAnswers[i],
        };
      }
    }

    await FirebaseFirestore.instance
        .collection("Admins")
        .doc("communitySurvey")
        .collection("responses")
        .add(data);

    Get.snackbar(
      "Thank you!",
      "Your responses have been submitted.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Reset
    setState(() {
      for (final k in sliderAnswers.keys) {
        sliderAnswers[k] = 3;
      }
      yesNoAnswers.updateAll((key, value) => null);
    });
  }
}

/// Small legend widget for 1–5 scale (subtle UI improvement)
class _ScaleLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TColors.cream.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("1 = Poor", style: TextStyle(fontWeight: FontWeight.w600)),
          Text("3 = OK", style: TextStyle(fontWeight: FontWeight.w600)),
          Text("5 = Excellent", style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// Decorative “Yes/No” labels (visual consistency with previous design)
class _YNOption extends StatelessWidget {
  final String label;
  const _YNOption({required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: TColors.cream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Radio group hidden row (keeps UI clean but functional)
class _YesNoGroup extends StatelessWidget {
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  const _YesNoGroup({required this.groupValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<String>(
            title: const Text(""),
            value: "Yes",
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: Colors.black,
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            dense: true,
            visualDensity: VisualDensity.compact,
          ),
        ),
        Expanded(
          child: RadioListTile<String>(
            title: const Text(""),
            value: "No",
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: Colors.black,
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            dense: true,
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
    );
  }
}

class _YesNoPicker extends StatelessWidget {
  final String? value;                // "Yes" | "No" | null
  final ValueChanged<String> onChanged;
  const _YesNoPicker({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget buildChip(String label) {
      final bool selected = value == label;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(label),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: selected ? TColors.teal : TColors.cream,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12, width: 1),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        buildChip('Yes'),
        const SizedBox(width: 8),
        buildChip('No'),
      ],
    );
  }
}