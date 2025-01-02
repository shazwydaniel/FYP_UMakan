import 'package:flutter/material.dart';
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
            dropdownColor: TColors.cream, // Match the dropdown color
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

// Location Dropdown
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

// Vehicle Ownership Dropdown
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

// Marital Status Dropdown
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

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.monthlyCommittments,
                  validator: (value) => TValidator.validateEmptyText(
                      'Monthly Commitments', value),
                  decoration: const InputDecoration(
                    labelText: 'Monthly Committments (Non Food)',
                    prefixIcon: Icon(Iconsax.money_remove),
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

          const SizedBox(height: TSizes.spaceBtwInputFields),

          Row(
            children: [
              Expanded(
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
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwSections),

          Row(
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
          ),

          const SizedBox(height: TSizes.spaceBtwSections),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () => controller.register(),
                //async {
                //bool isRegistered = await controller.register();
                //if (isRegistered) {
                //Get.to(() => const VerifyEmailScreen());
                //print('-------------SUCCESSFULLY REGISTERED!--------------');
                //}
                // },
                child: const Text('Next')),
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
          const Row(
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

              SizedBox(width: TSizes.spaceBtwItems),

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
          ),
        ],
      ),
    );
  }
}
