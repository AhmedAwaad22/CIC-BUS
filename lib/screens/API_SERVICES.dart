import 'dart:convert';

import 'package:cicbus/model/BusLineAPI.dart';
import 'package:cicbus/screens/LoginScreen.dart';
import 'package:cicbus/screens/UpdateScreenMandatory.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show HttpHeaders, Platform;

class FetchUserList {
  // BuildContext context;
  var data = [];
  List<BusList> results = [];
  String urlList = 'http://mobile.cic-cairo.edu.eg/BUS/BusLines';
  Future<PackageInfo> packageInfo = PackageInfo.fromPlatform();

  //FetchUserList({Key? key,required this.context});

  Future<List<BusList>> getUserList() async {
    var url = Uri.parse(urlList);

    if (Platform.isAndroid) {
      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? campus = prefs.getString('campus');
        //final String? _token = prefs.getString('_token');
        final String? username = prefs.getString('username');
        final String? token = prefs.getString('token');
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String version = packageInfo.version;
        print(campus);
        print("dah token");
        print(token);
        print("dah version");
        print(version);
        Map postdata = {
          'campus': campus,
          'username': username,
          'version': version
        };

        var response = await http.post(url,
            body: postdata,
            headers: {HttpHeaders.userAgentHeader: "AndroidApp omar"});

        if (response.statusCode == 200) {
          data = json.decode(response.body);
          results = data.map((e) => BusList.fromJson(e)).toList();
          //First
          if (results[0].token == "N") {
            Get.to(() => LoginScreen()); //y
          } else {
            if (results[0].update == "Y") {
              Get.to(() => UpdateScreenMandatory());
            }
          }
        }
      } on Exception catch (e) {
        print('error: $e');
      }
    } else if (Platform.isIOS) {
      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? campus = prefs.getString('campus');
        //final String? _token = prefs.getString('_token');
        final String? username = prefs.getString('username');
        PackageInfo packageInfo = await PackageInfo.fromPlatform();

        String version = packageInfo.version;
        print(campus);
        print(username);
        Map postdata = {
          'campus': campus,
          'username': username,
          'version': version
        };

        var response = await http.post(url,
            body: postdata, headers: {HttpHeaders.userAgentHeader: "IosApp"});

        if (response.statusCode == 200) {
          data = json.decode(response.body);
          results = data.map((e) => BusList.fromJson(e)).toList();
          if (results[0].token == "N") {
            Get.to(() => LoginScreen()); //y
          } else {
            if (results[0].update == "Y") {
              Get.to(() => UpdateScreenMandatory());
            }
            //Get.to(() => UpdateScreenMandatory());
          }
        }
      } on Exception catch (e) {
        print('error: $e');
      }
    }

    return results;
  }
}
