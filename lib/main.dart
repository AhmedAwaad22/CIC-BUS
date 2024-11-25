import 'dart:async';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
