import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/data/repositories/authentication/authentication_repository.dart';
import 'package:fyp_umakan/data/repositories/user/user_repository.dart';
import 'package:fyp_umakan/features/authentication/models/user_model.dart';
import 'package:get/get.dart';
import 'package:fyp_umakan/utils/popups/full_screen_loader.dart';
import 'package:fyp_umakan/utils/constants/image_strings.dart';


class RegisterController extends GetxController {
  static RegisterController get instance => Get.find();

  // Variables
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final fullName = TextEditingController();
  final username= TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final phoneNumber = TextEditingController();
  final matricsNumber = TextEditingController();
  final gender = TextEditingController();
  final accommodation = TextEditingController();
  final monthlyAllowance= TextEditingController();
  final monthlyCommittments = TextEditingController();
  final vehicle = TextEditingController();
  final maritalStatus= TextEditingController();
  final childrenNumber= TextEditingController();
  final height = TextEditingController();
  final weight = TextEditingController();
  final birthdate = TextEditingController();
  GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  // Store userId after registration
  late String userId;

  // Register
  Future<bool> register() async{
    try{

      // TFullScreenLoader.openLoadingDialog('We are processing your information...', TImages.verifyIllustration);

      // Check Internet Connectivity

      // Form Validation
      if(!registerFormKey.currentState!.validate()){
        // TFullScreenLoader.stopLoading();
        return false;
      }

      // Privacy Policy Check
      if (!privacyPolicy.value) {
        return false;
      }

      // Register User in Firebase Auth + User Data
      final userCredential = await AuthenticatorRepository.instance.registerWithEmailandPassword(email.text.trim(), password.text.trim());

      // Save User Data in Firebase Firestore
      final newUser = UserModel(
        id: userCredential.user!.uid,
        fullName: fullName.text.trim(),
        username: username.text.trim(),
        email: email.text.trim(),
        password: password.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        matricsNumber: matricsNumber.text.trim(),
        gender: gender.text.trim(),
        accommodation: accommodation.text.trim(),
        vehicle: vehicle.text.trim(),
        maritalStatus: maritalStatus.text.trim(),
        childrenNumber: childrenNumber.text.trim(),
        monthlyAllowance: monthlyAllowance.text.trim(),
        monthlyCommittments: monthlyCommittments.text.trim(),
        height: height.text.trim(),
        weight: weight.text.trim(),
        birthdate: birthdate.text.trim(),
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      // Store the userId for later use
      userId = newUser.id;

      // TFullScreenLoader.stopLoading(); 

      return true;
    } catch (e) {

      // TLoaders
      return false;

    } 
  }
}