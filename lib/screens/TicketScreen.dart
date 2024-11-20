import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cicbus/screens/API_SERVICES.dart';
import 'package:cicbus/screens/LoginScreen.dart';
import 'package:cicbus/screens/TicketUiScreen.dart';
import 'package:cicbus/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../model/BusLineAPI.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({Key? key}) : super(key: key);

  @override
  State<TicketScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<TicketScreen> {
  FetchUserList _userList = FetchUserList();
  bool pressed = false;

  bool visible = false;
  String ref_no = '';
  String name = '';
  bool isLoggedIn = false;
  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('fullname');

    if (username != null) {
      setState(() {
        isLoggedIn = true;
        name = username;
      });
      return;
    }
  }

  @override
  void initState() {
    autoLogIn();
    secureScreen();
    super.initState();
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#ffffff'),
      appBar: AppBar(
        backgroundColor:
            HexColor('#9e1510'), // Sets background color of the AppBar
        elevation: 0.0, // Removes shadow
        titleSpacing: 0.0, // Removes spacing between title and start of AppBar
        title: Align(
          alignment: Alignment.topLeft, // Aligns the title to the top left
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
              Navigator.pop(context); // Close the dialog on reject
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
                  borderRadius:
                      BorderRadius.circular(15),
                ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:CrossAxisAlignment.start,
              children: [
                Text(
                  "Logout",
                  style: TextStyle(
                    color: HexColor('#BD0006'),
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20), // Space between title and content
                Text(
                  'Are you sure you want to logout from the application?',
                  style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold,),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20), // Space between content and buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
                backgroundColor: Colors.transparent, // Transparent background
                child: customDialog, // Show the custom container as the dialog
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
            SizedBox(width: 8), // Add spacing between icon and text
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
)



                                                   
          
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
            icon: pressed ? Icon(Icons.help) : Icon(Icons.help_outline),
          ),
        ],
        automaticallyImplyLeading: false, // Prevents default back button
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
        builder: (BuildContext context, AsyncSnapshot<List<BusList>> snapshot) {
          if (snapshot.hasData) {
            ref_no = snapshot.data![0].reservation[0].ticketNo;
            if (snapshot.data![0].reservation[0].canCancel == 'Y') {
              return  Column(
                  children: [
                    Stack(children: [
                      Container(
                        height: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? MediaQuery.of(context).size.height / 5.0
                            : MediaQuery.of(context).size.height / 5.0,
                        width: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? MediaQuery.of(context).size.width / 1.0
                            : MediaQuery.of(context).size.width / 1.0,
                        decoration: BoxDecoration(
                          color: HexColor('#9e1510'),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.zero,
                            topRight: Radius.zero,
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SafeArea(
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AutoSizeText(
                                        'Hello, \n$name',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily: 'Kanit-Light',
                                            fontWeight: FontWeight.w800),
                                        maxFontSize: 20,
                                        maxLines: 2,
                                        minFontSize: 15,
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              AutoSizeText(
                                                'Balance',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontFamily: 'Kanit-Light',
                                                  fontWeight: FontWeight.w800,
                                                ),
                                                minFontSize: 15,
                                                maxLines: 1,
                                                maxFontSize: 20,
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/wallet.png',
                                                height: 20,
                                                width: 20,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              AutoSizeText(
                                                "${snapshot.data![0].currentBalance} EGP",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: 'Kanit-Light',
                                                    fontSize: 20),
                                                maxFontSize: 20,
                                                maxLines: 1,
                                                minFontSize: 15,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                    SizedBox(
                      height: 25,
                    ),
                    Expanded(child: TicketUiScreen()),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                            fontSize: 16,
                            color: HexColor('#fcb040'),
                          ),
                          minimumSize: Size.fromHeight(40),
                          primary: HexColor('#9e1510'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                        ),
                        onPressed: () {
                          setState(() {
                            Widget AcceptButton = TextButton(
                                onPressed: () {
                                  visible = true;
                                  _Cancel();
                                },
                                child: Text('Accept',
                                    style: TextStyle(
                                        color: HexColor('#9e1510'),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)));
                            Widget RejectButton = TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Reject',
                                    style: TextStyle(
                                        color: HexColor('#9e1510'),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)));

                            // set up the AlertDialog
                            AlertDialog alert = AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              contentPadding: EdgeInsets.all(30),
                              title: Text(
                                "Cancel policy",
                                style: TextStyle(
                                    color: HexColor('#9e1510'),
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                              content: Text(
                                snapshot.data![0].policy,
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
                          });
                        },
                        child: visible
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Text("Please wait...")
                                  ])
                            : Text('Cancel Reservation',
                                style: TextStyle(
                                    //color: Colors.white,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                );
            } else if (snapshot.data![0].reservation[0].canCancel == 'N') {
              return Column(
                  children: [
                    Stack(children: [
                      Container(
                        height: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? MediaQuery.of(context).size.height / 5.0
                            : MediaQuery.of(context).size.height / 5.0,
                        width: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? MediaQuery.of(context).size.width / 1.0
                            : MediaQuery.of(context).size.width / 1.0,
                        decoration: BoxDecoration(
                          color: HexColor('#9e1510'),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.zero,
                            topRight: Radius.zero,
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SafeArea(
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AutoSizeText(
                                        'Hello, \n$name',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily: 'Kanit-Light',
                                            fontWeight: FontWeight.w800),
                                        maxFontSize: 20,
                                        maxLines: 2,
                                        minFontSize: 15,
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              AutoSizeText(
                                                'Balance',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontFamily: 'Kanit-Light',
                                                  fontWeight: FontWeight.w800,
                                                ),
                                                minFontSize: 15,
                                                maxLines: 1,
                                                maxFontSize: 20,
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/wallet.png',
                                                height: 20,
                                                width: 20,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              AutoSizeText(
                                                "${snapshot.data![0].currentBalance} EGP",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: 'Kanit-Light',
                                                    fontSize: 20),
                                                maxFontSize: 20,
                                                maxLines: 1,
                                                minFontSize: 15,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                    Expanded(child: TicketUiScreen()),
                  ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          } else if (snapshot.hasError) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future refresh_busLines() async {
    setState(() {
      _userList.getUserList();
    });
  }

  _Cancel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username');
    final String? campus = prefs.getString('campus');

    setState(() {
      visible = true;
    });

    print("ref nooooooo");
    print(ref_no);

    //print(changeValue);

    Map data = {'username': username, 'refno': ref_no, 'campus': campus};

    final url = Uri.parse('http://mobile.cic-cairo.edu.eg/BUS/CancelReserve');
    final response = await http.post(url, body: data);
    print(response);
    // List<dynamic> data1 = json.decode(response.body);

    if (response.statusCode == 200) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
          (Route<dynamic> route) => false);
    }

    setState(() {
      visible = false;
    });
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
