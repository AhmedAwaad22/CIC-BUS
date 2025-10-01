import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cicbus/model/BusLineAPI.dart';
import 'package:cicbus/screens/LoginScreen.dart';
import 'package:cicbus/screens/NoInternatePageMain.dart';
import 'package:cicbus/screens/No_Server_Screen.dart';
import 'package:cicbus/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../model/TokenModel.dart';

String? finalEmail;
bool loginToken = false;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getUserLogin();
    super.initState();
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedToken = sharedPreferences.getBool('login') ?? false;
    setState(() {
      loginToken = obtainedToken;
    });
    print(loginToken);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Provider.of<InternetConnectionStatus>(context) ==
                InternetConnectionStatus.disconnected
            ? Expanded(
                child: NoInternet(),
              )
            : Expanded(
                child: Scaffold(
                  body: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image.asset(
                          'assets/images/splash_2.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Center(
                        child: Image.asset(
                          'assets/images/logo_2.png',
                          width: 400.0,
                          height: 400.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }
 
 /*  var data = [];
  var data2 = [];
  List<TokenApiNew> results = [];
  List<BusList> results2 = [];
  String urlList = 'https://mobile.cic-cairo.edu.eg/BUS/BusLines';
  Future<List<TokenApiNew>> getUserLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username') ?? "";
    String username2 = "False";
    final String? campus = prefs.getString('campus');
    var url = Uri.parse('https://mobile.cic-cairo.edu.eg/BUS/GetToken');
    var url2 = Uri.parse('https://mobile.cic-cairo.edu.eg/BUS/BusLines');
   
    if (username == "") {
      Map postdata = {'username': username2};
      var response = await http.post(url, body: postdata);
      if (response.statusCode == 200) {
        data = json.decode(response.body);
        results = data.map((e) => TokenApiNew.fromJson(e)).toList();
        if (results[0].token == 'N') {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LoginScreen()));
        } else {
          Timer(Duration(seconds: 2), () {
            getValidationData().whenComplete(() async {
              if (loginToken == false) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              } else if (loginToken == true) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                    fullscreenDialog: true));
              }
            });
          });
        }
      }
    } else {
      final String? username = prefs.getString('username');
      final String? campus = prefs.getString('campus');
      var url2 = Uri.parse('https://mobile.cic-cairo.edu.eg/BUS/BusLines');
      Map postdata2 = {'username': username, 'campus': campus};
      var response = await http.post(url2, body: postdata2);
      if (response.statusCode == 200) {
        Timer(Duration(seconds: 2), () {
          getValidationData().whenComplete(() async {
            if (loginToken == false) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginScreen()));
            } else if (loginToken == true) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomeScreen(), fullscreenDialog: true));
            }
          });
        });
      }
    }

    return results;
  } */

 var data = [];
  var data2 = [];
  List<TokenApiNew> results = [];
  List<BusList> results2 = [];
  Future<List<TokenApiNew>> getUserLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username') ?? "";
    String username2 = "False";
    final String? campus = prefs.getString('campus');
    var url = Uri.parse('https://mobile.cic-cairo.edu.eg/BUS/GetToken');
    var url2 = Uri.parse('https://mobile.cic-cairo.edu.eg/BUS/BusLines');

    Map postdata2 = {'username': username, 'campus': campus};
    print('hesho');
    try {
      if (username == "") {
        Map postdata = {'username': username2};

        // Make HTTP POST request with error handling
        print('awaaaaaaaaaaaad');
        //var response = await http.post(url, body: postdata);
        var response = await http.post(url, body: postdata).timeout(
          Duration(seconds: 2),
          onTimeout: () {
            throw TimeoutException('The connection has timed out!');
          },
        );
        if (response.statusCode == 200) {
          data = json.decode(response.body);
          results = data.map((e) => TokenApiNew.fromJson(e)).toList();
          if (results[0].token == 'N') {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          } else {
            Timer(Duration(seconds: 2), () {
              getValidationData().whenComplete(() async {
                if (loginToken == false) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                } else if (loginToken == true) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                      fullscreenDialog: true,
                    ),
                  );
                }
              });
            });
          }
        } else {
          throw HttpException('Server responded with status: ${response.statusCode}');
        }
      } else {
        final String? username = prefs.getString('username');
        final String? campus = prefs.getString('campus');
        Map postdata2 = {'username': username, 'campus': campus};

       // var response = await http.post(url2, body: postdata2);
        var response = await http.post(url2, body: postdata2).timeout(
          Duration(seconds: 2),
          onTimeout: () {
            throw TimeoutException('The connection has timed out!');
          },
        );
       
        if (response.statusCode == 200) {
          Timer(Duration(seconds: 2), () {
            getValidationData().whenComplete(() async {
              if (loginToken == false) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              } else if (loginToken == true) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                    fullscreenDialog: true,
                  ),
                );
              }
            });
          });
        } else {
          throw HttpException('Server responded with status: ${response.statusCode}');
        }
      }
    } on SocketException catch (e) {
      print('Network error: $e');
      // Show an alert dialog for network error
        showDialog(
          context: context,
          builder: (context) {
            return NoInternet();
          },
        );
    } on HttpException catch (e) {
      print('Server error: $e');
      // Show an alert dialog for server error
      _showErrorDialog('Server Error', 'Unable to connect to the server. Please try again later.');
    } catch (e) {
      print('Unexpected error: $e');
      // Handle any other unexpected errors
      _showErrorDialog('Error', 'An unexpected error occurred.');
    }

    return results;
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return NoServer();
      },
    );
  }
 
}
