import 'dart:async';
import 'dart:convert';
import 'package:cicbus/model/BusLineAPI.dart';
import 'package:cicbus/screens/LoginScreen.dart';
import 'package:cicbus/screens/NoInternatePageMain.dart';
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
        Provider.of<InternetConnectionStatus>(context) == InternetConnectionStatus.disconnected
            ? Expanded(
          child: NoInternet(),
        ):
            Expanded(
              child:  Scaffold(
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


  var data = [];
  var data2 = [];
  List<TokenApiNew> results = [];
  List<BusList> results2 = [];
  String urlList = 'http://mobile.cic-cairo.edu.eg/BUS/BusLines';
  Future<List<TokenApiNew>> getUserLogin() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username')?? "";
    String username2 = "False";
    final String? campus = prefs.getString('campus');
    var url = Uri.parse('http://mobile.cic-cairo.edu.eg/BUS/GetToken');
    var url2 = Uri.parse('http://mobile.cic-cairo.edu.eg/BUS/BusLines');




    Map postdata2 = { 'username': username,'campus':campus};

if(username == "")
  {
    Map postdata = { 'username': username2};
    var response = await http.post(url,
        body: postdata);
    if (response.statusCode == 200) {
      data = json.decode(response.body);
      results = data.map((e) => TokenApiNew.fromJson(e)).toList();
      if(results[0].token == 'N')
      {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));
      }
      else{
        Timer(Duration(seconds: 2), () {
          getValidationData().whenComplete(() async {
            if (loginToken == false) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginScreen()));
            } else if(loginToken == true) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                  fullscreenDialog: true));
            }
          });
        });
      }
    }
  }
else
  {
    final String? username = prefs.getString('username');
    final String? campus = prefs.getString('campus');
    var url2 = Uri.parse('http://mobile.cic-cairo.edu.eg/BUS/BusLines');
    Map postdata2 = { 'username': username,'campus':campus};
    var response = await http.post(url2,
        body: postdata2);
    if (response.statusCode == 200)
    {
      Timer(Duration(seconds: 2), () {
        getValidationData().whenComplete(() async {
          if (loginToken == false) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => LoginScreen()));
          } else if(loginToken == true) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeScreen(),
                fullscreenDialog: true));
          }
        });
      });
    }
  }

    return results;
  }
}
