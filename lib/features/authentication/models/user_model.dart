import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
  int age;
  int status;
  double recommendedCalorieIntake;
  double recommendedMoneyAllowance;
  double actualRemainingFoodAllowance;
  double additionalAllowance;
  double additionalExpense;
  double updatedRecommendedAllowance;
  String role;
  bool prefSpicy;
  bool prefVegetarian;
  bool prefLowSugar;
  String telegramHandle;

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
    required this.age,
    required this.status,
    required this.role,
    this.recommendedCalorieIntake = 0.0,
    this.recommendedMoneyAllowance = 0.0,
    this.actualRemainingFoodAllowance = 0.0,
    this.additionalAllowance = 0.0,
    this.additionalExpense = 0.0,
    this.updatedRecommendedAllowance = 0.0,
    this.prefSpicy = false,
    this.prefVegetarian = false,
    this.prefLowSugar = false,
    this.telegramHandle = '',
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
      'gender': gender,
      'accommodation': accommodation,
      'vehicle': vehicle,
      'maritalStatus': maritalStatus,
      'childrenNumber': childrenNumber,
      'monthlyAllowance': monthlyAllowance,
      'monthlyCommittments': monthlyCommittments,
      'height': height,
      'weight': weight,
      'birthdate': birthdate,
      'age': age,
      'Role': role,
      'status': status,
      'recommendedCalorieIntake': recommendedCalorieIntake,
      'recommendedMoneyAllowance': recommendedMoneyAllowance,
      'actualRemainingFoodAllowance': actualRemainingFoodAllowance,
      'additionalAllowance': additionalAllowance,
      'additionalExpense': additionalExpense,
      'updatedRecommendedAllowance': updatedRecommendedAllowance,
      'prefSpicy': prefSpicy,
      'prefVegetarian': prefVegetarian,
      'prefLowSugar': prefLowSugar,
      'telegramHandle': telegramHandle,
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
      age: map['age'] ?? 0,
      role: map['Role'],
      status: map['status'] ?? 0,
      recommendedCalorieIntake: map['recommendedCalorieIntake']?.toDouble() ?? 0.0,
      recommendedMoneyAllowance: map['recommendedMoneyAllowance']?.toDouble() ?? 0.0,
      actualRemainingFoodAllowance: map['actualRemainingFoodAllowance']?.toDouble() ?? 0.0,
      additionalAllowance: map['additionalAllowance']?.toDouble() ?? 0.0,
      additionalExpense: map['additionalExpense']?.toDouble() ?? 0.0,
      updatedRecommendedAllowance: map['updatedRecommendedAllowance']?.toDouble() ?? 0.0,
      prefSpicy: map['prefSpicy'] ?? false,
      prefVegetarian: map['prefVegetarian'] ?? false,
      prefLowSugar: map['prefLowSugar'] ?? false,
      telegramHandle: map['telegramHandle'] ?? '',
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
      'Age': age,
      'Status': status,
      'Recommended Calorie Intake': recommendedCalorieIntake,
      'Recommended Money Allowance': recommendedMoneyAllowance,
      'Food Money': actualRemainingFoodAllowance,
      'Additional Allowance': additionalAllowance,
      'Additional Expense': additionalExpense,
      'Updated Recommended Allowance': updatedRecommendedAllowance,
      'Role': role,
      'prefSpicy': prefSpicy,
      'prefVegetarian': prefVegetarian,
      'prefLowSugar': prefLowSugar,
      'telegramHandle': telegramHandle,
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
        birthdate: '',
        age: 0,
        status: 0,
        recommendedCalorieIntake: 0.0,
        recommendedMoneyAllowance: 0.0,
        actualRemainingFoodAllowance: 0.0,
        additionalAllowance: 0.0,
        additionalExpense: 0.0,
        updatedRecommendedAllowance: 0.0,
        role: '',
        prefSpicy: false,
        prefVegetarian: false,
        prefLowSugar: false,
        telegramHandle: '',
      );

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
        birthdate: data['Birthdate'] ?? '',
        age: data['Age'] ?? 0,
        role: data['Role'] ?? '',
        status: data['Status'] ?? 0,
        recommendedCalorieIntake: data['recommendedCalorieIntake']?.toDouble() ?? 0.0,
        recommendedMoneyAllowance: data['recommendedMoneyAllowance']?.toDouble() ?? 0.0,
        actualRemainingFoodAllowance: data['actualRemainingFoodAllowance']?.toDouble() ?? 0.0,
        additionalAllowance: data['additionalAllowance']?.toDouble() ?? 0.0,
        additionalExpense: data['additionalExpense']?.toDouble() ?? 0.0,
        updatedRecommendedAllowance: data['updatedRecommendedAllowance']?.toDouble() ?? 0.0,
        prefLowSugar: data['prefLowSugar'] ?? false,
        prefVegetarian: data['prefVegetarian'] ?? false,
        prefSpicy: data['prefSpicy'] ?? false,
        telegramHandle: data['telegramHandle'] ?? '',
      );
    } else {
      return UserModel.empty();
    }
  }

  // Method to calculate age from birthdate
  int calculateAge() {
    final birthDate = DateFormat('dd/MM/yyyy').parse(birthdate);
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // Method to calculate the status based on vehicle, maritalStatus, and childrenNumber
  int calculateStatus() {
    int status = 0;

    // Check vehicle ownership
    if (vehicle.toLowerCase().contains('owned')) {
      status += 1;
    } else if (vehicle.toLowerCase().contains('leased')) {
      status += 2;
    }

    // Check marital status
    if (maritalStatus.toLowerCase() == 'married') {
      status += 3;
    } else if (maritalStatus.toLowerCase() == 'single') {
      status += 1;
    }

    // Check number of children
    int children = int.tryParse(childrenNumber) ?? 0;
    if (children > 0) {
      status += children;
    }

    return status;
  }

  // Method to calculate the remaining recommended allowance based on the elapsed days
  double calculateUpdatedAllowance() {
    final today = DateTime.now();
    final totalDays = DateTime(today.year, today.month + 1, 0).day; 
    final elapsedDays = today.day;
    final dailyAllowance = recommendedMoneyAllowance / totalDays;

    return recommendedMoneyAllowance - (elapsedDays * dailyAllowance);
  }
}
