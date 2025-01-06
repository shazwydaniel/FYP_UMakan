import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/image_strings.dart';
import 'package:fyp_umakan/utils/constants/sizes.dart';
import 'package:fyp_umakan/utils/constants/text_strings.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';
import 'package:fyp_umakan/utils/validators/validation.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class VendorRegisterPage extends StatelessWidget {
  const VendorRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate the VendorController
    final VendorController vendorController = Get.put(VendorController());
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: TColors.cream,
      appBar: AppBar(
        backgroundColor: TColors.cream,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: vendorController.vendorFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image(
                        height: 200,
                        image: AssetImage(
                            dark ? TImages.burger2 : TImages.burger2),
                      ),
                    ),
                  ],
                ),
                Text(TTexts.signupVendorTitle.capitalize!,
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: TSizes.spaceBtwSections),
                TextFormField(
                  controller: vendorController.vendorEmail,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Obx(
                  () => TextFormField(
                    controller: vendorController.vendorPassword,
                    validator: (value) => TValidator.validatePassword(value),
                    obscureText: vendorController.hidePassword.value,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () => vendorController.hidePassword.value =
                            !vendorController.hidePassword.value,
                        icon: Icon(vendorController.hidePassword.value
                            ? Iconsax.eye_slash
                            : Iconsax
                                .eye), // Add password toggle logic if needed
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  controller: vendorController.vendorName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Vendor Name',
                    prefixIcon: Icon(Icons.store),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  controller: vendorController.contactInfo,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact info';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Contact Info',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                /*  Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Obx(
                        () => Checkbox(
                            value: vendorController.privacyPolicy.value,
                            onChanged: (value) => vendorController.privacyPolicy
                                .value = !vendorController.privacyPolicy.value),
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Text.rich(
                      TextSpan(children: [
                        TextSpan(
                            text: '${TTexts.iAgreeTo} ',
                            style: Theme.of(context).textTheme.bodySmall),
                        TextSpan(
                            text: '${TTexts.privacyPolicy} ',
                            style:
                                Theme.of(context).textTheme.bodyMedium!.apply(
                                      color: dark ? Colors.white : TColors.teal,
                                      decoration: TextDecoration.underline,
                                      decorationColor:
                                          dark ? Colors.white : TColors.teal,
                                    )),
                        TextSpan(
                            text: '${TTexts.and} ',
                            style: Theme.of(context).textTheme.bodySmall),
                        TextSpan(
                            text: TTexts.termsOfUse,
                            style:
                                Theme.of(context).textTheme.bodyMedium!.apply(
                                      color: dark ? Colors.white : TColors.teal,
                                      decoration: TextDecoration.underline,
                                      decorationColor:
                                          dark ? Colors.white : TColors.teal,
                                    )),
                      ]),
                    ),
                  ],
                ),*/
                const SizedBox(height: TSizes.spaceBtwSections),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (vendorController.vendorFormKey.currentState
                              ?.validate() ??
                          false) {
                        vendorController.register();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      backgroundColor: TColors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
