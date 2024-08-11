import 'package:flutter/material.dart';
import 'package:fyp_umakan/data/repositories/user/user_repository.dart';
import 'package:fyp_umakan/features/authentication/screens/landing/landing.dart';
import 'package:fyp_umakan/features/authentication/screens/login/login.dart';
import 'package:fyp_umakan/features/authentication/screens/register/register.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/theme/custom_themes/appbar_theme.dart';
import 'package:fyp_umakan/utils/theme/theme.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // UserRepository userRepository = UserRepository();
    
    return GetMaterialApp(
      initialBinding: InitialBinding(),
      themeMode: ThemeMode.system,
      theme:TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      // home: const LoginScreen(),
      home: const Scaffold(backgroundColor: TColors.teal, body: Center(child: CircularProgressIndicator(color: Colors.white,)))
    );
  }
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserRepository()); // Register UserRepository
  }
}