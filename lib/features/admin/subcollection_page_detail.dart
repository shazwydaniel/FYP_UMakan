import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubcollectionDetailsPage extends StatelessWidget {
  final String userId;
  final String subcollectionName;

  const SubcollectionDetailsPage(
      {Key? key, required this.userId, required this.subcollectionName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subcollectionStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection(subcollectionName)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(subcollectionName),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: subcollectionStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              return ListTile(
                title: Text(doc.id),
                subtitle: Text(doc.data().toString()),
              );
            },
          );
        },
      ),
    );
  }
}
