import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cicbus/Controlers/CloseCrt.dart';
import 'package:cicbus/main.dart';
import 'package:cicbus/screens/API_SERVICES.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Close extends StatelessWidget {
  Close({Key? key}) : super(key: key);

  FetchUserList _userList = FetchUserList();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _userList.getUserList(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.white70,
            appBar: AppBar(
              backgroundColor: HexColor('#9e1510'),
              elevation: 0.0,
              titleSpacing: 0.0,
              title: GetBuilder<CloseCrt>(
                  init: CloseCrt(),
                  builder: (value) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        onTap: () async {
                          Widget AcceptButton = TextButton(
                              onPressed: () {
                                //visible = true;
                                value.Logout();
                              },
                              child: Text('Yes',
                                  style: TextStyle(
                                      color: HexColor('#9e1510'),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)));
                          Widget RejectButton = TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('No',
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
                              "Logout",
                              style: TextStyle(
                                  color: HexColor('#9e1510'),
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
                    );
                  }),
              automaticallyImplyLeading: false,
              flexibleSpace: SafeArea(
                child: Align(
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    "CIC Bus",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Cairo-VariableFont_wght'),
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
                        Text(
                          snapshot.data![0].activisionMsg,
                          style: TextStyle(
                              color: HexColor('#9e1510'),
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
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
                                      color: HexColor('#9e1510'), width: 1),
                                  borderRadius: BorderRadius.circular(25.0)),
                            ),
                            onPressed: () {
                             value.onInit();
                            },
                            child: Text("Refresh",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: HexColor('#9e1510'),
                                    fontWeight: FontWeight.bold)))
                      ],
                    ),
                  );
                }),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
