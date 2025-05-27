// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/widgets/loaders/loaders.dart';
import 'package:fyp_umakan/features/authentication/controllers/register/register_controller.dart';
import 'package:fyp_umakan/features/authentication/screens/login/login.dart';
import 'package:fyp_umakan/features/authentication/screens/register/personal_details.dart';
import 'package:fyp_umakan/features/authentication/screens/register/verify_email.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/image_strings.dart';
import 'package:fyp_umakan/utils/constants/sizes.dart';
import 'package:fyp_umakan/utils/constants/text_strings.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';
import 'package:fyp_umakan/utils/validators/validation.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/gestures.dart';

class TRegisterForm extends StatelessWidget {
  const TRegisterForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());
    final dark = THelperFunctions.isDarkMode(context);

    return Form(
      key: controller.registerFormKey,
      child: Column(
        children: [
          // Base Detail - Header Label
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionHeader('Base Details', TColors.forest),
            ],
          ),

          // Full Name Field
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.fullName,
                  validator: (value) =>
                      TValidator.validateEmptyText('Full Name', value),
                  decoration: const InputDecoration(
                    labelText: TTexts.fullName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Username Field
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.username,
                  onChanged: (value) => controller.validateUsername(value),
                  validator: (value) =>
                      TValidator.validateEmptyText('Username', value),
                  decoration: InputDecoration(
                    labelText: TTexts.username,
                    prefixIcon: const Icon(Iconsax.verify),
                    errorText: controller.usernameError.value.isNotEmpty
                        ? controller.usernameError.value
                        : null,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Email Field
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.email,
                  validator: (value) => TValidator.validateEmail(value),
                  decoration: const InputDecoration(
                    labelText: TTexts.email,
                    prefixIcon: Icon(Iconsax.direct),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Password Field
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => TextFormField(
                    controller: controller.password,
                    validator: (value) => TValidator.validatePassword(value),
                    obscureText: controller.hidePassword.value,
                    decoration: InputDecoration(
                      labelText: TTexts.password,
                      prefixIcon: const Icon(Iconsax.lock),
                      suffixIcon: IconButton(
                        onPressed: () => controller.hidePassword.value =
                            !controller.hidePassword.value,
                        icon: Icon(controller.hidePassword.value
                            ? Iconsax.eye_slash
                            : Iconsax.eye),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Phone Number Field
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.phoneNumber,
                  validator: (value) => TValidator.validatePhoneNumber(value),
                  decoration: const InputDecoration(
                    labelText: TTexts.phoneNo,
                    prefixIcon: Icon(Iconsax.call),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Matrics Number Field
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.matricsNumber,
                  validator: (value) =>
                      TValidator.validateEmptyText('Matrics Number', value),
                  decoration: const InputDecoration(
                    labelText: TTexts.matricsNumber,
                    prefixIcon: Icon(Iconsax.rulerpen),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Personal Details - Header Label with Info Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionHeader('Personal Details', TColors.forest),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), 
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: TColors.cream,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Title
                                    Text(
                                      "Why we need your personal details?",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: TColors.charcoal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 15),

                                    // Description
                                    Text(
                                      "They are crucial to determine your user category; affecting your budget and diet recommendations.",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: TColors.charcoal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              // Exit Button (Top-right corner)
                              Positioned(
                                top: 10,
                                right: 10,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: const Color.fromARGB(0, 192, 186, 186),
                                    radius: 14,
                                    child: Icon(
                                      Icons.close,
                                      color: TColors.amber,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 15),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: const Color.fromARGB(0, 192, 186, 186),
                    child: Icon(
                      Icons.info_outline,
                      color: TColors.charcoal,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Accommodation Field
          DropdownButtonFormField<String>(
            value: controller.accommodation.text.isNotEmpty
                ? controller.accommodation.text
                : null,
            items: [
              'KK1',
              'KK2',
              'KK3',
              'KK4',
              'KK5',
              'KK6',
              'KK7',
              'KK8',
              'KK9',
              'KK10',
              'KK11',
              'KK12',
              'KK13',
              'Outside Campus'
            ]
                .map((location) => DropdownMenuItem(
                      value: location,
                      child: Text(location),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                controller.accommodation.text = value;
              }
            },
            validator: (value) => value == null || value.isEmpty
                ? 'Please select your accommodation'
                : null,
            decoration: const InputDecoration(
              labelText: 'Accommodation',
              prefixIcon: Icon(Iconsax.house),
            ),
            dropdownColor: TColors.cream,
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Vehicle Ownership Field
          DropdownButtonFormField<String>(
            value: controller.vehicle.text.isNotEmpty
                ? controller.vehicle.text
                : null,
            items: ['Yes', 'No']
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                controller.vehicle.text = value;
              }
            },
            validator: (value) => value == null || value.isEmpty
                ? 'Please select vehicle ownership'
                : null,
            decoration: const InputDecoration(
              labelText: 'Vehicle Ownership',
              prefixIcon: Icon(Iconsax.car),
            ),
            dropdownColor: TColors.cream,
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Marital Status Field
          DropdownButtonFormField<String>(
            value: controller.maritalStatus.text.isNotEmpty
                ? controller.maritalStatus.text
                : null,
            items: ['Married', 'Single']
                .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                controller.maritalStatus.text = value;
              }
            },
            validator: (value) => value == null || value.isEmpty
                ? 'Please select marital status'
                : null,
            decoration: const InputDecoration(
              labelText: 'Marital Status',
              prefixIcon: Icon(Iconsax.heart),
            ),
            dropdownColor: TColors.cream,
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Number of Children Field
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.childrenNumber,
                  validator: (value) =>
                      TValidator.validateEmptyText('Number of Children', value),
                  decoration: const InputDecoration(
                    labelText: 'Number of Children',
                    prefixIcon: Icon(Iconsax.star),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Financial Details - Header Label with Info Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionHeader('Financial Details', TColors.forest),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), 
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: TColors.cream,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Title
                                    Text(
                                      "Why we need your financial details?",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: TColors.charcoal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 15),

                                    // Description
                                    Text(
                                      "Financial details are important to help you track your expenses in money journal.",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: TColors.charcoal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              // Exit Button (Top-right corner)
                              Positioned(
                                top: 10,
                                right: 10,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: const Color.fromARGB(0, 192, 186, 186),
                                    radius: 14,
                                    child: Icon(
                                      Icons.close,
                                      color: TColors.amber,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 15),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: const Color.fromARGB(0, 192, 186, 186),
                    child: Icon(
                      Icons.info_outline,
                      color: TColors.charcoal,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Monthly Allowance Field
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.monthlyAllowance,
                  validator: (value) =>
                      TValidator.validateEmptyText('Monthly Allowance', value),
                  decoration: const InputDecoration(
                    labelText: 'Monthly Allowance',
                    prefixIcon: Icon(Iconsax.money_recive),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Monthly Committments Field
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.monthlyCommittments,
                  validator: (value) => TValidator.validateEmptyText(
                      'Monthly Commitments', value),
                  decoration: const InputDecoration(
                    labelText: 'Monthly Committments (Non-Food)',
                    prefixIcon: Icon(Iconsax.money_remove),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Health Details - Header Label with Info Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionHeader('Health Details', TColors.forest),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), 
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: TColors.cream,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Title
                                    Text(
                                      "Why we need your health details?",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: TColors.charcoal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 15),

                                    // Description
                                    Text(
                                      "Health details are important to help you track your meals in food journal.",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: TColors.charcoal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              // Exit Button (Top-right corner)
                              Positioned(
                                top: 10,
                                right: 10,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: const Color.fromARGB(0, 192, 186, 186),
                                    radius: 14,
                                    child: Icon(
                                      Icons.close,
                                      color: TColors.amber,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 15),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: const Color.fromARGB(0, 192, 186, 186),
                    child: Icon(
                      Icons.info_outline,
                      color: TColors.charcoal,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Gender Dropdown
          DropdownButtonFormField<String>(
            value: controller.gender.text.isNotEmpty
                ? controller.gender.text
                : null,
            items: ['Male', 'Female']
                .map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                controller.gender.text = value;
              }
            },
            validator: (value) => value == null || value.isEmpty
                ? 'Please select your gender'
                : null,
            decoration: const InputDecoration(
              labelText: 'Gender',
              prefixIcon: Icon(Iconsax.personalcard),
            ),
            dropdownColor: TColors.cream,
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    // Open date picker
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: TColors.teal,
                              onPrimary: Colors.white,
                              onSurface: TColors.darkGreen,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (pickedDate != null) {
                      // Format the selected date
                      String formattedDate =
                          "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";

                      // Update the controller's birthdate value
                      controller.birthdate.text = formattedDate;
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: controller.birthdate,
                      validator: (value) =>
                          TValidator.validateEmptyText('Birthdate', value),
                      decoration: const InputDecoration(
                        labelText: 'Birthdate (dd/mm/yyyy)',
                        prefixIcon: Icon(Iconsax.calendar),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.height,
                  validator: (value) =>
                      TValidator.validateEmptyText('Height', value),
                  decoration: const InputDecoration(
                    labelText: 'Height (cm)',
                    prefixIcon: Icon(Iconsax.ruler),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.weight,
                  validator: (value) =>
                      TValidator.validateEmptyText('Weight', value),
                  decoration: const InputDecoration(
                    labelText: 'Weight (kg)',
                    prefixIcon: Icon(Iconsax.weight),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwSections),

          /*Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Obx(
                  () => Checkbox(
                      value: controller.privacyPolicy.value,
                      onChanged: (value) => controller.privacyPolicy.value =
                          !controller.privacyPolicy.value),
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
                      style: Theme.of(context).textTheme.bodyMedium!.apply(
                            color: dark ? Colors.white : TColors.teal,
                            decoration: TextDecoration.underline,
                            decorationColor: dark ? Colors.white : TColors.teal,
                          )),
                  TextSpan(
                      text: '${TTexts.and} ',
                      style: Theme.of(context).textTheme.bodySmall),
                  TextSpan(
                      text: TTexts.termsOfUse,
                      style: Theme.of(context).textTheme.bodyMedium!.apply(
                            color: dark ? Colors.white : TColors.teal,
                            decoration: TextDecoration.underline,
                            decorationColor: dark ? Colors.white : TColors.teal,
                          )),
                ]),
              ),
            ],
          ),*/

          // Terms & Conditions
          Obx(() {
            final dark = THelperFunctions.isDarkMode(context);
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: controller.agreedToTerms.value,
                  onChanged: (v) => controller.agreedToTerms.value = v ?? false,
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: Theme.of(context).textTheme.bodySmall,
                      children: [
                        TextSpan(text: 'I agree to the '),
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: dark ? Colors.white : TColors.teal,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // TODO: launch your Terms & Conditions URL
                            },
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: dark ? Colors.white : TColors.teal,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // TODO: launch your Privacy Policy URL
                            },
                        ),
                        TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),

          const SizedBox(height: TSizes.spaceBtwSections),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (!controller.agreedToTerms.value) {
                  TLoaders.errorSnackBar(
                    title: 'Ooops!',
                    message: 'You must accept our Terms & Conditions.',
                  );
                  return;
                }
                controller.register();
              },
              child: const Text('Register'),
            ),
          ),

          const SizedBox(height: TSizes.spaceBtwSections),

          /*Divider
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                  child: Divider(
                      color: dark ? Colors.white : TColors.darkGreen,
                      thickness: 0.5,
                      indent: 60,
                      endIndent: 5)),
              Text(TTexts.orRegisterWith.capitalize!,
                  style: Theme.of(context).textTheme.labelMedium),
              Flexible(
                  child: Divider(
                      color: dark ? Colors.white : TColors.darkGreen,
                      thickness: 0.5,
                      indent: 5,
                      endIndent: 60)),
            ],
          ), */

          const SizedBox(height: TSizes.spaceBtwSections),

          // Footer
          /* const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /* Google Button
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: TColors.olive),
                    borderRadius: BorderRadius.circular(100)),
                child: IconButton(
                    onPressed: () {},
                    icon: const Image(
                      width: TSizes.iconMd,
                      height: TSizes.iconMd,
                      image: AssetImage(TImages.google),
                    )),
              ),*/

              // SizedBox(width: TSizes.spaceBtwItems),

              /* Facebook Button
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: TColors.olive),
                    borderRadius: BorderRadius.circular(100)),
                child: IconButton(
                    onPressed: () {},
                    icon: const Image(
                      width: TSizes.iconMd,
                      height: TSizes.iconMd,
                      image: AssetImage(TImages.facebook),
                    )),
              ),*/
            ],
          ),*/
        ],
      ),
    );
  }
  // Section Header Widget
  Widget _sectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 4,
            height: 40,
            color: color,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
