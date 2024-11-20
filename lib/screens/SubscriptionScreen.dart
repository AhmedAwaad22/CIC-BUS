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
        Provider.of<InternetConnectionStatus>(context) ==
                InternetConnectionStatus.disconnected
            ? Expanded(
                child: NoInternet(),
              )
            : Expanded(
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: HexColor(
                        '#9e1510'), // Sets background color of the AppBar
                    elevation: 0.0, // Removes shadow
                    titleSpacing:
                        0.0, // Removes spacing between title and start of AppBar
                    title: Align(
                      alignment:
                          Alignment.topLeft, // Aligns the title to the top left
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: InkWell(
                                onTap: () async {
                                  // Define Accept and Reject buttons
                                  Widget acceptButton = TextButton(
                                    onPressed: () {
                                      // Call the Logout function on accept
                                      Logout();
                                    },
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(
                                        color: HexColor('#BD0006'),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );

                                  Widget rejectButton = TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog on reject
                                    },
                                    child: Text(
                                      'No',
                                      style: TextStyle(
                                        color: HexColor('#BD0006'),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );

                                  // Set up the AlertDialog
                                  AlertDialog alert = AlertDialog(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    contentPadding: EdgeInsets.all(30),
                                    title: Text(
                                      "Logout",
                                      style: TextStyle(
                                        color: HexColor('#BD0006'),
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Text(
                                      'Are you sure you want to logout from the application?',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          acceptButton,
                                          SizedBox(width: 12),
                                          rejectButton,
                                        ],
                                      ),
                                    ],
                                  );

                                  // Show the AlertDialog
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return alert;
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                      size: 30.0,
                                    ),
                                    SizedBox(
                                        width:
                                            8), // Add spacing between icon and text
                                    Text(
                                      'Logout',
                                      style: TextStyle(
                                        fontFamily: 'Cairo-ExtraLight',
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      IconButton(
                        color: Colors.white,
                        onPressed: () async {
                          setState(() {
                            pressed = !pressed; // Toggle the pressed state
                          });
                        },
                        icon: pressed
                            ? Icon(Icons.help)
                            : Icon(Icons.help_outline),
                      ),
                    ],
                    automaticallyImplyLeading:
                        false, // Prevents default back button
                    flexibleSpace: SafeArea(
                      child: Align(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          "CIC Bus",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Cairo-VariableFont_wght',
                          ),
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
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02,
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
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Tajawal-Regular')),
                                    Container(
                                        child:
                                            Expanded(child: PdfViewerPage())),
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                            ),
                      Expanded(
                        child: FutureBuilder(
                          future: _userList.getUserList(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasError) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasData) {
                              return Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/welcome.svg',
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .2,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .2,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .050, // Left padding
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .050, // Right padding
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.all(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .025),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                // Add gradient background for a smooth transition of colors
                                                colors: [
                                                  Colors.red,
                                                  Colors.white
                                                ], // Define two gradient colors (red to orange)
                                                begin: Alignment
                                                    .topLeft, // Start of gradient (top-left)
                                                end: Alignment
                                                    .bottomRight, // End of gradient (bottom-right)
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(
                                                      0.2), // Soft shadow with some transparency
                                                  offset: Offset(0,
                                                      4), // Shadow positioned slightly below the container
                                                  blurRadius:
                                                      6, // Makes the shadow softer and spread out
                                                  spreadRadius:
                                                      2, // Makes the shadow expand
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Column(
                                              // Use a Column to stack two Text widgets
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  snapshot.data![0]
                                                      .subscriptionMessageEN, // First subscription message
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .020,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        10), // Add space between the texts
                                                Text(
                                                  snapshot.data![0]
                                                      .subscriptionMessageAR, // Second subscription message
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .020,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            textStyle: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                            primary: HexColor(
                                                '#BD0006'), // Button background color
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15.0,
                                                horizontal:
                                                    40.0), // Padding for the button
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: HexColor('#BD0006'),
                                                  width: 1),
                                              borderRadius: BorderRadius.circular(
                                                  30.0), // Rounded button corners
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeScreen()),
                                              ModalRoute.withName('/'),
                                            );
                                          },
                                          child: Text(
                                            "Refresh",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
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
    var response = await http.post(url, body: postData_forLogout);
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
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
