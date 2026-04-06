import 'package:get/get.dart';

import '../bindings/account_settings_binding.dart';
import '../bindings/bank_details_binding.dart';
import '../bindings/calling_binding.dart';
import '../bindings/help_binding.dart';
import '../bindings/landing_binding.dart';
import '../bindings/language_selection_binding.dart';
import '../bindings/login_binding.dart';
import '../bindings/onboarding_binding.dart';
import '../bindings/otp_verification_binding.dart';
import '../bindings/profile_edit_binding.dart';
import '../bindings/profile_review_binding.dart';
import '../bindings/profile_setup_binding.dart';
import '../bindings/splash_binding.dart';
import '../bindings/wallet_binding.dart';
import '../pages/account_settings/account_settings_page.dart';
import '../pages/calling/video_calling_page.dart';
import '../pages/calling/voice_calling_page.dart';
import '../pages/help/help_page.dart';
import '../pages/landing/landing_page.dart';
import '../pages/language_selection/language_selection_page.dart';
import '../pages/login/login_page.dart';
import '../pages/login/otp_verification_page.dart';
import '../pages/onboarding/onboarding_page.dart';
import '../pages/policy/policy_page.dart';
import '../pages/profile_edit/profile_edit_page.dart';
import '../pages/profile_setup/profile_review_page.dart';
import '../pages/profile_setup/profile_setup_page.dart';
import '../pages/splash/splash_page.dart';
import '../pages/wallet/bank_details_page.dart';
import '../pages/wallet/wallet_page.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => OnboardingPage(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.otpVerification,
      page: () => OtpVerificationPage(),
      binding: OtpVerificationBinding(),
    ),
    GetPage(
      name: AppRoutes.profileSetup,
      page: () => ProfileSetupPage(),
      binding: ProfileSetupBinding(),
    ),
    GetPage(
      name: AppRoutes.languageSelection,
      page: () => LanguageSelectionPage(),
      binding: LanguageSelectionBinding(),
    ),
    GetPage(
      name: AppRoutes.profileReview,
      page: () => ProfileReviewPage(),
      binding: ProfileReviewBinding(),
    ),
    GetPage(
      name: AppRoutes.landing,
      page: () => LandingPage(),
      binding: LandingBinding(),
    ),
    GetPage(
      name: AppRoutes.profileEdit,
      page: () => ProfileEditPage(),
      binding: ProfileEditBinding(),
    ),
    GetPage(
      name: AppRoutes.accountSettings,
      page: () => AccountSettingsPage(),
      binding: AccountSettingsBinding(),
    ),
    GetPage(
      name: AppRoutes.wallet,
      page: () => WalletPage(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: AppRoutes.bankDetails,
      page: () => BankDetailsPage(),
      binding: BankDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.voiceCalling,
      page: () => VoiceCallingPage(),
      binding: CallingBinding(),
    ),
    GetPage(
      name: AppRoutes.videoCalling,
      page: () => VideoCallingPage(),
      binding: CallingBinding(),
    ),
    GetPage(
      name: AppRoutes.policy,
      page: () {
        final args = Get.arguments;
        if (args is PolicyArguments) {
          return PolicyPage(url: args.url, title: args.title);
        } else {
          throw ArgumentError('Invalid arguments for PolicyPage');
        }
      },
    ),
    GetPage(
      name: AppRoutes.help,
      page: () => HelpPage(),
      binding: HelpBinding(),
    ),
  ];
}
