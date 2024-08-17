import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cicbus/main.dart'; // Update with your actual project imports if needed

class AddBalance extends StatefulWidget {
  const AddBalance({super.key});

  @override
  State<AddBalance> createState() => _AddBalanceState();
}

class _AddBalanceState extends State<AddBalance> {
  late int id;
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://pub.dev/'));

  @override
  void initState() {
    super.initState();
    // Initialize the WebView plugin if needed
    // WebView.platform = SurfaceAndroidWebView();
  }

  // Function to show the help dialog
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('How to Pay on Klickit'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('1. Navigate to the payment section.'),
                Text('2. Enter your payment details carefully.'),
                Text('3. Review the information and confirm the payment.'),
                Text('4. Wait for the confirmation message.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Got it!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText(
          'Add Balance',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            fontFamily: 'Cairo-VariableFont_wght',
          ),
        ),
        backgroundColor: HexColor('#9e1510'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White back button
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white), // White help icon
            onPressed: _showHelpDialog, // Show help dialog when pressed
          ),
        ],
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
