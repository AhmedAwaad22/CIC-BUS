import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cicbus/main.dart';
import 'package:cicbus/model/BusLineAPI.dart';
import 'package:cicbus/screens/API_SERVICES.dart';
import 'package:cicbus/screens/LoginScreen.dart';
import 'package:cicbus/screens/NoInternatePageMain.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HoldScreen extends StatefulWidget {
  const HoldScreen({Key? key}) : super(key: key);

  @override
  State<HoldScreen> createState() => _HoldScreenState();
}

class _HoldScreenState extends State<HoldScreen> {
  FetchUserList _userList = FetchUserList();
  bool visible = false;
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
                  backgroundColor: Colors.white70,
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

                                    // Set up the container with gradient background
                                    Container customDialog = Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          // Add gradient background for a smooth transition of colors
                                          colors: [
                                            Colors.white,
                                            Colors.white,
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
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Logout",
                                            style: TextStyle(
                                              color: HexColor('#BD0006'),
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                              height:
                                                  20), // Space between title and content
                                          Text(
                                            'Are you sure you want to logout from the application?',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                              height:
                                                  20), // Space between content and buttons
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              // Accept Button
                                              acceptButton,
                                              SizedBox(width: 12),
                                              // Reject Button
                                              rejectButton,
                                            ],
                                          ),
                                        ],
                                      ),
                                    );

                                    // Show the custom dialog inside a modal bottom sheet or overlay
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          backgroundColor: Colors
                                              .transparent, // Transparent background
                                          child:
                                              customDialog, // Show the custom container as the dialog
                                        );
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
                          )),
                    ),
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
                  body: FutureBuilder(
                    future: _userList.getUserList(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<BusList>> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        return Column(
                          children: [
                            Lottie.asset(
                                'assets/images/92268-blocked-account.json',
                                fit: BoxFit.cover),
                            Container(
                              padding: EdgeInsets.all(15),
                              child: Text(
                                snapshot.data![0].holdMsg,
                                style: TextStyle(
                                    color: HexColor('#BD0006'),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    fontFamily: 'Tajawal-Regular',
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
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
