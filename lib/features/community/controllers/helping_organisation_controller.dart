import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/helping_organisation_model.dart';

class HelpingOrganisationController {
  final CollectionReference _orgCollection =
      FirebaseFirestore.instance.collection('helping_organisations');

  Future<List<HelpingOrganisation>> fetchOrganisations() async {
    try {
      QuerySnapshot snapshot = await _orgCollection.get();
      return snapshot.docs.map((doc) {
        return HelpingOrganisation.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Error fetching organisations: $e");
      return [];
    }
  }
}
