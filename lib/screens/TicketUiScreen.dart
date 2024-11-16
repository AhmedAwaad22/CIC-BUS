import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cicbus/main.dart';
import 'package:cicbus/screens/API_SERVICES.dart';
import 'package:cicbus/screens/LoginScreen.dart';
import 'package:cicbus/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/BusLineAPI.dart';
import 'dart:convert';

class TicketUiScreen extends StatefulWidget {
  TicketUiScreen({Key? key}) : super(key: key);

  @override
  State<TicketUiScreen> createState() => _TicketUiScreenState();
}

class _TicketUiScreenState extends State<TicketUiScreen> {
  FetchUserList _userList = FetchUserList();
  String ref_no = '';
  bool visible = false;

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

    //print(changeValue);

    Map data = {'username': username, 'refno': ref_no, 'campus': campus};

    final url = Uri.parse('https://cms.cic-cairo.com/mobadmin/CancelReserve');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#ffffff'),
      body: FutureBuilder(
        future: _userList.getUserList(),
        builder: (BuildContext context, AsyncSnapshot<List<BusList>> snapshot) {
          if (snapshot.hasData) {
            ref_no = snapshot.data![0].reservation[0].ticketNo;
            if (snapshot.data![0].cancelStatus == "Y") {
              if (snapshot.data![0].reservation[0].driverName == '') {
                return RefreshIndicator(
                  onRefresh: refresh_busLines,
                  child: Container(
                    margin:
                    EdgeInsets.only(top: 5,right: 15, left: 15),
                    child: SafeArea(
                      child: ListView.builder(
                        itemBuilder: (_, __) {
                          return Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))),
                                child: Column(
                                  children: <Widget>[
                                    // Text(
                                    //   "  ${snapshot.data![0].reservation[0].ticketNo}",
                                    //   style: TextStyle(
                                    //       fontSize: 18,
                                    //       fontWeight: FontWeight.bold,
                                    //       color: HexColor('#BD0006')),
                                    // ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "CIC",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color:HexColor('#9e1510')),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(20)),
                                          child: SizedBox(
                                            height: 8,
                                            width: 8,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                  color: HexColor('#9e1510'),
                                                  borderRadius:
                                                  BorderRadius.circular(5)),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Stack(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 24,
                                                  child: LayoutBuilder(
                                                    builder:
                                                        (context, constraints) {
                                                      return Flex(
                                                        children: List.generate(
                                                            (constraints.constrainWidth() /
                                                                6)
                                                                .floor(),
                                                                (index) => SizedBox(
                                                              height: 1,
                                                              width: 3,
                                                              child:
                                                              DecoratedBox(
                                                                decoration:
                                                                BoxDecoration(
                                                                    color:
                                                                    HexColor('#9e1510')),
                                                              ),
                                                            )),
                                                        direction:
                                                        Axis.horizontal,
                                                        mainAxisSize:
                                                        MainAxisSize.max,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Center(
                                                    child: Transform.rotate(
                                                        angle: 0,
                                                        child: Image.asset(
                                                          'assets/images/bus (1).png',
                                                          width: 24,
                                                        )))
                                                // Icon(Icons.local_airport,color: Colors.indigo.shade300,size: 24,)
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(20)),
                                          child: SizedBox(
                                            height: 8,
                                            width: 8,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                  color: HexColor('#9e1510'),
                                                  borderRadius:
                                                  BorderRadius.circular(5)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          snapshot
                                              .data![0].reservation[0].pickName,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor('#9e1510')),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        SizedBox(width:100,child: Text("Reserve No.${snapshot.data![0].reservation[0].ticketNo}",style: TextStyle(fontSize: 12,color: HexColor('#9e1510'),fontWeight: FontWeight.bold),)),

                                        SizedBox(width:100,child: Text("${snapshot.data![0].reservation[0].busName}",textAlign: TextAlign.end,style: TextStyle(fontSize: 12,color: HexColor('#9e1510'),fontWeight: FontWeight.bold),)),                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          snapshot
                                              .data![0].reservation[0].pickTime,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: HexColor('#9e1510'),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "No driver name",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: HexColor('#9e1510'),
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data![0].reservation[0]
                                              .reserveDate,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor('#9e1510')),
                                        ),
                                        Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "${snapshot.data![0].reservation[0].reserveSeat} ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: HexColor('#9e1510')),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                Icons.event_seat,
                                                color: Colors.black,
                                                size: 30.0,
                                              ),
                                            ]),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.amber,
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 20,
                                      width: 15,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                bottomRight:
                                                Radius.circular(10)),
                                            color: Colors.white),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Flex(
                                              children: List.generate(
                                                  (constraints.constrainWidth() /
                                                      10)
                                                      .floor(),
                                                      (index) => SizedBox(
                                                    height: 1,
                                                    width: 6,
                                                    child: DecoratedBox(
                                                      decoration: BoxDecoration(
                                                          color: HexColor('#9e1510')),
                                                    ),
                                                  )),
                                              direction: Axis.horizontal,
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:20,
                                      width: 15,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft:
                                                Radius.circular(10)),
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height:
                                MediaQuery.of(context).size.height * 0.07,
                                padding: EdgeInsets.only(
                                    left: 20, right: 20),
                                decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15))),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.circular(20)),
                                            child: Image.asset(
                                              "assets/images/logo6.gif",
                                              width: 22,
                                            )),
                                        SizedBox(width: 10,),
                                        Text(
                                            "MAKE IT HAPPEN",
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                HexColor('#9e1510'))),
                                        Expanded(
                                            child: Text(
                                                "\EGP ${snapshot.data![0].reservation[0].reserveAmount}",
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                    HexColor('#9e1510')))),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        itemCount: 1,
                      ),
                    ),
                  ),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: refresh_busLines,
                  child: Container(
                    margin:
                        EdgeInsets.only(top: 5,right: 15, left: 15),
                    child: SafeArea(
                      child: ListView.builder(
                        itemBuilder: (_, __) {
                          return Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))),
                                child: Column(
                                  children: <Widget>[
                                    // Text(
                                    //   "  ${snapshot.data![0].reservation[0].ticketNo}",
                                    //   style: TextStyle(
                                    //       fontSize: 18,
                                    //       fontWeight: FontWeight.bold,
                                    //       color: HexColor('#BD0006')),
                                    // ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "CIC",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor('#9e1510')),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: SizedBox(
                                            height: 8,
                                            width: 8,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                  color: HexColor('#9e1510'),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Stack(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 24,
                                                  child: LayoutBuilder(
                                                    builder:
                                                        (context, constraints) {
                                                      return Flex(
                                                        children: List.generate(
                                                            (constraints.constrainWidth() /
                                                                    6)
                                                                .floor(),
                                                            (index) => SizedBox(
                                                                  height: 1,
                                                                  width: 3,
                                                                  child:
                                                                      DecoratedBox(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            color:
                                                                            HexColor('#9e1510')),
                                                                  ),
                                                                )),
                                                        direction:
                                                            Axis.horizontal,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Center(
                                                    child: Transform.rotate(
                                                        angle: 0,
                                                        child: Image.asset(
                                                          'assets/images/bus (1).png',
                                                          width: 24,
                                                        )))
                                                // Icon(Icons.local_airport,color: Colors.indigo.shade300,size: 24,)
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: SizedBox(
                                            height: 8,
                                            width: 8,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                  color: HexColor('#9e1510'),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          snapshot
                                              .data![0].reservation[0].pickName,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor('#9e1510')),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        SizedBox(width:100,child: Text("Reserve No.${snapshot.data![0].reservation[0].ticketNo}",style: TextStyle(fontSize: 12,color: HexColor('#9e1510'),fontWeight: FontWeight.bold),)),

                                        SizedBox(width:100,child: Text("${snapshot.data![0].reservation[0].busName}",textAlign: TextAlign.end,style: TextStyle(fontSize: 12,color: HexColor('#9e1510'),fontWeight: FontWeight.bold),)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          snapshot
                                              .data![0].reservation[0].pickTime,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: HexColor('#9e1510'),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [

                                          InkWell(
                                              onTap: () async {
                                                await FlutterPhoneDirectCaller
                                                    .callNumber(snapshot
                                                        .data![0]
                                                        .reservation[0]
                                                        .driverNo);
                                              },
                                              child: Text(
                                                snapshot.data![0].reservation[0]
                                                    .driverName,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: HexColor('#9e1510'),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(bottom: 2),
                                            child: InkWell(
                                                onTap: () async {
                                                  await FlutterPhoneDirectCaller
                                                      .callNumber(snapshot
                                                          .data![0]
                                                          .reservation[0]
                                                          .driverNo);
                                                },
                                                child: Icon(
                                                  Icons.call,
                                                  size: 15,
                                                )),
                                          ),
                                        ]),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data![0].reservation[0]
                                              .reserveDate,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor('#9e1510')),
                                        ),
                                        Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "${snapshot.data![0].reservation[0].reserveSeat} ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: HexColor('#9e1510')),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                Icons.event_seat,
                                                color: Colors.black,
                                                size: 30.0,
                                              ),
                                            ]),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.amber,
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 20,
                                      width: 15,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)),
                                            color: Colors.white),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Flex(
                                              children: List.generate(
                                                  (constraints.constrainWidth() /
                                                          10)
                                                      .floor(),
                                                  (index) => SizedBox(
                                                        height: 1,
                                                        width: 7,
                                                        child: DecoratedBox(
                                                          decoration: BoxDecoration(
                                                              color:HexColor('#9e1510')),
                                                        ),
                                                      )),
                                              direction: Axis.horizontal,
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:20,
                                      width: 15,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft:
                                                    Radius.circular(10)),
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height:50,
                                padding: EdgeInsets.only(
                                    left: 20, right: 20),
                                decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15))),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Image.asset(
                                              "assets/images/logo6.gif",
                                              width: 22,
                                            )),
                                        SizedBox(width: 10,),
                                        Text(
                                            "MAKE IT HAPPEN",
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                HexColor('#9e1510'))),
                                        Expanded(
                                            child: Text(
                                                "\EGP ${snapshot.data![0].reservation[0].reserveAmount}",
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        HexColor('#9e1510')))),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        itemCount: 1,
                      ),
                    ),
                  ),
                );
              }
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


}

