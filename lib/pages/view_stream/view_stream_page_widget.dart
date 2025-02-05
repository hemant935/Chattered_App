import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LiveStreamWebView extends StatefulWidget {
  final String liveStreamUrl;

  const LiveStreamWebView({super.key, required this.liveStreamUrl});

  @override
  State<LiveStreamWebView> createState() => _LiveStreamWebViewState();
}

class _LiveStreamWebViewState extends State<LiveStreamWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Enable JavaScript
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Show progress if needed
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          // onHttpError: (HttpResponseError error) {
          //   debugPrint("HTTP Error: ${error.description}");
          // },
          onWebResourceError: (WebResourceError error) {
            debugPrint("WebView Error: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.liveStreamUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Stream')),
      body: WebViewWidget(controller: controller),
    );
  }
}