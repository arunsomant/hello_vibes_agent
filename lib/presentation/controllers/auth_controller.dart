import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/utils/app_exception.dart';
import '../../data/models/user.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../routes/app_routes.dart';
import '../widgets/index.dart';

class AuthController extends GetxController {
  AuthController({required this.authRepository, required this.userRepository});

  final AuthRepository authRepository;
  final UserRepository userRepository;

  final user = User().obs;

  void gotoLandingPage() async {
    try {
      final token = await authRepository.getAccessToken();
      if (token.isNotEmpty) {
        await _fetchUserProfile();
        if (user.value.name.isEmpty ||
            user.value.avatar.url.isEmpty ||
            user.value.gender.isEmpty ||
            user.value.dob == null) {
          _gotoProfileSetupPage();
        } else if (user.value.languages.isEmpty) {
          _gotoLanguageSelectionPage();
        } else if (user.value.approvalStatus != ApprovalStatus.approved) {
          _gotoProfileReviewPage();
        } else {
          _gotoLandingPage();
        }
      } else if (!await authRepository.getOnboardingCompleted()) {
        _gotoOnboardingPage();
      } else {
        _gotoLoginPage();
      }
    } on UnauthorisedException catch (_) {
      AppDialog.showSnackBar('Login Failed', 'Something went wrong!');
      logout();
    } catch (_) {
      _showToast(
        'An error occurred while fetching user data. Please try again.',
      );
    }
  }

  void signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'https://www.googleapis.com/auth/userinfo.profile'],
      );
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return null; // User canceled login

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // Sign in with Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final String? firebaseIdToken = await userCredential.user?.getIdToken();

      loginWithFirebaseToken(firebaseIdToken!);
    } catch (_) {
      _showToast('Something went wrong!');
    }
  }

  void _gotoOnboardingPage() {
    Get.offAllNamed(AppRoutes.onboarding);
  }

  void _gotoLandingPage() {
    Get.offAllNamed(AppRoutes.landing);
  }

  void _gotoProfileSetupPage() {
    Get.offAllNamed(AppRoutes.profileSetup);
  }

  void _gotoLanguageSelectionPage() {
    Get.offAllNamed(AppRoutes.languageSelection);
  }

  void _gotoProfileReviewPage() {
    Get.offAllNamed(AppRoutes.profileReview);
  }

  Future<void> logout() async {
    try {
      final response = await authRepository.logout();
      if (response.success) {
        await authRepository.clearAccessToken();
      } else {
        _showToast(response.message);
      }
    } catch (_) {
      _showToast('An error occurred while logging out.');
    } finally {
      await authRepository.clearAllLocalData();
      _gotoLoginPage();
    }
  }

  Future<void> deleteAccount() async {
    try {
      final response = await authRepository.deleteAccount();
      if (response.success) {
        await authRepository.clearAllLocalData();
      } else {
        _showToast(response.message);
      }
    } catch (_) {
      _showToast('An error occurred while deleting account.');
    } finally {
      await authRepository.clearAllLocalData();
      _gotoLoginPage();
    }
  }

  void _gotoLoginPage() {
    Get.offAllNamed(AppRoutes.login);
  }

  void loginWithFirebaseToken(String token) async {
    try {
      final response = await authRepository.loginUsingFirebase(token: token);
      if (response.success) {
        await authRepository.saveAccessToken(response.loginData.token);
        gotoLandingPage();
      } else {
        _showToast(response.message);
      }
    } catch (_) {
      _showToast('Login Failed');
    } finally {}
  }

  void _showToast(String message) {
    AppDialog.showToast(message);
  }

  void getUserProfile() async {
    try {
      await _fetchUserProfile();
    } catch (_) {
      _showToast(
        'An error occurred while fetching user data. Please try again.',
      );
    }
  }

  Future<void> _fetchUserProfile() async {
    final response = await userRepository.getUser();
    if (response.success) {
      user(response.user);
      user.refresh();
    }
  }

  Future<(String, int)> getVersionCode() async {
    final bundle = DefaultAssetBundle.of(Get.context!);
    final pubspec = await bundle.loadString('pubspec.yaml');
    final version = pubspec.split('version: ')[1];
    final vName = version.split('+')[0];
    final vCode = int.tryParse(version.split('+')[1].split('\n')[0]) ?? 0;
    return (vName, vCode);
  }
}
