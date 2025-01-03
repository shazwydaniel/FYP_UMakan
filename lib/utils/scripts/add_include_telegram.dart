import 'package:cloud_firestore/cloud_firestore.dart';

void addMissingFieldToDocuments() async {
  final collection = FirebaseFirestore.instance.collection('community_news');
  final snapshot = await collection.get();

  for (var doc in snapshot.docs) {
    if (!doc.data().containsKey('include_telegram')) {
      await collection.doc(doc.id).update({'include_telegram': 'No'});
    }
  }
  print('Field added to all documents where missing.');
}