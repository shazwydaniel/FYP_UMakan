import 'package:cloud_firestore/cloud_firestore.dart';

void addSampleOrganisations() {
  FirebaseFirestore.instance.collection('helping_organisations').add({
    'name': 'SWRC Food Bank',
    'contact': '012-3456789',
    'location': 'IN CAMPUS',
    'imagePath': 'assets/images/FoodBank.png',
  });

  FirebaseFirestore.instance.collection('helping_organisations').add({
    'name': 'Masjid Ar-Rahman',
    'contact': '019-87654321',
    'location': 'OUTSIDE CAMPUS',
    'imagePath': 'assets/images/Masjid.png',
  });

  print('Sample data added to helping_organisations collection');
}
