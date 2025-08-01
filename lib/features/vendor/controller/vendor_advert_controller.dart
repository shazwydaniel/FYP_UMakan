import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/widgets/loaders/loaders.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/model/advertisment/vendor_adverts_model.dart';
import 'package:fyp_umakan/features/vendor/vendor_repository.dart';
import 'package:fyp_umakan/utils/helpers/network_manager.dart';
import 'package:fyp_umakan/vendor_navigation_menu.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdvertController extends GetxController {
  static AdvertController get instance => Get.find();

  final TextEditingController adDetail = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  var selectedStatus = ''.obs;

  //For Updating
  final detailUpdateController = TextEditingController();
  final startDateUpdateController = TextEditingController();
  final endDateUpdateController = TextEditingController();
  final RxString statusUpdate = 'Promotion'.obs;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  GlobalKey<FormState> updateForm = GlobalKey<FormState>();

  //For the form
  GlobalKey<FormState> menuFormKey = GlobalKey<FormState>();
  Rx<Advertisement> advertisment = Advertisement.empty().obs;
  final vendorRepository = VendorRepository.instance;
  final vendorController = Get.put(VendorController());
  var allAdvertisements = <Advertisement>[].obs;

  //init user data when Home Screen Appears
  @override
  void onInit() {
    super.onInit();
    initalizeNames();
  }

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
        String cafeLocation = cafeDetails.location;

        // Create a map for the menu item data
        Map<String, dynamic> adData = {
          'cafeName': cafeName,
          'cafeId': cafeId,
          'location': cafeLocation,
          'detail': adDetail.text.trim(),
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
          'status': selectedStatus.value,
        };

        // Call the repository method to add the item to Firestore
        await vendorRepository.addAdvertisementToCafe(vendorId, cafeId, adData);

        // Fetch advertisements again to update the UI
        fetchAdvertisementsByCafe(vendorId, cafeId);

        // Clear the text fields after adding the item
        adDetail.clear();
        startDateController.clear();
        endDateController.clear();

        // Print confirmation
        print('Advert added for $cafeName');
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
    allAdvertisements
        .assignAll(allAds); // Update observable list with all cafes
  }

  void fetchVendorAds() async {
    List<Advertisement> allAds = await vendorRepository
        .getAllAdvertisementsForVendor(vendorController.currentUserId);

    allAdvertisements
        .assignAll(allAds); // Update observable list with all cafes
  }

  //Fetch User Record
  Future<void> initalizeNames() async {
    if (advertisment.value != null) {
      detailUpdateController.text = advertisment.value.detail ?? '';
      startDateUpdateController.text = advertisment.value.startDate != null
          ? dateFormat.format(advertisment.value.startDate!)
          : '';
      endDateUpdateController.text = advertisment.value.endDate != null
          ? dateFormat.format(advertisment.value.endDate!)
          : '';
    } else {
      detailUpdateController.clear();
      startDateUpdateController.clear();
      endDateUpdateController.clear();
    }
  }

  Future<void> updateAds(String vendorId, String cafeId, String adId) async {
    try {
      // Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.errorSnackBar(
            title: 'No Internet',
            message: 'Please check your internet connection.');
        return;
      }

      // Form Validation
      if (!updateForm.currentState!.validate()) {
        TLoaders.errorSnackBar(
            title: 'Invalid Input',
            message: 'Please fill all the required fields correctly.');
        return;
      }

      // Update data in Firebase Firestore
      Map<String, dynamic> detailUpdated = {
        'detail': detailUpdateController.text.trim()
      };
      Map<String, dynamic> startDateUpdated = {
        'startDate': startDateUpdateController.text.trim()
      };
      Map<String, dynamic> endDateUpdated = {
        'endDate': endDateUpdateController.text.trim()
      };
      Map<String, dynamic> statusUpdated = {'status': selectedStatus.value};

      // Use methods in User Repository to transfer to Firebase
      await vendorRepository.updateSingleFieldAdvert(
          detailUpdated, vendorId, cafeId, adId);
      await vendorRepository.updateSingleFieldAdvert(
          startDateUpdated, vendorId, cafeId, adId);
      await vendorRepository.updateSingleFieldAdvert(
          endDateUpdated, vendorId, cafeId, adId);
      await vendorRepository.updateSingleFieldAdvert(
          statusUpdated, vendorId, cafeId, adId);

      // Update Rx value safely
      advertisment.value.detail = detailUpdateController.text.trim();
      advertisment.value.startDate =
          DateTime.tryParse(startDateUpdateController.text.trim());
      advertisment.value.endDate =
          DateTime.tryParse(endDateUpdateController.text.trim());
      advertisment.value.status = selectedStatus.value;

      if (selectedStatus.value.isEmpty) {
        TLoaders.warningSnackBar(
            title: 'Status missing',
            message: 'Please select advertisement type.');
        return;
      }

      // Fetch advertisements again to update the UI
      fetchAdvertisementsByCafe(vendorId, cafeId);

      // Show success Message
      TLoaders.successSnackBar(
          title: 'Congratulations',
          message: "Your advertisement has been updated!");

      Get.off(() => const VendorNavigationMenu(), transition: Transition.fade);
    } catch (e) {
      // Log the error for debugging
      debugPrint("Error update: $e");
      TLoaders.errorSnackBar(title: 'Oops!', message: e.toString());
    }
  }

  Future<void> deleteAd(String vendorId, String cafeId, String adId) async {
    try {
      await vendorRepository.deleteAd(vendorId, cafeId, adId);
      allAdvertisements.removeWhere((ad) => ad.id == adId); // Update local list
      TLoaders.successSnackBar(
        title: 'Deleted',
        message: 'Advertisement has been deleted successfully!',
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  void fetchAdvertisementsByCafe(String vendorId, String cafeId) async {
    try {
      // Clear the current advertisements
      allAdvertisements.clear();

      // Fetch advertisements from Firestore
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Vendors')
          .doc(vendorId)
          .collection('Cafe')
          .doc(cafeId)
          .collection('Advertisements')
          .get();

      allAdvertisements.value = querySnapshot.docs
          .map((doc) => Advertisement.fromFirestore(doc))
          .toList();

      // Map the query results to Advertisement objects
      final ads = querySnapshot.docs.map((doc) {
        return Advertisement.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      // Update the observable list
      allAdvertisements.assignAll(ads);
    } catch (e) {
      print('Error fetching advertisements: $e');
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to fetch advertisements',
      );
    }
  }

  Future<List<Advertisement>> fetchBantuanAds() async {
    final allAds = await fetchAll(); // Your existing fetch logic
    final now = DateTime.now();

    return allAds.where((ad) {
      final isBantuan = ad.status == 'Bantuan';
      final isActive = ad.startDate != null &&
          ad.endDate != null &&
          ad.startDate!.isBefore(now) &&
          ad.endDate!.isAfter(now);
      return isBantuan && isActive;
    }).toList();
  }

  Future<List<Advertisement>> fetchAll() async {
    return await vendorRepository.getAllAdvertisementsFromAllCafes();
  }
}
