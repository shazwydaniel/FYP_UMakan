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

  final userController = UserController.instance;
  final fullName = TextEditingController();
  final matricsNumber = TextEditingController();
  final phoneNumber = TextEditingController();
  final accommodation = TextEditingController();
  final monthlyAllowance = TextEditingController();
  final monthlyCommittments = TextEditingController();
  final weight = TextEditingController();
  final height = TextEditingController();
  final birthDate = TextEditingController();
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateProfileFormKey = GlobalKey<FormState>();

  //init user data when Home Screen Appears
  @override
  void onInit() {
    super.onInit();
    initalizeNames();
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

      //Update data in Firebase Firestore
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
      await userRepository.updateSingleField(fullNameData);
      await userRepository.updateSingleField(matricsNumberData);
      await userRepository.updateSingleField(phoneNumberData);
      await userRepository.updateSingleField(accommodationData);
      await userRepository.updateSingleField(monthlyAllowanceData);
      await userRepository.updateSingleField(monthlyCommittmentsData);
      await userRepository.updateSingleField(weightData);
      await userRepository.updateSingleField(heightData);
      await userRepository.updateSingleField(birthDateData);

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

  Future<void> updateFoodMoney() async {
    try {
      // Retrieve the values from the TextEditingControllers
      double allowance = double.tryParse(monthlyAllowance.text.trim()) ?? 0.0;
      double commitments =
          double.tryParse(monthlyCommittments.text.trim()) ?? 0.0;

      // Calculate the food money
      double foodMoney = allowance - commitments;

      // Update the user model or store the food money in a variable
      userController.user.value.actualRemainingFoodAllowance = foodMoney;

      Map<String, dynamic> actualRemainingFoodAllowance = {
        'Actual Food Remanining Allowance': foodMoney
      };

      await userRepository.createSingleField(actualRemainingFoodAllowance);
      // Print the food money to the debug console (optional)
      print('Food money calculated: \$${foodMoney.toStringAsFixed(2)}');
    } catch (e) {
      // Log the error for debugging
      debugPrint("Error calculating food money: $e");
      TLoaders.errorSnackBar(
          title: 'Error!', message: 'Could not calculate food money.');
    }
  }
}
