import 'dart:convert';
import 'dart:io';

import 'package:cicbus/main.dart';
import 'package:cicbus/screens/API_SERVICES.dart';
import 'package:cicbus/screens/UpdateScreenMandatory.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../model/BusLineAPI.dart';
import '../screens/LoginScreen.dart';

class CloseCrt extends GetxController {
  FetchUserList _userList = FetchUserList();

  @override
  void onInit() {
    _userList.getUserList().obs;
    super.onInit();
  }

  Logout() async {
    String urlList = 'https://mobile.cic-cairo.edu.eg/BUS/LogoutAPI';
    var url = Uri.parse(urlList);

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? username = prefs.getString('username');
    print(username);
    Map postData_forLogout = {'username': username};
    var response = await http.post(url, body: postData_forLogout);
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        json.decode(response.body);
      }
      Get.to(() => LoginScreen());
      prefs.remove('login');
      Get.snackbar(
        "Logout",
        "MAKE IT HAPPEN",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.black,
      );
      // here
    }
  }

  var data = [];
  List<BusList> results = [];
  String urlList = 'https://mobile.cic-cairo.edu.eg/BUS/BusLines';
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
          update();
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
