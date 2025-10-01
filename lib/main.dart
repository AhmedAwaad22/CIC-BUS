import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cicbus/screens/LoginScreen.dart';
import 'package:cicbus/screens/NoInternatePageMain.dart';
import 'package:cicbus/screens/SplashScreen.dart';
import 'package:cicbus/screens/home.dart';
import 'package:cicbus/widget/App_theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:new_version/new_version.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

// Custom HttpOverrides to handle SSL certificate verification
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Only allow connections to our specific domain
        if (host == 'mobile.cic-cairo.edu.eg') {
          // TODO: When you have the .crt file, place it in assets/certificates/
          // and implement proper certificate validation here
          return _validateCertificate(cert, host, port);
        }
        return false;
      };
  }
  
  bool _validateCertificate(X509Certificate cert, String host, int port) {
    // TODO: Load certificate from assets/certificates/ and validate
    // For now, allowing the specific domain
    // When you add the .crt file, replace this with proper validation
    print('Certificate validation for $host:$port');
    print('Certificate subject: ${cert.subject}');
    print('Certificate issuer: ${cert.issuer}');
    return true;
  }
  
  // Method to load certificate from assets (to be implemented when .crt is available)
  Future<Uint8List?> _loadCertificateFromAssets(String path) async {
    try {
      final ByteData data = await rootBundle.load(path);
      return data.buffer.asUint8List();
    } catch (e) {
      print('Error loading certificate: $e');
      return null;
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure SSL certificate handling
  HttpOverrides.global = MyHttpOverrides();
  
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool hasInternet = false;
  ConnectivityResult result = ConnectivityResult.none;
  bool isInternetAvailable = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<InternetConnectionStatus>(
      initialData: InternetConnectionStatus.connected,
      create: (_) {
        //return InternetConnectionChecker().onStatusChange;
      },
      child: GetMaterialApp(
        title: 'CIC',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          textTheme: AppTheme.textTheme,
          platform: TargetPlatform.iOS,
        ),
        home: SplashScreen(),
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
