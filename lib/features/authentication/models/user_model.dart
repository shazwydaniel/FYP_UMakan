import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  String fullName;
  final String username;
  final String email;
  String password;
  String phoneNumber;
  String matricsNumber;
  String gender;
  String accommodation;
  String vehicle;
  String maritalStatus;
  String childrenNumber;
  String monthlyAllowance;
  String monthlyCommittments;
  String height;
  String weight;
  String birthdate;

  UserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.matricsNumber,
    required this.gender,
    required this.accommodation,
    required this.vehicle,
    required this.maritalStatus,
    required this.childrenNumber,
    required this.monthlyAllowance,
    required this.monthlyCommittments,
    required this.height,
    required this.weight,
    required this.birthdate,
  });

  // Convert a UserModel into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'matricsNumber': matricsNumber,
      'gender': matricsNumber,
      'accommodation': accommodation,
      'vehicle': vehicle,
      'maritalStatus': maritalStatus,
      'childrenNumber': childrenNumber,
      'monthlyAllowance': monthlyAllowance,
      'monthlyCommittments': monthlyCommittments,
      'height': height,
      'weight': weight,
      'birthdate': birthdate,
    };
  }

  // Create a UserModel from a Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      fullName: map['fullName'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      phoneNumber: map['phoneNumber'],
      matricsNumber: map['matricsNumber'],
      gender: map['gender'],
      accommodation: map['accommodation'],
      vehicle: map['vehicle'],
      maritalStatus: map['maritalStatus'],
      childrenNumber: map['childrenNumber'],
      monthlyAllowance: map['monthlyAllowance'],
      monthlyCommittments: map['monthlyCommittments'],
      height: map['height'],
      weight: map['weight'],
      birthdate: map['birthdate'],
    );
  }

  // Create a UserModel from Firestore DocumentSnapshot
  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(data);
  }

  // Convert a UserModel into a JSON-compatible Map
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'FullName': fullName,
      'Username': username,
      'Email': email,
      'Password': password,
      'PhoneNumber': phoneNumber,
      'MatricsNumber': matricsNumber,
      'Gender': gender,
      'Accomodation': accommodation,
      'Vehicle Ownership': vehicle,
      'Marital Status': maritalStatus,
      'Number of Children': childrenNumber,
      'Monthly Allowance': monthlyAllowance,
      'Monthly Commitments': monthlyCommittments,
      'Height': height,
      'Weight': weight,
      'Birthdate': birthdate,
    };
  }

  // Static Function to Create an Empty User Model
  static UserModel empty() => UserModel(
      id: '',
      fullName: '',
      username: '',
      email: '',
      password: '',
      phoneNumber: '',
      matricsNumber: '',
      gender: '',
      accommodation: '',
      vehicle: '',
      maritalStatus: '',
      childrenNumber: '',
      monthlyAllowance: '',
      monthlyCommittments: '',
      height: '',
      weight: '',
      birthdate: '');

  // Create a UserModel from Firebase Document Snapshot
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
          id: document.id,
          fullName: data['FullName'] ?? '',
          username: data['Username'] ?? '',
          email: data['Email'] ?? '',
          password: data['Password'] ?? '',
          phoneNumber: data['PhoneNumber'] ?? '',
          matricsNumber: data['MatricsNumber'] ?? '',
          gender: data['Gender'] ?? '',
          accommodation: data['Accomodation'] ?? '',
          vehicle: data['Vehicle Ownership'] ?? '',
          maritalStatus: data['Marital Status'] ?? '',
          childrenNumber: data['Number of Children'] ?? '',
          monthlyAllowance: data['Monthly Allowance'] ?? '',
          monthlyCommittments: data['Monthly Commitments'] ?? '',
          height: data['Height'] ?? '',
          weight: data['Weight'] ?? '',
          birthdate: data['Birthdate'] ?? '');
    } else {
      return UserModel.empty();
    }
  }
}
