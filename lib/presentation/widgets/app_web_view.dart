import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class AppWebView extends StatelessWidget {
  const AppWebView({
    super.key,
    required this.url,
    this.onLoadStart,
    this.onLoadStop,
  });

  final String url;

  final Function(InAppWebViewController controller, WebUri? url)? onLoadStart;

  final Function(InAppWebViewController controller, WebUri? url)? onLoadStop;

  @override
  Widget build(BuildContext context) {
    print("Loading URL: $url");
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri((url))),
      onWebViewCreated: (webViewController) {},
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        final uri = navigationAction.request.url;
        if (uri == null) return NavigationActionPolicy.ALLOW;

        final scheme = uri.scheme;

        if (!["http", "https", "file", "about", "data"].contains(scheme)) {
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            debugPrint("Cannot handle URL: $uri");
          }
          return NavigationActionPolicy.CANCEL;
        }

        return NavigationActionPolicy.ALLOW;
      },
      onLoadStop: onLoadStop,
      onLoadStart: onLoadStart,
    );
  }
}
