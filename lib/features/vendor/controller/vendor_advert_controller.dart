import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/model/advertisment/vendor_adverts_model.dart';
import 'package:fyp_umakan/features/vendor/vendor_repository.dart';
import 'package:get/get.dart';

class AdvertController extends GetxController {
  static AdvertController get instance => Get.find();

  final TextEditingController adDetail = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  GlobalKey<FormState> menuFormKey = GlobalKey<FormState>();
  Rx<Advertisement> advertisment = Advertisement.empty().obs;
  final vendorRepository = VendorRepository.instance;
  final vendorController = VendorController.instance;

  var allAdvertisements = <Advertisement>[].obs;

  //Get Cafe from Id

  // Add method to handle adding menu items
  Future<void> addAdvert(String vendorId, String cafeId) async {
    if (menuFormKey.currentState?.validate() ?? false) {
      try {
        // Parse the start date
        DateTime? startDate =
            DateTime.tryParse(startDateController.text.trim());

        // Parse the end date
        DateTime? endDate = DateTime.tryParse(endDateController.text.trim());

        // Ensure that both dates are valid
        if (startDate == null || endDate == null) {
          throw Exception('Invalid date entered.');
        }

        //Get cafe name
        CafeDetails cafeDetails =
            await vendorRepository.getCafeById(vendorId, cafeId);
        String cafeName = cafeDetails.name;

        // Create a map for the menu item data
        Map<String, dynamic> adData = {
          'cafeName': cafeName,
          'detail': adDetail.text.trim(),
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
        };

        // Call the repository method to add the item to Firestore
        await vendorRepository.addAdvertisementToCafe(vendorId, cafeId, adData);

        // Clear the text fields after adding the item
        adDetail.clear();
        startDateController.clear();
        endDateController.clear();

        // Print confirmation
        print('Advert added! $cafeName = $cafeDetails');
      } catch (e) {
        // Handle error
        print('Error adding menu item: $e');
      }
    }
  }

// Dispose the controllers to free memory when they are no longer needed.
  void dispose() {
    adDetail.dispose();
    startDateController.dispose();
    endDateController.dispose();
  }

  // Method to collect the advertisement data and print it (or save it elsewhere)
  void submitAdvert(BuildContext context) {
    String detail = adDetail.text;

    String startDate = startDateController.text;
    String endDate = endDateController.text;

    // Example of what you can do with the data (e.g., save to database)
    print('Advertisement Added: $detail, $startDate, $endDate');

    // Close the page after submission (optional)
    Navigator.pop(context);
  }

  void fetchAllAdvertisements() async {
    List<Advertisement> allAds =
        await vendorRepository.getAllAdvertisementsFromAllCafes();
    print(
        "Total cafes fetched from all vendors: ${allAds.length}"); // Debug log
    allAdvertisements
        .assignAll(allAds); // Update observable list with all cafes
  }
}
