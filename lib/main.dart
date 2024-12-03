import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fyp_umakan/data/repositories/authentication/authentication_repository.dart';
import 'package:fyp_umakan/data/repositories/money_journal/money_journal_repository.dart';
import 'package:fyp_umakan/data/repositories/user/user_repository.dart';
import 'package:fyp_umakan/features/foodjournal/controller/food_journal_controller.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/utils/helpers/network_manager.dart';
import 'package:fyp_umakan/utils/scripts/add_authority_account.dart';
import 'package:fyp_umakan/utils/scripts/add_community_news_sample_data.dart';
import 'package:fyp_umakan/utils/scripts/add_sample_data.dart';
import 'package:fyp_umakan/utils/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';
import 'firebase_options.dart';

// void main(){
//   runApp(const App());
// }

Future<void> main() async {
  // Widgets Binding
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase & Authenticate Repository
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then(
    (FirebaseApp value) => Get.put(AuthenticatorRepository()),
  );

  // GetX Local Storage
  await GetStorage.init();

  //Initalise Controllers and User Repository
  Get.put(UserController());
  //Get.put(UserRepository());
  // Get.put(MoneyJournalRepository());
  Get.put(NetworkManager());
  Get.put(VendorController());
  Get.put(FoodJournalController());

  // addSampleOrganisations();
  // addSampleCommunityNews();
  // addAuthorityAccount();

  // Await Splash Until Other Items Load
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const App());
}
