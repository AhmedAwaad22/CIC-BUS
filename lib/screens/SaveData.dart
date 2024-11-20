import 'dart:convert';

import 'package:cicbus/model/getConfirmData.dart';
import 'package:cicbus/screens/Book_screen.dart';
import 'package:cicbus/screens/NoInternatePageMain.dart';
import 'package:cicbus/screens/home.dart';
import 'package:cicbus/screens/tripsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../model/SaveData.dart';
import '../widget/my_square.dart';
import 'package:http/http.dart' as http;

class SaveData extends StatefulWidget {
  const SaveData({
    Key? key,
    required this.busName,
    required this.pickName,
    required this.To_pickTime,
    required this.count,
    required this.toPay,
    required this.currentBalance,
    required this.balanceAfter,
    required this.pickId,
    required this.busId,
    required this.message,
    required this.BothStatus,
    required this.From_pickTime,
    required this.dir,
    required this.Date,
    required this.from_campus,
    required this.to_campus,
    required this.balanceType,
    required this.openPromo,
    required this.promo,
    required this.ToPayAfter,
  }) : super(key: key);
  final String busName;
  final String pickName;
  final String To_pickTime;
  final String From_pickTime;
  final String count;
  final String toPay;
  final String currentBalance;
  final String balanceAfter;
  final String balanceType;
  final String pickId;
  final String busId;
  final String message;
  final String BothStatus;
  final String dir;
  final String Date;
  final String from_campus;
  final String to_campus;
  final String openPromo;
  final String promo;
  final String ToPayAfter;

  @override
  State<SaveData> createState() => _SaveDataState();
}

