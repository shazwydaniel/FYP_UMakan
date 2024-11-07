import 'package:cloud_firestore/cloud_firestore.dart';

void addSampleCommunityNews() {
  final CollectionReference communityNewsCollection =
      FirebaseFirestore.instance.collection('community_news');

  communityNewsCollection.add({
    'news_message': 'Free meals available at the main hall today.',
    'type_of_news_message': 'Offer Help',
    'news_duration': '1 Day',
    'timestamp': Timestamp.now(),
    'user_id': 'user123', // Replace with an appropriate user ID
  });

  communityNewsCollection.add({
    'news_message': 'Looking for carpool buddies to the SWRC event.',
    'type_of_news_message': 'Need Help',
    'news_duration': '3 Days',
    'timestamp': Timestamp.now(),
    'user_id': 'user456', // Replace with an appropriate user ID
  });

  communityNewsCollection.add({
    'news_message': 'Anyone interested in volunteering for food distribution?',
    'type_of_news_message': 'Offer Help',
    'news_duration': '1 Week',
    'timestamp': Timestamp.now(),
    'user_id': 'user789', // Replace with an appropriate user ID
  });

  print('Sample community news data added to Firestore');
}
