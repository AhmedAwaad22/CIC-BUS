import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cicbus/main.dart';
import 'package:cicbus/screens/API_SERVICES.dart';
import 'package:cicbus/screens/NoInternatePageMain.dart';
import 'package:cicbus/screens/PDF.dart';
import 'package:cicbus/screens/SplashScreen.dart';
import 'package:cicbus/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


import 'LoginScreen.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();

  final scrollController = ScrollController();

  @override
  void initState() {
    //_userList.getUserList();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  bool pressed_pdf = false;
  bool visible = false;
  bool pressed = false;
  FetchUserList _userList = FetchUserList();

  refresh() async {
       setState(() {
         _userList.getUserList();
       });


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
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: HexColor('#BD0006'),
              elevation: 0.0,
              titleSpacing: 0.0,
              title: Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () async {
                    Widget AcceptButton = TextButton(
                        onPressed: () async {
                          visible = true;
                           await Logout();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Logged out",
                                style: TextStyle(
                                    color: HexColor('#F5F5F5'),
                                    fontWeight: FontWeight.bold)),
                          ));
                        },
                        child: Text('Yes',
                            style: TextStyle(
                                color: HexColor('#BD0006'),
                                fontSize: 16,
                                fontWeight: FontWeight.bold)));
                    Widget RejectButton = TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('No',
                            style: TextStyle(
                                color: HexColor('#BD0006'),
                                fontSize: 16,
                                fontWeight: FontWeight.bold)));

                    // set up the AlertDialog
                    AlertDialog alert = AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      contentPadding: EdgeInsets.all(30),
                      title: Text(
                        "Logout",
                        style: TextStyle(
                            color: HexColor('#BD0006'),
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                      ),
                      content: Text(
                        'Are you sure to logout from application ?',
                        style: TextStyle(fontSize: 14),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AcceptButton,
                            SizedBox(
                              width: 12,
                            ),
                            RejectButton,
                          ],
                        )
                      ],
                    );
                    // show the dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                        Text(
                          'Logout',
                          style: TextStyle(
                              fontFamily: 'Cairo-ExtraLight',
                              fontSize: 16,
                              fontWeight: FontWeight.w800),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                Row(
                  children: [
                    Text(
                      "Guide",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),

                  ],
                ),
              ],
              automaticallyImplyLeading: false,
              flexibleSpace: SafeArea(
                child: Align(
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    "CIC BUS",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Cairo-VariableFont_wght'),
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                pressed
                    ? Expanded(
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white),
                          child: Column(
                            children: [
                              Row(children: <Widget>[
                                Expanded(
                                  child: new Container(
                                      margin: const EdgeInsets.only(
                                          left: 10.0, right: 15.0),
                                      child: Divider(
                                        thickness: 2,
                                        color: HexColor('#BD0006'),
                                        height: 25,
                                      )),
                                ),
                                Text("User Guide ",
                                    style: TextStyle(
                                        color: HexColor('#BD0006'),
                                        fontSize:
                                            MediaQuery.of(context).size.height * 0.02,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Tajawal-Regular')),
                                Expanded(
                                  child: new Container(
                                      margin: const EdgeInsets.only(
                                          left: 15.0, right: 10.0),
                                      child: Divider(
                                        thickness: 2,
                                        color: HexColor('#BD0006'),
                                        height: 25,
                                      )),
                                ),
                              ]),
                              SizedBox(
                                height: 20,
                              ),
                              Text("PDF manual Guide For All Application",
                                  style: TextStyle(
                                      color: HexColor('#BD0006'),
                                      fontSize:
                                          MediaQuery.of(context).size.height * 0.02,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Tajawal-Regular')),
                              Container(child: Expanded(child: PdfViewerPage())),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
                Expanded(
                  child: FutureBuilder(
                    future: _userList.getUserList(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData) {
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/welcome.svg',
                                height: MediaQuery.of(context).size.height * .2,
                                width: MediaQuery.of(context).size.width * .2,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Center(
                                child: Text(
                                  snapshot.data![0].subscriptionMessage,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize:
                                          MediaQuery.of(context).size.height * .017),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    textStyle: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blue,
                                    ),
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: HexColor('#BD0006'), width: 1),
                                        borderRadius: BorderRadius.circular(25.0)),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen(),
                                            fullscreenDialog: false),
                                        ModalRoute.withName('/')
                                    );
                                  },
                                  child: Text("Refresh",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: HexColor('#BD0006'),
                                          fontWeight: FontWeight.bold)))
                            ],
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Logout() async {

    setState(() {
      visible = true;
    });
    String urlList = 'http://mobile.cic-cairo.edu.eg/BUS/LogoutAPI';
    var url = Uri.parse(urlList);

    final SharedPreferences prefs = await SharedPreferences.getInstance();


    final String? username = prefs.getString('username');
    print(username);
    Map postData_forLogout = {'username': username};
    var response =
    await http.post(url, body: postData_forLogout);
    if (response.statusCode == 200) {

      if(response.body.isNotEmpty) {
        json.decode(response.body);
      }
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LoginScreen(), fullscreenDialog: true));
      prefs.remove('login');


    }




    setState(() {
      visible = false;
    });


  }
}