class _SaveDataState extends State<SaveData> {
  String? sbTitle = "omar";
  String? CountryId;
  bool visible = false;

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    //_Save();
    super.initState();
    secureScreen();
  }

  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Provider.of<InternetConnectionStatus>(context) ==
                InternetConnectionStatus.disconnected
            ? Expanded(
                child: NoInternet(),
              )
            : Expanded(
                child: Scaffold(
                    appBar: AppBar(
                      title: Text(
                        "Trip details",
                        style: TextStyle(
                          fontFamily: 'Cairo-VariableFont_wght',
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: HexColor('#9e1510'),
                      iconTheme: IconThemeData(color: Colors.white),
                      actions: <Widget>[
                        IconButton(
                          onPressed: () async {
                            setState(() {
                              if (!pressed) {
                                pressed = true;
                              } else {
                                pressed = false;
                              }
                              ;
                            });
                          },
                          icon: Icon(
                            pressed ? Icons.help : Icons.help_outline,
                            color: Colors
                                .white, // Sets the color of the help icon to white
                          ),
                        ),
                      ],
                    ),
                    body: SingleChildScrollView(
                      child: SaveFunction(),
                    )),
              ),
        Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(
                  fontSize: 20,
                  color: HexColor('#9e1510'),
                ),
                minimumSize: Size.fromHeight(35),
                primary: HexColor('#9e1510'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
              onPressed: () {
                setState(() {
                  visible = true;
                  _Save();
                });
              },
              child: Provider.of<InternetConnectionStatus>(context) ==
                      InternetConnectionStatus.disconnected
                  ? Expanded(
                      child: NoInternet(),
                    )
                  : Text('Confirm Reservation',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        )
      ],
    );
  }

  _Save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? PointID = widget.pickId;
    final String? BusID = widget.busId;
    final String? _token = prefs.getString('_token');
    final String? username = prefs.getString('username');
    final String? campus = prefs.getString('campus');
    final String? full_name = prefs.getString('fullname');
    final String? studId = prefs.getString('cicid');
    final String? promo = prefs.getString('promo');
    final String? change = widget.count;

    setState(() {
      visible = true;
    });
    //change = changeValue;
    print("Save Data");
    print(PointID);
    print(BusID);
    print(username);
    print(promo);
    print(campus);
    print(full_name);
    print(studId);
    print(change);

    // print(message);
    //print(changeValue);

    Map data = {
      'pickupid': PointID,
      'busid': BusID,
      'count': change,
      'username': username,
      'date': widget.Date,
      'time': widget.From_pickTime,
      'both': widget.BothStatus,
      'dir': widget.dir,
      'campus': campus,
      'name': full_name,
      'studid': studId,
      'promo': promo,
    };

    print(widget.BothStatus);
    print(widget.dir);
    print(widget.Date);
    print(widget.From_pickTime);

    final url = Uri.parse('http://mobile.cic-cairo.edu.eg/BUS/GetSaveData');
    final response = await http.post(url, body: data);
    print("da bta3 save");
    print(response);

    List<dynamic> data1 = json.decode(response.body);
    print(data1);
    List<Sava> list = [];
    if (response.statusCode == 200) {
      list = data1.map((item) => Sava.fromJson(item)).toList();

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }

    setState(() {
      visible = false;
    });

    return list;

    // if (response.statusCode == 200) {
    //
    // }
    // return(json.decode(response.body));
    // setState(() => isLoading = false);
  }

  SaveFunction() {
    if (widget.BothStatus == 'true') {
      if (widget.promo == 'Y') {
        return Column(
          children: [
            pressed
                ? SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(color: Color(0xFFFFFDE7)),
                      child: Column(
                        children: [
                          Row(children: <Widget>[
                            Expanded(
                              child: new Container(
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 15.0),
                                  child: Divider(
                                    thickness: 2,
                                    color: HexColor('#9e1510'),
                                    height: 25,
                                  )),
                            ),
                            Text("User Guide",
                                style: TextStyle(
                                    color: HexColor('#9e1510'),
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Tajawal-Regular')),
                            Expanded(
                              child: new Container(
                                  margin: const EdgeInsets.only(
                                      left: 15.0, right: 10.0),
                                  child: Divider(
                                    thickness: 2,
                                    color: HexColor('#9e1510'),
                                    height: 25,
                                  )),
                            ),
                          ]),
                          Container(
                              child: Image.asset(
                            "assets/images/BUS Application_Page_5.jpg",
                            width: MediaQuery.of(context).size.height * 0.50,
                          )),
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
            Row(children: <Widget>[
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                    child: Divider(
                      thickness: 2,
                      color: HexColor('#9e1510'),
                      height: 25,
                    )),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text("Save trip details",
                    style: TextStyle(
                        color: HexColor('#9e1510'),
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal-Regular')),
              ),
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                    child: Divider(
                      thickness: 2,
                      color: HexColor('#9e1510'),
                      height: 25,
                    )),
              ),
            ]),
            Container(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo.jpg",
                    width: MediaQuery.of(context).size.width * .1,
                    height: MediaQuery.of(context).size.height * .1,
                  ),
                  Column(
                    children: [
                      MySquare(
                        txt1: "Bus name",
                        txt2: widget.busName,
                      ),
                      MySquare(
                        txt1: "Point name",
                        txt2: widget.pickName,
                      ),
                      MySquare(
                        txt1: "Time to pickup ${widget.to_campus}",
                        txt2: widget.To_pickTime,
                      ),
                      MySquare(
                        txt1: "Time to pickup ${widget.from_campus}",
                        txt2: widget.From_pickTime,
                      ),
                      MySquare(
                        txt1: "Date",
                        txt2: widget.Date,
                      ),
                      MySquare(
                        txt1: "The number of chairs",
                        txt2: widget.count,
                      ),
                      MySquare(
                        txt1: "Total price",
                        txt2: widget.ToPayAfter,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Padding(
                      //   padding: EdgeInsets.all(10),
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       textStyle: TextStyle(
                      //         fontSize: 20,
                      //         color: HexColor('#9e1510'),
                      //       ),
                      //       minimumSize: Size.fromHeight(35),
                      //       primary: HexColor('#9e1510'),
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(5.0)),
                      //     ),
                      //     onPressed: () {
                      //       setState(() {
                      //         visible = true;
                      //         _Save();
                      //       });
                      //     },
                      //     child: Provider.of<InternetConnectionStatus>(
                      //                 context) ==
                      //             InternetConnectionStatus.disconnected
                      //         ? Expanded(
                      //             child: NoInternet(),
                      //           )
                      //         : Text('Confirm Reservation',
                      //             style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontWeight: FontWeight.bold)),
                      //   ),
                      // )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        );
      } else if (widget.promo == 'N') {
        return Column(
          children: [
            pressed
                ? SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(color: Color(0xFFFFFDE7)),
                      child: Column(
                        children: [
                          Row(children: <Widget>[
                            Expanded(
                              child: new Container(
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 15.0),
                                  child: Divider(
                                    thickness: 2,
                                    color: HexColor('#9e1510'),
                                    height: 25,
                                  )),
                            ),
                            Text("User Guide",
                                style: TextStyle(
                                    color: HexColor('#9e1510'),
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Tajawal-Regular')),
                            Expanded(
                              child: new Container(
                                  margin: const EdgeInsets.only(
                                      left: 15.0, right: 10.0),
                                  child: Divider(
                                    thickness: 2,
                                    color: HexColor('#9e1510'),
                                    height: 25,
                                  )),
                            ),
                          ]),
                          Container(
                              child: Image.asset(
                            "assets/images/BUS Application_Page_5.jpg",
                            width: MediaQuery.of(context).size.height * 0.50,
                          )),
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
            Row(children: <Widget>[
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                    child: Divider(
                      thickness: 2,
                      color: HexColor('#9e1510'),
                      height: 25,
                    )),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text("Save trip details",
                    style: TextStyle(
                        color: HexColor('#9e1510'),
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal-Regular')),
              ),
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                    child: Divider(
                      thickness: 2,
                      color: HexColor('#9e1510'),
                      height: 25,
                    )),
              ),
            ]),
            Container(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo.jpg",
                    width: MediaQuery.of(context).size.width * .1,
                    height: MediaQuery.of(context).size.height * .1,
                  ),
                  Column(
                    children: [
                      MySquare(
                        txt1: "Bus name",
                        txt2: widget.busName,
                      ),
                      MySquare(
                        txt1: "Point name",
                        txt2: widget.pickName,
                      ),
                      MySquare(
                        txt1: "Time to pickup ${widget.to_campus}",
                        txt2: widget.To_pickTime,
                      ),
                      MySquare(
                        txt1: "Time to pickup ${widget.from_campus}",
                        txt2: widget.From_pickTime,
                      ),
                      MySquare(
                        txt1: "Date",
                        txt2: widget.Date,
                      ),
                      MySquare(
                        txt1: "The number of chairs",
                        txt2: widget.count,
                      ),
                      MySquare(
                        txt1: "Total price",
                        txt2: widget.toPay,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Padding(
                      //   padding: EdgeInsets.all(10),
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       textStyle: TextStyle(
                      //         fontSize: 20,
                      //         color: HexColor('#9e1510'),
                      //       ),
                      //       minimumSize: Size.fromHeight(35),
                      //       primary: HexColor('#9e1510'),
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(5.0)),
                      //     ),
                      //     onPressed: () {
                      //       setState(() {
                      //         visible = true;
                      //         _Save();
                      //       });
                      //     },
                      //     child: Provider.of<InternetConnectionStatus>(
                      //                 context) ==
                      //             InternetConnectionStatus.disconnected
                      //         ? Expanded(
                      //             child: NoInternet(),
                      //           )
                      //         : Text('Confirm Reservation',
                      //             style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontWeight: FontWeight.bold)),
                      //   ),
                      // )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        );
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    } else if (widget.BothStatus == 'false') {
      if (widget.promo == 'Y') {
        return Column(
          children: [
            pressed
                ? SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(color: Color(0xFFFFFDE7)),
                      child: Column(
                        children: [
                          Row(children: <Widget>[
                            Expanded(
                              child: new Container(
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 15.0),
                                  child: Divider(
                                    thickness: 2,
                                    color: HexColor('#9e1510'),
                                    height: 25,
                                  )),
                            ),
                            Text("User Guide",
                                style: TextStyle(
                                    color: HexColor('#9e1510'),
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Tajawal-Regular')),
                            Expanded(
                              child: new Container(
                                  margin: const EdgeInsets.only(
                                      left: 15.0, right: 10.0),
                                  child: Divider(
                                    thickness: 2,
                                    color: HexColor('#9e1510'),
                                    height: 25,
                                  )),
                            ),
                          ]),
                          Container(
                              child: Image.asset(
                            "assets/images/BUS Application_Page_5.jpg",
                            width: MediaQuery.of(context).size.height * 0.50,
                          )),
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
            Row(children: <Widget>[
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                    child: Divider(
                      thickness: 2,
                      color: HexColor('#9e1510'),
                      height: 25,
                    )),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text("Save trip details",
                    style: TextStyle(
                        color: HexColor('#9e1510'),
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal-Regular')),
              ),
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                    child: Divider(
                      thickness: 2,
                      color: HexColor('#9e1510'),
                      height: 25,
                    )),
              ),
            ]),
            Container(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo.jpg",
                    width: MediaQuery.of(context).size.width * .1,
                    height: MediaQuery.of(context).size.height * .1,
                  ),
                  Column(
                    children: [
                      MySquare(
                        txt1: "Bus name",
                        txt2: widget.busName,
                      ),
                      MySquare(
                        txt1: "Point name",
                        txt2: widget.pickName,
                      ),
                      MySquare(
                        txt1: "Time to pickup ${widget.to_campus}",
                        txt2: widget.To_pickTime,
                      ),
                      MySquare(
                        txt1: "Time to pickup ${widget.from_campus}",
                        txt2: widget.From_pickTime,
                      ),
                      MySquare(
                        txt1: "Date",
                        txt2: widget.Date,
                      ),
                      MySquare(
                        txt1: "The number of chairs",
                        txt2: widget.count,
                      ),
                      MySquare(
                        txt1: "Total price",
                        txt2: widget.ToPayAfter,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Padding(
                      //   padding: EdgeInsets.all(10),
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       textStyle: TextStyle(
                      //         fontSize: 20,
                      //         color: HexColor('#9e1510'),
                      //       ),
                      //       minimumSize: Size.fromHeight(35),
                      //       primary: HexColor('#9e1510'),
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(5.0)),
                      //     ),
                      //     onPressed: () {
                      //       setState(() {
                      //         visible = true;
                      //         _Save();
                      //       });
                      //     },
                      //     child: Provider.of<InternetConnectionStatus>(
                      //                 context) ==
                      //             InternetConnectionStatus.disconnected
                      //         ? Expanded(
                      //             child: NoInternet(),
                      //           )
                      //         : Text('Confirm Reservation',
                      //             style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontWeight: FontWeight.bold)),
                      //   ),
                      // )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        );
      } else if (widget.promo == 'N') {
        return Column(
          children: [
            pressed
                ? SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(color: Color(0xFFFFFDE7)),
                      child: Column(
                        children: [
                          Row(children: <Widget>[
                            Expanded(
                              child: new Container(
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 15.0),
                                  child: Divider(
                                    thickness: 2,
                                    color: HexColor('#9e1510'),
                                    height: 25,
                                  )),
                            ),
                            Text("User Guide",
                                style: TextStyle(
                                    color: HexColor('#9e1510'),
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Tajawal-Regular')),
                            Expanded(
                              child: new Container(
                                  margin: const EdgeInsets.only(
                                      left: 15.0, right: 10.0),
                                  child: Divider(
                                    thickness: 2,
                                    color: HexColor('#9e1510'),
                                    height: 25,
                                  )),
                            ),
                          ]),
                          Container(
                              child: Image.asset(
                            "assets/images/BUS Application_Page_5.jpg",
                            width: MediaQuery.of(context).size.height * 0.50,
                          )),
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
            Row(children: <Widget>[
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                    child: Divider(
                      thickness: 2,
                      color: HexColor('#9e1510'),
                      height: 25,
                    )),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text("Save trip details",
                    style: TextStyle(
                        color: HexColor('#9e1510'),
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal-Regular')),
              ),
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                    child: Divider(
                      thickness: 2,
                      color: HexColor('#9e1510'),
                      height: 25,
                    )),
              ),
            ]),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo.jpg",
                    width: MediaQuery.of(context).size.width * .1,
                    height: MediaQuery.of(context).size.height * .1,
                  ),
                  Column(
                    children: [
                      MySquare(
                        txt1: "Bus name",
                        txt2: widget.busName,
                      ),
                      MySquare(
                        txt1: "Point name",
                        txt2: widget.pickName,
                      ),
                      MySquare(
                        txt1: "Time to pickup ${widget.to_campus}",
                        txt2: widget.To_pickTime,
                      ),
                      MySquare(
                        txt1: "Time to pickup ${widget.from_campus}",
                        txt2: widget.From_pickTime,
                      ),
                      MySquare(
                        txt1: "Date",
                        txt2: widget.Date,
                      ),
                      MySquare(
                        txt1: "The number of chairs",
                        txt2: widget.count,
                      ),
                      MySquare(
                        txt1: "Total price",
                        txt2: widget.toPay,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Padding(
                      //   padding: EdgeInsets.all(10),
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       textStyle: TextStyle(
                      //         fontSize: 20,
                      //         color: HexColor('#9e1510'),
                      //       ),
                      //       minimumSize: Size.fromHeight(35),
                      //       primary: HexColor('#9e1510'),
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(5.0)),
                      //     ),
                      //     onPressed: () {
                      //       setState(() {
                      //         visible = true;
                      //         _Save();
                      //       });
                      //     },
                      //     child: Provider.of<InternetConnectionStatus>(
                      //                 context) ==
                      //             InternetConnectionStatus.disconnected
                      //         ? Expanded(
                      //             child: NoInternet(),
                      //           )
                      //         : Text('Confirm Reservation',
                      //             style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontWeight: FontWeight.bold)),
                      //   ),
                      // )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        );
      }
    }
  }
}
