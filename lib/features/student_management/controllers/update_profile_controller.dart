import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/widgets/loaders/loaders.dart';
import 'package:fyp_umakan/data/repositories/user/user_repository.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';
import 'package:fyp_umakan/features/student_management/screens/student_profile.dart';
import 'package:fyp_umakan/navigation_menu.dart';
import 'package:fyp_umakan/utils/helpers/network_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class UpdateProfileController extends GetxController {
  static UpdateProfileController get instance => Get.find();

  final fullName = TextEditingController();
  final matricsNumber = TextEditingController();
  final phoneNumber = TextEditingController();
  final accommodation = TextEditingController();
  final monthlyAllowance = TextEditingController();
  final monthlyCommittments = TextEditingController();
  final weight = TextEditingController();
  final height = TextEditingController();
  final birthDate = TextEditingController();
  final userController = UserController.instance;
  GlobalKey<FormState> updateProfileFormKey = GlobalKey<FormState>();

  //init user data when Home Screen Appears
  @override
  void onInit() {
    initalizeNames();
    super.onInit();
  }

  //Fetch user Record
  Future<void> initalizeNames() async {
    fullName.text = userController.user.value.fullName;
    matricsNumber.text = userController.user.value.matricsNumber;
    phoneNumber.text = userController.user.value.phoneNumber;
    accommodation.text = userController.user.value.accommodation;
    monthlyAllowance.text = userController.user.value.monthlyAllowance;
    monthlyCommittments.text = userController.user.value.monthlyCommittments;
    weight.text = userController.user.value.weight;
    height.text = userController.user.value.height;
    birthDate.text = userController.user.value.birthdate;
  }

  Future<void> updateProfile() async {
    try {
      //Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.errorSnackBar(
            title: 'No Internet',
            message: 'Please check your internet connection.');
        return;
      }

      // Form Validation
      if (!updateProfileFormKey.currentState!.validate()) {
        TLoaders.errorSnackBar(
            title: 'Invalid Input',
            message: 'Please fill all the required fields correctly.');
        return;
      }

      //Update User fullname in Firebase Firestore
      Map<String, dynamic> fullNameData = {'FullName': fullName.text.trim()};
      Map<String, dynamic> matricsNumberData = {
        'MatricsNumber': matricsNumber.text.trim()
      };
      Map<String, dynamic> phoneNumberData = {
        'PhoneNumber': phoneNumber.text.trim()
      };
      Map<String, dynamic> accommodationData = {
        'Accomodation': accommodation.text.trim()
      };
      Map<String, dynamic> monthlyAllowanceData = {
        'Monthly Allowance': monthlyAllowance.text.trim()
      };
      Map<String, dynamic> monthlyCommittmentsData = {
        'Monthly Commitments': monthlyCommittments.text.trim()
      };
      Map<String, dynamic> weightData = {'Weight': weight.text.trim()};
      Map<String, dynamic> heightData = {'Height': height.text.trim()};
      Map<String, dynamic> birthDateData = {'Birthdate': birthDate.text.trim()};

      //Use methods in User Repository to transfer to Firebase
      await UserRepository.instance.updateSingleField(fullNameData);
      await UserRepository.instance.updateSingleField(matricsNumberData);
      await UserRepository.instance.updateSingleField(phoneNumberData);
      await UserRepository.instance.updateSingleField(accommodationData);
      await UserRepository.instance.updateSingleField(monthlyAllowanceData);
      await UserRepository.instance.updateSingleField(monthlyCommittmentsData);
      await UserRepository.instance.updateSingleField(weightData);
      await UserRepository.instance.updateSingleField(heightData);
      await UserRepository.instance.updateSingleField(birthDateData);

      //Update Rx value
      userController.user.value.fullName = fullName.text.trim();
      userController.user.value.matricsNumber = matricsNumber.text.trim();
      userController.user.value.phoneNumber = phoneNumber.text.trim();
      userController.user.value.accommodation = accommodation.text.trim();
      userController.user.value.monthlyAllowance = monthlyAllowance.text.trim();
      userController.user.value.monthlyCommittments =
          monthlyCommittments.text.trim();
      userController.user.value.weight = weight.text.trim();
      userController.user.value.height = height.text.trim();
      userController.user.value.birthdate = birthDate.text.trim();

      //Show success Message
      TLoaders.successSnackBar(
          title: 'Congratulations', message: "Your profile has been updated!.");

      Get.off(() => const NavigationMenu());
    } catch (e) {
      // Log the error for debugging
      debugPrint("Error update: $e");
      TLoaders.errorSnackBar(title: 'OOps!', message: e.toString());
    }
  }
}
