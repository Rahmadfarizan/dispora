import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SarprasWidget extends StatefulWidget {
  @override
  _SarprasWidgetState createState() => _SarprasWidgetState();
}

class _SarprasWidgetState extends State<SarprasWidget> {
  late final WebViewController _controller;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();

    final WebViewController controller = WebViewController();

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
              hasError = false;
            });
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
              hasError = false;
            });
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isLoading = false;
              hasError = true;
            });
            debugPrint('''
              Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
            ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('Blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('Allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('URL change to ${change.url}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(
          'https://sarpras-eporabertuah.pekanbaru.go.id/PetaSarpras'));

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        WebViewWidget(
          controller: _controller,
        ),
        if (isLoading)
          _buildLoadingWidget()
        else if (hasError)
          _buildErrorWidget()
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: SizedBox(
        width: 200.0,
        height: 100.0,
        child: Shimmer.fromColors(
          baseColor: const Color(0xff29366A),
          highlightColor: const Color(0xffF05C39),
          period: const Duration(milliseconds: 1200),
          child: Image.asset("assets/logodispora.png"),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Text(
        'Failed to load the page',
        style: TextStyle(fontSize: 18, color: Colors.red),
      ),
    );
  }
}
