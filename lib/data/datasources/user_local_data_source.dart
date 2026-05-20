import 'package:shared_preferences/shared_preferences.dart';

class UserLocalDataSource {
  static const String welcomeDialogShown = 'welcome_dialog_shown';
  static const String skippedVersionUpdate = 'skipped_version_update';

  Future<bool> saveWelcomeDialogShown(bool shown) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(welcomeDialogShown, shown);
  }

  Future<bool> getWelcomeDialogShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(welcomeDialogShown) ?? false;
  }

  Future<bool> saveSkippedVersionUpdate(int version) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(skippedVersionUpdate, version);
  }

  Future<int> getSkippedVersionUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(skippedVersionUpdate) ?? 0;
  }
}
