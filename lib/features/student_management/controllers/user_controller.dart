import 'package:flutter/material.dart';
import 'package:fyp_umakan/data/repositories/user/user_repository.dart';
import 'package:fyp_umakan/features/authentication/models/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  Rx<UserModel> user = UserModel.empty().obs;
  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  // Fetch User Record
  Future<void> fetchUserRecord() async{
    try{
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch(e){
      user(UserModel.empty());
    }
  }


}