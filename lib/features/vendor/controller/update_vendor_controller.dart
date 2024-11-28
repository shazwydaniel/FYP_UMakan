import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/widgets/loaders/loaders.dart';
import 'package:fyp_umakan/data/repositories/user/user_repository.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';
import 'package:fyp_umakan/features/student_management/screens/student_profile.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/vendor_repository.dart';
import 'package:fyp_umakan/navigation_menu.dart';
import 'package:fyp_umakan/utils/helpers/network_manager.dart';
import 'package:fyp_umakan/vendor_navigation_menu.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class UpdateVendorController extends GetxController {
  static UpdateVendorController get instance => Get.find();

  final vendorController = VendorController.instance;
  final vendorRepo = VendorRepository.instance;
  final fullName = TextEditingController();

  final phoneNumber = TextEditingController();

  GlobalKey<FormState> updateVendorFormKey = GlobalKey<FormState>();

  //init user data when Home Screen Appears
  @override
  void onInit() {
    super.onInit();
    initalizeNames();
  }

  //Fetch user Record
  Future<void> initalizeNames() async {
    fullName.text = vendorController.vendor.value.vendorName;
    phoneNumber.text = vendorController.vendor.value.contactInfo;
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
      if (!updateVendorFormKey.currentState!.validate()) {
        TLoaders.errorSnackBar(
            title: 'Invalid Input',
            message: 'Please fill all the required fields correctly.');
        return;
      }

      //Update data in Firebase Firestore
      Map<String, dynamic> fullNameData = {'Vendor Name': fullName.text.trim()};

      Map<String, dynamic> phoneNumberData = {
        'Contact Info': phoneNumber.text.trim()
      };

      //Use methods in User Repository to transfer to Firebase
      await vendorRepo.updateSingleField(fullNameData);

      await vendorRepo.updateSingleField(phoneNumberData);

      //Update Rx value
      vendorController.vendor.value.vendorName = fullName.text.trim();

      vendorController.vendor.value.contactInfo = phoneNumber.text.trim();

      //Show success Message
      TLoaders.successSnackBar(
          title: 'Congratulations', message: "Your profile has been updated!.");

      Get.off(() => const VendorNavigationMenu());
    } catch (e) {
      // Log the error for debugging
      debugPrint("Error update: $e");
      TLoaders.errorSnackBar(title: 'OOps!', message: e.toString());
    }
  }
}
