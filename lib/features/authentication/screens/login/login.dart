// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/styles/spacing_styles.dart';
import 'package:fyp_umakan/data/repositories/authentication/authentication_repository.dart';
import 'package:fyp_umakan/features/admin/admin_register.dart';
import 'package:fyp_umakan/features/authentication/controllers/login/login_controller.dart';
import 'package:fyp_umakan/features/authentication/screens/homepage/homepage.dart';
import 'package:fyp_umakan/features/authentication/screens/password_config/forget_password.dart';
import 'package:fyp_umakan/features/authentication/screens/register/register.dart';
import 'package:fyp_umakan/features/support_organisation/screens/support_organisation_register.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_register.dart';
import 'package:fyp_umakan/navigation_menu.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/image_strings.dart';
import 'package:fyp_umakan/utils/constants/sizes.dart';
import 'package:fyp_umakan/utils/constants/text_strings.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';
import 'package:fyp_umakan/utils/validators/validation.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/Login_Graphic_v3.png',
              fit: BoxFit.cover,
            ),
          ),

          // Main Content at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Padding(
                padding: TSpacingStyle.paddingWithAppBarHeight,
                child: Column(
                  children: [
                    // Title
                    Text(
                      'We Help U-Makan!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: dark
                            ? TColors.textDark
                            : TColors.textDark,
                      ),
                    ),

                    // Subtitle
                    Text(
                      'Start managing your meals and finances.',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: dark
                            ? TColors.textDark
                            : TColors.charcoal,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // Frosted Glass Card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 1.5,
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              // Login Form
                              Form(
                                key: controller.loginFormKey,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    children: [
                                      // Email Field
                                      TextFormField(
                                        controller: controller.email,
                                        validator: (value) =>
                                            TValidator.validateEmail(value),
                                        decoration: InputDecoration(
                                          prefixIcon:
                                              Icon(Iconsax.direct_right),
                                          labelText: TTexts.email,
                                        ),
                                      ),

                                      const SizedBox(height: TSizes.spaceBtwInputFields),

                                      // Password Field
                                      Obx(
                                        () => TextFormField(
                                          controller: controller.password,
                                          validator: (value) => TValidator
                                              .validatePassword(value),
                                          obscureText:
                                              controller.hidePassword.value,
                                          decoration: InputDecoration(
                                            labelText: TTexts.password,
                                            prefixIcon: const Icon(Iconsax.lock),
                                            suffixIcon: IconButton(
                                              onPressed: () => controller
                                                      .hidePassword.value =
                                                  !controller
                                                      .hidePassword.value,
                                              icon: Icon(
                                                  controller.hidePassword.value
                                                      ? Iconsax.eye_slash
                                                      : Iconsax.eye),
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 10),

                                      Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Remember Me
                                          Row(
                                            children: [
                                              Obx(() => Checkbox(
                                                  value: controller
                                                      .rememberMe.value,
                                                  onChanged: (value) =>
                                                      controller.rememberMe
                                                          .value = !controller
                                                              .rememberMe
                                                              .value)),
                                              const Text(TTexts.rememberMe),
                                            ],
                                          ),

                                          // Forget Password
                                          TextButton(
                                            onPressed: () => Get.to(() => const ForgetPasswordScreen()),
                                            child: const Text(TTexts.forgetPassword),
                                            style: TextButton.styleFrom(
                                                foregroundColor: TColors.amber),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Log In Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          bool isLogin =
                              await controller.emailAndPasswordLogIn();
                          if (isLogin) {
                            AuthenticatorRepository.instance.screenRedirect();
                          }
                        },
                        child: const Text(TTexts.logIn),
                      ),
                    ),

                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Create Account Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _showAccountTypeModal(context),
                        child: const Text(TTexts.createAccount),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Divider Section
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Flexible(
          //         child: Divider(
          //             color: dark ? Colors.white : TColors.darkGreen,
          //             thickness: 0.5,
          //             indent: 60,
          //             endIndent: 5)),
          //     Text(TTexts.orLogInWith.capitalize!,
          //         style: Theme.of(context).textTheme.labelMedium),
          //     Flexible(
          //         child: Divider(
          //             color: dark ? Colors.white : TColors.darkGreen,
          //             thickness: 0.5,
          //             indent: 5,
          //             endIndent: 60)),
          //   ],
          // ),

          // const SizedBox(height: TSizes.spaceBtwSections),

          // Footer Section (Restored)
          // const Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          /*Google Button
          Container(
            decoration: BoxDecoration(border: Border.all(color: TColors.olive), borderRadius: BorderRadius.circular(100)),
            child: IconButton(
              onPressed: (){},
              icon: const Image(
                width: TSizes.iconMd,
                height: TSizes.iconMd,
                image: AssetImage(TImages.google),
              )
            ),
          ),*/

          // SizedBox(width: TSizes.spaceBtwItems),

          /* Facebook Button
          Container(
            decoration: BoxDecoration(border: Border.all(color: TColors.olive), borderRadius: BorderRadius.circular(100)),
            child: IconButton(
              onPressed: (){},
              icon: const Image(
                width: TSizes.iconMd,
                height: TSizes.iconMd,
                image: AssetImage(TImages.facebook),
              )
            ),
          ),*/
          //   ],
          // ),
        ],
      ),
    );
  }

  // Method for Create Account Types Modal
  void _showAccountTypeModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 340,
            width: 400,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: TColors.cream,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close Button
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.black, size: 24),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),

                // Title
                Text(
                  'Select Account Type',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 30),

                // Student Button
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: TColors.forest,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Get.to(() =>
                          const RegisterScreen()); // Navigate to RegisterScreen
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.emoji_happy,
                            color: TColors.cream, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Student',
                          style: TextStyle(
                            color: TColors.cream,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 15),

                // Vendor Button
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: TColors.vermillion,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Get.to(() =>
                          VendorRegisterPage()); // Navigate to VendorRegisterPage
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.shop, color: TColors.cream, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Vendor',
                          style: TextStyle(
                            color: TColors.cream,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 15),

                // Support Organisations Button
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: TColors.blush,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Get.to(() => SupportOrganisationRegisterPage());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.people, color: TColors.cream, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Support Organisation',
                          style: TextStyle(
                            color: TColors.cream,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}