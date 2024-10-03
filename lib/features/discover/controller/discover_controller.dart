import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/features/vendor/model/vendor_model.dart';
import 'package:fyp_umakan/features/vendor/vendor_repository.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DiscoverController extends GetxController {
  static DiscoverController get instance => Get.find();

  final VendorRepository vendorRepository;
  var cafe = <CafeDetails>[].obs;
  var menuItems = <CafeItem>[].obs;
  var isLoading = true.obs;

  DiscoverController(this.vendorRepository);
  late String userId;

  @override
  void onInit() {
    super.onInit();
    // Get the current user ID when the controller is initialized
    userId = getCurrentUserId();
    print("Current user id: ${userId}");
  }

  String getCurrentUserId() {
    // Get the current user from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (user != null) {
      // Return the user ID (UID)
      return user.uid;
    } else {
      // Handle the case when there is no user logged in
      throw Exception('No user is currently signed in');
    }
  }

  void fetchAndPrintVendorNames() async {
    final vendorRepository = VendorRepository();
    final vendors = await vendorRepository.getAllVendors();

    for (var vendor in vendors) {
      print("Vendor Name: ${vendor.vendorName}"); // Print the vendor names
    }
  }

  void fetchAllCafesFromAllVendors() async {
    final allCafes = await vendorRepository.getAllCafesFromAllVendors();
    print(
        "Total cafes fetched from all vendors: ${allCafes.length}"); // Debug log
    cafe.assignAll(allCafes); // Update observable list with all cafes
  }

  void fetchAllCafes() async {
    final allCafes = await vendorRepository.getAllCafes();
    print("Fetched cafes: $allCafes");
    cafe.assignAll(allCafes);
  }

  Future<void> fetchMenuItems(String vendorId, String cafeId) async {
    try {
      isLoading.value = true;
      menuItems.clear();

      // Call the getItemsForCafe method from VendorRepository
      List<CafeItem> items =
          await vendorRepository.getItemsForCafe(vendorId, cafeId);

      menuItems.addAll(items);
    } catch (e) {
      print("Error fetching menu items: $e");
      Get.snackbar('Error', 'Failed to load menu items');
    } finally {
      isLoading.value = false;
    }
  }
}
