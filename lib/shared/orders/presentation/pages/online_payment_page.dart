import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wisatabumnag/app/router/app_router.dart';

class OnlinePaymentPage extends StatefulWidget {
  const OnlinePaymentPage({
    required this.url,
    super.key,
  });
  final String url;

  @override
  State<OnlinePaymentPage> createState() => _OnlinePaymentPageState();
}

class _OnlinePaymentPageState extends State<OnlinePaymentPage> {
  @override
  void initState() {
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran Online'),
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (navigation) {
          final url = Uri.parse(navigation.url);
          if (url.path.contains('payments/complete')) {
            context.goNamed(AppRouter.paymentDone, extra: true);
            return NavigationDecision.prevent;
          }
          if (url.path.contains('payments/incomplete')) {
            context.pop();
            return NavigationDecision.prevent;
          }
          if (url.path.contains('payments/error')) {
            context.goNamed(AppRouter.paymentDone, extra: false);
            return NavigationDecision.prevent;
          }

          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
