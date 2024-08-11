import 'package:flutter/material.dart';
import 'package:fyp_umakan/data/repositories/user/user_repository.dart';
import 'package:fyp_umakan/features/authentication/models/user_model.dart';
import 'package:get/get.dart';
import 'package:fyp_umakan/utils/popups/full_screen_loader.dart';
import 'package:fyp_umakan/utils/constants/image_strings.dart';


class PersonalDetailsController extends GetxController {
  static PersonalDetailsController get instance => Get.find();

  // Variables
  final accommodation = TextEditingController();
  final monthlyAllowance= TextEditingController();
  final monthlyCommittments = TextEditingController();
  final vehicle = TextEditingController();
  final maritalStatus= TextEditingController();
  final childrenNumber= TextEditingController();
  final height = TextEditingController();
  final weight = TextEditingController();
  final birthdate = TextEditingController();
  GlobalKey<FormState> personalDetailsFormKey = GlobalKey<FormState>();

  // Update Personal Details
  Future<bool> addPersonalDetails(String userId) async{
    try{

      // TFullScreenLoader.openLoadingDialog('We are processing your information...', TImages.verifyIllustration);

      // Check Internet Connectivity

      // Form Validation
      if(!personalDetailsFormKey.currentState!.validate()){
        return false;
      }

      final userRepository = Get.put(UserRepository());

      // Fetch existing user data
      final existingUser = await userRepository.getUserRecord(userId);

      // Update User Personal Details in Firebase
      final userDetails = UserModel(
        id: userId,
        fullName: existingUser.fullName,
        username: existingUser.username,
        email: existingUser.email,
        password: existingUser.password,
        phoneNumber: existingUser.phoneNumber,
        matricsNumber: existingUser.matricsNumber,
        gender: existingUser.gender,
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

      await userRepository.updateUserRecord(userDetails);

      return true;
    } catch (e) {

      // TLoaders
      return false;

    } 
  }
}