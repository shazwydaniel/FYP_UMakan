import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fyp_umakan/features/authentication/screens/login/login.dart';
import 'package:fyp_umakan/features/authentication/screens/register/register.dart';
import 'package:fyp_umakan/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:fyp_umakan/utils/exceptions/firebase_exceptions.dart';
import 'package:fyp_umakan/utils/exceptions/format_exceptions.dart';
import 'package:fyp_umakan/utils/exceptions/platform_exceptions.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticatorRepository extends GetxController {
  static AuthenticatorRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  screenRedirect() async {
    if (kDebugMode) {
      print('=================== GET STORAGE AUTH ===================');
      print(deviceStorage.read('isFirstTime'));
    }

    //Local Storage
    deviceStorage.writeIfNull('isFirstTime', true);
    deviceStorage.read('isFirstTime') != true  ? Get.offAll(() => const LoginScreen()) : Get.offAll(() => const LoginScreen());
    // Change to landing page later
  }

  // Register ------------------------------------
  Future<UserCredential> registerWithEmailandPassword(String email, String password) async {
    try{
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
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
  Future<UserCredential> loginWithEmailandPassword(String email, String password) async {
    try{
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
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