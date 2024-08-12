import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/styles/spacing_styles.dart';
import 'package:fyp_umakan/features/authentication/controllers/login/login_controller.dart';
import 'package:fyp_umakan/features/authentication/screens/homepage/homepage.dart';
import 'package:fyp_umakan/features/authentication/screens/password_config/forget_password.dart';
import 'package:fyp_umakan/features/authentication/screens/register/register.dart';
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
      backgroundColor: dark ? TColors.cream : TColors.cream,
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    height: 200, 
                    image: AssetImage(dark ? TImages.appLogo : TImages.appLogo),
                  ),
                  Text(
                    TTexts.loginTitle, 
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: TSizes.sm),

                  Text(
                    TTexts.loginSubTitle, 
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: TSizes.lg),
                ],
              ),

              Form(
                key: controller.loginFormKey,
                child: Padding(
                padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
                child: Column(
                  children: [
                    // Email
                    TextFormField(
                      controller: controller.email,
                      validator: (value) => TValidator.validateEmail(value),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Iconsax.direct_right),
                        labelText: TTexts.email,
                      ),
                    ),
                
                    // White Space
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                
                    // Password
                    Obx(
                    () => TextFormField(
                      controller: controller.password,
                      validator: (value) => TValidator.validatePassword(value),
                      obscureText: controller.hidePassword.value,
                      decoration: InputDecoration(
                        labelText: TTexts.password,
                        prefixIcon: const Icon(Iconsax.lock),
                        suffixIcon: IconButton(
                          onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                          icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                          ),
                      ),
                    ),
                  ),
                
                    // White Space
                    const SizedBox(height: TSizes.spaceBtwInputFields / 2),
                
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Remember Me
                        Row(
                          children: [
                            Obx(() => Checkbox(
                              value: controller.rememberMe.value, 
                              onChanged: (value) => controller.rememberMe.value = !controller.rememberMe.value)),
                            const Text(TTexts.rememberMe),
                          ],
                        ),
                
                        // Forget Password
                        TextButton(onPressed: () => Get.to(() => const ForgetPasswordScreen()), 
                        child: const Text(TTexts.forgetPassword),
                        style: TextButton.styleFrom(
                          foregroundColor: TColors.amber
                        ),
                        ),
                      ],
                    ),
                
                    // White Space
                    const SizedBox(height: TSizes.spaceBtwSections),
                
                    // Log In Button
                    SizedBox(width: double.infinity, child: ElevatedButton(
                      // onPressed: () => controller.emailAndPasswordLogIn(), 
                      onPressed: () async {
                        bool isLogin = await controller.emailAndPasswordLogIn();
                        if (isLogin) {
                          Get.to(() => NavigationMenu());
                          print('-------------SUCCESSFULLY LOGGED IN!--------------');
                        }
                      },
                      child: const Text(TTexts.logIn))),
                    const SizedBox(height: TSizes.spaceBtwItems),
                
                    // Create Account Button
                    SizedBox(
                      width: double.infinity, 
                      child: OutlinedButton(onPressed: () => Get.to(() => const RegisterScreen()), child: const Text(TTexts.createAccount))),
                  ],
                ),
              ),
            ),

            // Divider
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child: Divider(color: dark? Colors.white : TColors.darkGreen, thickness: 0.5, indent: 60, endIndent: 5)),
                Text(TTexts.orLogInWith.capitalize!, style: Theme.of(context).textTheme.labelMedium),
                Flexible(child: Divider(color: dark? Colors.white : TColors.darkGreen, thickness: 0.5, indent: 5, endIndent: 60)),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Google Button
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
                ),

                const SizedBox(width: TSizes.spaceBtwItems),

                // Facebook Button
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
                ),

              ],
            ),

            ],
          )
        )
      )
    );
  }
}