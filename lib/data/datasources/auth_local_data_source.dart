import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  static const String token = 'authorization_token';
  static const String deviceDetailsSaved = 'device_details_saved';
  static const String onboardingCompleted = 'onboarding_completed';

  Future<bool> saveAccessToken(String accessToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(token, accessToken);
  }

  Future<String> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(token) ?? '';
  }

  Future<void> clearAccessToken() async {
    await saveAccessToken('');
  }

  Future<bool> saveDeviceDetailsAdded(bool tokenSaved) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(deviceDetailsSaved, tokenSaved);
  }

  Future<bool> getDeviceDetailsAdded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(deviceDetailsSaved) ?? false;
  }

  Future<bool> saveOnboardingCompleted(bool completed) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(onboardingCompleted, completed);
  }

  Future<bool> getOnboardingCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(onboardingCompleted) ?? false;
  }

  Future<bool> clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}
