import 'package:shared_preferences/shared_preferences.dart';

class CallLocalDataSource {
  static const String lastCallDetails = 'last_call_details';

  Future<bool> saveCallDetails(String call) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(lastCallDetails, call);
  }

  Future<String> getCallDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(lastCallDetails) ?? '';
  }
}
