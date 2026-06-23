import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Constants/colors.dart';
import '../Constants/styles.dart';
import 'custom_text.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final bool isPayment;
  const WebViewScreen({required this.url, this.isPayment = false, super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
/*
          onNavigationRequest: (NavigationRequest request) {
            if (widget.isPayment) {
              final uri = request.url.toLowerCase();

              // ── Adjust these keywords to match your payment gateway ──
              final bool isSuccess =
                  uri.contains('success') ||
                      uri.contains('payment_success') ||
                      uri.contains('transaction_success') ||
                      uri.contains('status=success') || uri.contains('redirect=true');

              final bool isFailed =
                  uri.contains('failed') ||
                      uri.contains('payment_failed') ||
                      uri.contains('cancel');

              if (isSuccess) {
                Navigator.pop(context, 'success');
                return NavigationDecision.prevent;
              }

              if (isFailed) {
                Navigator.pop(context, 'failed');
                return NavigationDecision.prevent;
              }
            }
            return NavigationDecision.navigate;
          },
*/
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: Container(

          child: Stack(
            children: [
              WebViewWidget(controller: _controller),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
            ],
          ),
        ),
      ),
    );
  }
}