import 'package:cicbus/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart'; // Import the correct WebView package

class WebViewPage extends StatefulWidget {
  final String url;
  
  WebViewPage({required this.url});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _webViewController;
  bool isLoading = true; // to track page load state

  @override
  void initState() {
    super.initState();
    // Initialize WebView
    _initializeWebView();
  }

  // Initialize WebView and set controller
  void _initializeWebView() async {
    // Initialize WebView package and set up the controller
    //await WebViewController.setWebContentsDebuggingEnabled(true); // enable debugging in development mode
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Allow JS execution
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (String url) {
          setState(() {
            isLoading = true; // Show loading indicator when page starts loading
          });
        },
        onPageFinished: (String url) {
          setState(() {
            isLoading = false; // Hide loading indicator when page finishes loading
          });
        },
        onWebResourceError: (error) {
          setState(() {
            isLoading = false; // Hide loading on error
          });
        },
      ));

    // Now load the URL
    _webViewController.loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // When the back button is pressed, pop the current page
        Navigator.of(context).pop();
        // After popping, push the same page again to "reopen" it
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => HomeScreen()), // Replace 'YourPage' with your actual page widget
        );
        // Returning false prevents the default back action (e.g., exiting the app)
        return Future.value(false);
      },
      child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Page',
          style: TextStyle(color: Colors.white), // Set the text color to white
        ),
        backgroundColor: Color(0xFF9e1510),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Set the back button color to white
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ), // Your existing AppBar background color
      ),
        body: Stack(
        children: [
          WebViewWidget(
            controller: _webViewController,
          ),
          if (isLoading) // Show loading indicator while the page is loading
            const Center(
              child: CircularProgressIndicator(),
          ),
         ],
       ),
      ),
    );
  }
}