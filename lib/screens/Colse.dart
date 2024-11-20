import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cicbus/Controlers/CloseCrt.dart';
import 'package:cicbus/main.dart';
import 'package:cicbus/screens/API_SERVICES.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Close extends StatefulWidget {
  @override
  _CloseState createState() => _CloseState();
}

class _CloseState extends State<Close> {
  late Future<dynamic> _userListFuture;

  @override
  void initState() {
    super.initState();
    _userListFuture = FetchUserList().getUserList(); // Initial future call
  }

  // Method to refresh data
  void _refreshData() {
    setState(() {
      _userListFuture = FetchUserList().getUserList(); // Re-fetch the data
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _userListFuture,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the future to resolve
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          // Show an error message if there was an error fetching the data
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          // Data is available and non-empty, proceed with rendering the UI
          return Scaffold(
            backgroundColor: Colors.white70,
            appBar: AppBar(
              backgroundColor: HexColor('#9e1510'),
              elevation: 0.0,
              titleSpacing: 0.0,
              automaticallyImplyLeading: false,
              leading: GetBuilder<CloseCrt>(
                init: CloseCrt(),
                builder: (controller) {
                  return GestureDetector(
                    onTap: () async {
                      // Create the "Accept" and "Reject" buttons for the confirmation dialog
                      Widget acceptButton = TextButton(
                        onPressed: () {
                          controller.Logout(); // Call the Logout function
                          Navigator.pop(context); // Close the dialog
                        },
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            color: HexColor('#9e1510'),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );

                      Widget rejectButton = TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: HexColor('#9e1510'),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );

                      // Set up the AlertDialog
                      AlertDialog alert = AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        contentPadding: EdgeInsets.all(30),
                        title: Text(
                          "Logout",
                          style: TextStyle(
                            color: HexColor('#9e1510'),
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
                            mainAxisAlignment: MainAxisAlignment.end,
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 30.0, // Set a fixed size for the icon
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Logout',
                              overflow: TextOverflow
                                  .ellipsis, // Handle overflow if text is too long
                              style: TextStyle(
                                fontFamily: 'Cairo-ExtraLight',
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              flexibleSpace: SafeArea(
                child: Align(
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    "CIC Bus",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Cairo-VariableFont_wght',
                    ),
                  ),
                ),
              ),
            ),
            body: GetBuilder<CloseCrt>(
              init: CloseCrt(),
              builder: (value) {
                return Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.2),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/holiday.svg',
                        height: MediaQuery.of(context).size.height * .2,
                        width: MediaQuery.of(context).size.width * .2,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      // Safe access to data from snapshot
                      Text(
                        snapshot.data[0].activisionMsg, // Now safe to access
                        style: TextStyle(
                            color: HexColor('#9e1510'),
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                          ),
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: HexColor('#9e1510'), width: 1),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        onPressed:
                            _refreshData, // Trigger refresh when button is pressed
                        child: Text(
                          "Refresh",
                          style: TextStyle(
                              fontSize: 16,
                              color: HexColor('#9e1510'),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          // Data is not available or is empty
          return Center(child: Text('No data available.'));
        }
      },
    );
  }
}
