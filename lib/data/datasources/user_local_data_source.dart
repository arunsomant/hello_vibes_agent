import 'package:shared_preferences/shared_preferences.dart';

class UserLocalDataSource {
  static const String welcomeDialogShown = 'welcome_dialog_shown';

  Future<bool> saveWelcomeDialogShown(bool shown) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(welcomeDialogShown, shown);
  }

  Future<bool> getWelcomeDialogShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(welcomeDialogShown) ?? false;
  }
}
