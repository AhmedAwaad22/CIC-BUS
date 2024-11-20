import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cicbus/screens/API_SERVICES.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateScreenCrt extends GetxController {
  String imgName = '33984-update.json';
  late var timer;

  ButtonToMakeUpdate() {
    if (Platform.isAndroid || Platform.isIOS) {
      final appId = Platform.isAndroid ? 'com.zcic.cicbus' : '1640899336';
      final url = Uri.parse(
        Platform.isAndroid
            ? "market://details?id=$appId"
            : "https://apps.apple.com/app/id$appId",
      );
      launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
    update();
  }
}
