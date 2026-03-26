import 'package:get/get.dart';
import '../bindings/account_settings_binding.dart';
import '../bindings/bank_details_binding.dart';
import '../bindings/calling_binding.dart';
import '../bindings/favourites_binding.dart';
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
import '../pages/favourites/favourites_page.dart';
import '../pages/landing/landing_page.dart';
import '../pages/language_selection/language_selection_page.dart';
import '../pages/login/login_page.dart';
import '../pages/login/otp_verification_page.dart';
import '../pages/onboarding/onboarding_page.dart';
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
      name: Routes.splash,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => OnboardingPage(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.otpVerification,
      page: () => OtpVerificationPage(),
      binding: OtpVerificationBinding(),
    ),
    GetPage(
      name: Routes.profileSetup,
      page: () => ProfileSetupPage(),
      binding: ProfileSetupBinding(),
    ),
    GetPage(
      name: Routes.languageSelection,
      page: () => LanguageSelectionPage(),
      binding: LanguageSelectionBinding(),
    ),
    GetPage(
      name: Routes.profileReview,
      page: () => ProfileReviewPage(),
      binding: ProfileReviewBinding(),
    ),
    GetPage(
      name: Routes.landing,
      page: () => LandingPage(),
      binding: LandingBinding(),
    ),
    GetPage(
      name: Routes.favourites,
      page: () => FavouritesPage(),
      binding: FavouritesBinding(),
    ),
    GetPage(
      name: Routes.profileEdit,
      page: () => ProfileEditPage(),
      binding: ProfileEditBinding(),
    ),
    GetPage(
      name: Routes.accountSettings,
      page: () => AccountSettingsPage(),
      binding: AccountSettingsBinding(),
    ),
    GetPage(
      name: Routes.wallet,
      page: () => WalletPage(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: Routes.bankDetails,
      page: () => BankDetailsPage(),
      binding: BankDetailsBinding(),
    ),
    GetPage(
      name: Routes.voiceCalling,
      page: () => VoiceCallingPage(),
      binding: CallingBinding(),
    ),
    GetPage(
      name: Routes.videoCalling,
      page: () => VideoCallingPage(),
      binding: CallingBinding(),
    ),
  ];
}
