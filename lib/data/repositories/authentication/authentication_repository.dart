import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fyp_umakan/authority_navigation_menu.dart';
import 'package:fyp_umakan/features/authentication/models/user_model.dart';
import 'package:fyp_umakan/features/authentication/screens/homepage/homepage.dart';
import 'package:fyp_umakan/features/authentication/screens/login/login.dart';
import 'package:fyp_umakan/features/authentication/screens/onboarding/onboarding.dart';
import 'package:fyp_umakan/features/authentication/screens/register/register.dart';
import 'package:fyp_umakan/features/authentication/screens/register/verify_email.dart';
import 'package:fyp_umakan/features/authority/screens/authority_home_page.dart';
import 'package:fyp_umakan/features/student_management/controllers/update_profile_controller.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/vendor_repository.dart';
import 'package:fyp_umakan/navigation_menu.dart';
import 'package:fyp_umakan/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:fyp_umakan/utils/exceptions/firebase_exceptions.dart';
import 'package:fyp_umakan/utils/exceptions/format_exceptions.dart';
import 'package:fyp_umakan/utils/exceptions/platform_exceptions.dart';
import 'package:fyp_umakan/vendor_navigation_menu.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fyp_umakan/data/repositories/user/user_repository.dart';

class AuthenticatorRepository extends GetxController {
  static AuthenticatorRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;
  final UserRepository userRepository = Get.put(UserRepository());
  final VendorRepository vendorRepository = Get.put(VendorRepository());

  // Get Authenticated User
  User? get authUser => _auth.currentUser;

  @override
  void onReady() {
    //Remove Native Splash Screen
    FlutterNativeSplash.remove();
    //Redirect to the appropriate Screen
    screenRedirect();
  }

  //Function to Show relevant Screen
  screenRedirect() async {
    final user = _auth.currentUser;

    // If user is logged in
    if (user != null) {
      await user.reload(); // Refresh user state
      final updatedUser = _auth.currentUser;

      if (updatedUser != null && updatedUser.emailVerified) {
        try {
          // Check if the user exists in the "Users" collection
          String? role = await userRepository.fetchUserRole(updatedUser.uid);

          if (role == 'Vendor') {
            // If the user is in the Vendors collection, redirect to VendorNavigationMenu
            debugPrint('Redirecting to Vendor Navigation Menu');
            Get.off(() => const VendorNavigationMenu());
          } else if (role == 'Authority') {
            // If the user is in the Authority collection, redirect to AuthorityHomePage
            debugPrint('Redirecting to Authority Navigation Menu');
            Get.off(() => AuthorityNavigationMenu());
          } else {
            // Otherwise, redirect to the NavigationMenu for regular users
            debugPrint('Redirecting to Navigation Menu');
            Get.off(() => NavigationMenu());
          }
        } catch (e) {
          debugPrint("Redirection Error: $e");
          Get.snackbar("Error", "Failed to fetch user role. Please try again.");
        }
      } else {
        // If the user's email is not verified, navigate to the VerifyEmailScreen
        Get.offAll(() => VerifyEmailScreen(email: updatedUser?.email));
      }
    } else {
      // Handle first-time user onboarding or login screen redirection
      deviceStorage.writeIfNull('isFirstTime', true);
      bool isFirstTime = deviceStorage.read('isFirstTime') ?? true;

      if (isFirstTime) {
        Get.offAll(() => const OnBoardingScreen());
        deviceStorage.write('isFirstTime', false);
      } else {
        Get.offAll(() => const LoginScreen());
      }
    }

    if (kDebugMode) {
      print('=================== GET STORAGE AUTH ===================');
      print(deviceStorage.read('isFirstTime'));
    }
  }

  // Register ------------------------------------
  Future<UserCredential> registerWithEmailandPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Login ------------------------------------------
  Future<UserCredential> loginWithEmailandPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //Email Verification-----------------------
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //Send Password Reset-----------------------
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Logout ------------------------------------------
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.delete<UpdateProfileController>();
      Get.delete<UserController>();
      Get.delete<VendorController>();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
