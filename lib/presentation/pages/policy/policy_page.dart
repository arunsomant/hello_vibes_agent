import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/web_endpoints.dart';
import '../../widgets/index.dart';

class PolicyArguments {
  final String url;
  final String title;

  PolicyArguments({required this.url, this.title = ''});

  factory PolicyArguments.privacyPolicy() {
    return PolicyArguments(url: WebEndpoints.policy, title: 'Privacy Policy');
  }

  factory PolicyArguments.termsAndConditions() {
    return PolicyArguments(
      url: WebEndpoints.terms,
      title: 'Terms & Conditions',
    );
  }

  factory PolicyArguments.communityGuidelines() {
    return PolicyArguments(
      url: WebEndpoints.guidelines,
      title: 'Community Guidelines',
    );
  }

  factory PolicyArguments.safetyCenter() {
    return PolicyArguments(url: WebEndpoints.safety, title: 'Safety Center');
  }

  factory PolicyArguments.coinPolicy() {
    return PolicyArguments(url: WebEndpoints.coinPolicy, title: 'Coin Policy');
  }
}

class PolicyPage extends StatelessWidget {
  const PolicyPage({super.key, required this.url, this.title = ''});

  final String title;

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        top: false,
        child: AppWebView(
          url:
              '${AppConfig.baseUrl}$url?app=${AppConfig.appName}&theme=${'light'}',
        ),
      ),
    );
  }
}
