import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/support_organisation/controller/support_organisation_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/sizes.dart';
import 'package:get/get.dart';

class SupportOrganisationRegisterPage extends StatelessWidget {
  const SupportOrganisationRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SupportOrganisationController _controller =
        Get.put(SupportOrganisationController());
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: TColors.cream,
      appBar: AppBar(
        backgroundColor: TColors.cream,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: _controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Image
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image(
                        height: 160,
                        image: AssetImage('assets/images/Support.png'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                Text(
                  'Let\'s Create Your Support Organisation Account',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                // Organisation Name
                TextFormField(
                  controller: _controller.organisationNameController,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter organisation name' : null,
                  decoration: const InputDecoration(
                    labelText: 'Organisation Name',
                    prefixIcon: Icon(Icons.business),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Email
                TextFormField(
                  controller: _controller.emailController,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter email' : null,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Password
                Obx(
                  () => TextFormField(
                    controller: _controller.passwordController,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter your password' : null,
                    obscureText: _controller.hidePassword.value,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_controller.hidePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          _controller.hidePassword.value =
                              !_controller.hidePassword.value;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Contact Number
                TextFormField(
                  controller: _controller.contactNumberController,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter contact number' : null,
                  decoration: const InputDecoration(
                    labelText: 'Contact Number',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Location Dropdown
                DropdownButtonFormField<String>(
                  value: _controller.location.value.isEmpty
                      ? null
                      : _controller.location.value,
                  items: _controller.locationOptions
                      .map((loc) => DropdownMenuItem(
                            value: loc,
                            child: Text(loc),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      _controller.location.value = value ?? '',
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please select a location' : null,
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Active Status Dropdown
                DropdownButtonFormField<String>(
                  value: _controller.activeStatus.value.isEmpty
                      ? null
                      : _controller.activeStatus.value,
                  items: _controller.statusOptions
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      _controller.activeStatus.value = value ?? 'Active',
                  decoration: const InputDecoration(
                    labelText: 'Active Status',
                    prefixIcon: Icon(Icons.work),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                // Agree to Privacy Policy
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Obx(
                        () => Checkbox(
                            value: _controller.privacyPolicy.value,
                            onChanged: (value) => _controller.privacyPolicy
                                .value = !_controller.privacyPolicy.value),
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Text.rich(
                      TextSpan(children: [
                        TextSpan(
                            text: 'I agree to the ',
                            style: Theme.of(context).textTheme.bodySmall),
                        TextSpan(
                            text: 'Privacy Policy',
                            style: Theme.of(context).textTheme.bodyMedium!.apply(
                                  color: dark ? Colors.white : TColors.teal,
                                  decoration: TextDecoration.underline,
                                )),
                        TextSpan(
                            text: ' and ',
                            style: Theme.of(context).textTheme.bodySmall),
                        TextSpan(
                            text: 'Terms of Use',
                            style: Theme.of(context).textTheme.bodyMedium!.apply(
                                  color: dark ? Colors.white : TColors.teal,
                                  decoration: TextDecoration.underline,
                                )),
                      ]),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_controller.formKey.currentState?.validate() ??
                          false) {
                        _controller.register();
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