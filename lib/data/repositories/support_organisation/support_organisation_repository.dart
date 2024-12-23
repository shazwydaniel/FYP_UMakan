import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_umakan/features/support_organisation/model/support_organisation_model.dart';

class SupportOrganisationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createSupportOrganisation(SupportOrganisationModel org) async {
    try {
      await FirebaseFirestore.instance
          .collection('SupportOrganisation')
          .doc(org.id)
          .set(org.toMap());
      print('Support Organisation created successfully: ${org.toMap()}');
    } catch (e) {
      print('Error creating Support Organisation: $e');
      rethrow; // Rethrow the error to propagate it
    }
  }

  Future<SupportOrganisationModel?> getSupportOrganisation(String id) async {
    try {
      final doc = await _firestore.collection('SupportOrganisation').doc(id).get();
      if (doc.exists) {
        return SupportOrganisationModel.fromMap(doc.id, doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching Support Organisation: $e');
    }
  }
}
