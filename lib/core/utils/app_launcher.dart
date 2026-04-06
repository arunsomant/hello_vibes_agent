import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../presentation/widgets/index.dart';

class AppLauncher {
  static void makePhoneCall(String phoneNumber) async {
    if (!phoneNumber.startsWith('+')) {
      if (phoneNumber.toString().length <= 4) {
        phoneNumber = phoneNumber;
      } else {
        phoneNumber = '+91$phoneNumber';
      }
    }

    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  static void openWhatsApp(String phoneNumber, String text) async {
    var iosUrl =
        'https://api.whatsapp.com/send/?phone=$phoneNumber&text=${Uri.parse(text)}';
    try {
      await launchUrl(Uri.parse(iosUrl), mode: LaunchMode.externalApplication);
    } catch (_) {
      AppDialog.showToast(
          'Could not launch WhatsApp. Make sure it is installed on the device.');
    }
  }

  static void openUrl(String url) async {
    try {
      if (!url.startsWith('http')) {
        url = 'https://$url';
      }

      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static void mail(String email) async {
    try {
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: email,
      );

      await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
