import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'pdf_viewer_screen.dart';

class ElokPortalScreen extends StatefulWidget {
  const ElokPortalScreen({super.key});

  @override
  State<ElokPortalScreen> createState() => _ElokPortalScreenState();
}

class _ElokPortalScreenState extends State<ElokPortalScreen> {
  double _progress = 0;
  InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Portal eLOK UGM"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _webViewController?.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri("https://elok.ugm.ac.id"),
            ),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              domStorageEnabled: true,
              javaScriptCanOpenWindowsAutomatically: true,
              useShouldOverrideUrlLoading: true,
              mediaPlaybackRequiresUserGesture: false,
              allowsInlineMediaPlayback: true,
              useOnDownloadStart: true,
              supportZoom: true,
              builtInZoomControls: true,
              displayZoomControls: false,
              allowFileAccessFromFileURLs: true,
              allowUniversalAccessFromFileURLs: true,
              mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
            ),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },

            shouldOverrideUrlLoading: (controller, navigationAction) async {
              var uri = navigationAction.request.url;

              if (uri != null && uri.path.toLowerCase().endsWith(".pdf")) {
                CookieManager cookieManager = CookieManager.instance();
                List<Cookie> cookies = await cookieManager.getCookies(
                  url: WebUri("https://elok.ugm.ac.id"),
                );

                String cookieString = cookies
                    .map((c) => "${c.name}=${c.value}")
                    .join("; ");
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewerScreen(
                        pdfUrl: uri.toString(),
                        cookie: cookieString,
                      ),
                    ),
                  );
                }
                return NavigationActionPolicy.CANCEL;
              }
              return NavigationActionPolicy.ALLOW;
            },
            onDownloadStartRequest: (controller, downloadStartRequest) async {
              var url = downloadStartRequest.url;

              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Gak bisa buka link download-nya, Bro!"),
                  ),
                );
              }
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                _progress = progress / 100;
              });
            },
          ),
          if (_progress < 1.0)
            LinearProgressIndicator(value: _progress, color: Colors.orange),
        ],
      ),
    );
  }
}
