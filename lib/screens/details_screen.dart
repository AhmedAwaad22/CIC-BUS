import 'dart:convert';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:blur/blur.dart';
import 'package:cicbus/model/BusLineAPI.dart';
import 'package:cicbus/model/busdata.dart';
import 'package:cicbus/model/trips.dart';
import 'package:cicbus/screens/NewBookScreen.dart';
import 'package:cicbus/widget/my_square.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../model/Pickpoints.dart';
import '../model/SearchModel.dart';
import '../model/booking.dart';
import 'Book_screen.dart';
import 'NoInternatePageMain.dart';
import 'bus_book.dart';
import 'bus_seats.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;

class DetailsScreen extends StatefulWidget {
  final SearchModel busList;
  final Trips bus;

  DetailsScreen({required this.busList, required this.bus});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  double blurValue = 0;
  final now = DateTime.now();
  late Future _doctorsFuture;
  bool pressed = false;

  @override
  void initState() {
    super.initState();
    secureScreen();

    _doctorsFuture = getPickup();
  }
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future<bool?> showWairing(BuildContext context) async => showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Do you want back to the home ?"),
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("No")),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Yes"))
            ],
          ));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final shouldpop = await showWairing(context);
          return shouldpop ?? false;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Provider.of<InternetConnectionStatus>(context) == InternetConnectionStatus.disconnected
                ? Expanded(
                  child: NoInternet(),
            ) :
                Expanded(
                  child: Scaffold(
                  backgroundColor: const Color(0xFFFFFFFF),
                  appBar: AppBar(
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: Text(
                      '${widget.busList.pickMsg} ${widget.busList.enName} ',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold,fontFamily: 'Cairo-VariableFont_wght',fontSize: 20),
                    ),
                    backgroundColor: HexColor('#9e1510'),
                    centerTitle: true,
                    elevation: 0,
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
                          color: Colors.white, // Sets the color of the help icon to white
                        ),                        
                      ),
                    ],
                  ),

                  body: FutureBuilder(
                    future: getPickup(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      print("hna ahm snapn shot");
                      print (snapshot.data);
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Oops! something went wrong omar',
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        if(snapshot.data[0].driverName == '')
                          {
                            return Column(
                              children: [
                                pressed
                                    ? Expanded(
                                  child:
                                  SingleChildScrollView(
                                    child: Container(
                                      decoration:
                                      BoxDecoration(
                                          color:Colors.white ),
                                      child: Column(
                                        children: [
                                          Row(children: <
                                              Widget>[
                                            Expanded(
                                              child: new Container(
                                                  margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                                                  child: Divider(
                                                    thickness:
                                                    2,
                                                    color:
                                                    HexColor('#9e1510'),
                                                    height:
                                                    25,
                                                  )),
                                            ),
                                            Text(
                                                "User Guide",
                                                style: TextStyle(
                                                    color:HexColor('#9e1510'),
                                                    fontSize: MediaQuery.of(context).size.height *
                                                        0.02,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontFamily: 'Tajawal-Regular')),
                                            Expanded(
                                              child: new Container(
                                                  margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                                                  child: Divider(
                                                    thickness:
                                                    2,
                                                    color:
                                                    HexColor('#9e1510'),
                                                    height:
                                                    25,
                                                  )),
                                            ),
                                          ]),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          // Text(
                                          //     "Choose you Bus Line.",
                                          //     style: TextStyle(
                                          //         color: HexColor(
                                          //             '#BD0006'),
                                          //         fontSize: MediaQuery.of(context).size.height *
                                          //             0.02,
                                          //         fontWeight: FontWeight
                                          //             .bold,
                                          //         fontFamily:
                                          //         'Tajawal-Regular')),
                                          Container(
                                              child: Image
                                                  .asset(
                                                "assets/images/BUS Application_Page_3.jpg",
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                    0.50,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                    : SizedBox(),
                                Row(children: <Widget>[
                                  Expanded(
                                    child: new Container(
                                        margin:
                                        const EdgeInsets
                                            .only(
                                            left: 10.0,
                                            right: 15.0),
                                        child: Divider(
                                          thickness: 2,
                                          color: HexColor('#9e1510'),
                                          height: 25,
                                        )),
                                  ),
                                  Text("Driver contact Info",
                                      style: TextStyle(
                                          color: HexColor('#9e1510'),
                                          fontSize: MediaQuery.of(
                                              context)
                                              .size
                                              .height *
                                              0.02,
                                          fontWeight:
                                          FontWeight.bold,
                                          fontFamily:
                                          'Tajawal-Regular')),
                                  Expanded(
                                    child: new Container(
                                        margin:
                                        const EdgeInsets
                                            .only(
                                            left: 15.0,
                                            right: 10.0),
                                        child: Divider(
                                          thickness: 2,
                                          color: HexColor('#9e1510'),
                                          height: 25,
                                        )),
                                  ),
                                ]),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                          elevation: 22,
                                          child: ClipPath(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 25, vertical: 25),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                    right: BorderSide(
                                                        color: HexColor('#9e1510'),
                                                        width: 12)),
                                                color: HexColor('#f2f3ef'),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceAround,
                                                    children: <Widget>[
                                                      Text(
                                                        'There is no driver name or number here',
                                                        style: TextStyle(
                                                            color: HexColor('#9e1510'),
                                                            fontSize: MediaQuery.of(context).size.height*0.02,
                                                            fontWeight: FontWeight.bold,
                                                            fontFamily: 'Tajawal-Regular'),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            clipper: ShapeBorderClipper(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(15))),
                                          ),
                                        ),
                                      ),
                                      Row(children: <Widget>[
                                        Expanded(
                                          child: new Container(
                                              margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                                              child: Divider(
                                                thickness: 2,
                                                color:HexColor('#9e1510'),
                                                height: 25,
                                              )),
                                        ),

                                        Text("Pickup points",style: TextStyle(
                                            color: HexColor('#9e1510'),
                                            fontSize: MediaQuery.of(context).size.height*0.02,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Tajawal-Regular')),

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
                                      Expanded(
                                        child: SizedBox(
                                          height: MediaQuery.of(context).size.height*0.9,
                                          child: ListView.builder(
                                              itemCount: snapshot.data[0].pickup.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => BookScreenAndPayment(
                                                          pointsId:
                                                          snapshot.data[0].pickup[index].pickId,
                                                          busId: widget.busList.busId.toString(),
                                                          name: snapshot
                                                              .data[0].pickup[index].pickNameEn
                                                              .toString(),
                                                          Image: snapshot
                                                              .data[0].pickup[index].pickImage
                                                              .toString(),
                                                          DropDown: snapshot
                                                              .data[0].pickup[index].pickMsg
                                                              .toString(),
                                                          bothStatus: snapshot
                                                              .data[0].pickup[index].bothStatus
                                                              .toString(),
                                                          dir: widget.bus.image,
                                                          time: snapshot
                                                              .data[0].pickup[index].pickTime,
                                                          Date: snapshot
                                                              .data[0].pickup[index].pickDate,
                                                        )));
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Card(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20.0),
                                                      ),
                                                      elevation: 22,
                                                      child: ClipPath(
                                                        child: Container(
                                                          padding: const EdgeInsets.symmetric(
                                                              horizontal: 25, vertical: 25),
                                                          decoration: BoxDecoration(
                                                            border: Border(
                                                                right: BorderSide(
                                                                    color: HexColor('#9e1510'),
                                                                    width: 12)),
                                                            color: HexColor('#f2f3ef'),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.spaceAround,
                                                                children: <Widget>[
                                                                  Image.asset(
                                                                    "assets/images/without_number.png",
                                                                    width: 35,
                                                                    height: 35,
                                                                  ),
                                                                  Spacer(),
                                                                  Text(
                                                                    snapshot.data[0].pickup[index]
                                                                        .pickNameEn,
                                                                    style: TextStyle(
                                                                        color: HexColor('#9e1510'),
                                                                        fontSize: 18,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontFamily: 'Tajawal-Regular'),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 30,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.spaceBetween,
                                                                children: <Widget>[
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons.today_rounded,
                                                                        color: HexColor('#9e1510'),
                                                                        size: 15,
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 6,
                                                                      ),
                                                                      Text(snapshot.data[0]
                                                                          .pickup[index].pickDate)
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons.date_range,
                                                                        color: HexColor('#9e1510'),
                                                                        size: 15,
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 6,
                                                                      ),
                                                                      Text(snapshot.data[0]
                                                                          .pickup[index].pickDay)
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .access_time_filled_rounded,
                                                                        color: HexColor('#9e1510'),
                                                                        size: 15,
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 6,
                                                                      ),
                                                                      Text(snapshot.data[0]
                                                                          .pickup[index].pickTime),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        clipper: ShapeBorderClipper(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                BorderRadius.circular(15))),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                        else
                          {
                            return Column(

                              children: [
                                pressed
                                    ? Expanded(
                                  child:
                                  SingleChildScrollView(
                                    child: Container(
                                      decoration:
                                      BoxDecoration(
                                          color:Colors.white ),
                                      child: Column(
                                        children: [
                                          Row(children: <
                                              Widget>[
                                            Expanded(
                                              child: new Container(
                                                  margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                                                  child: Divider(
                                                    thickness:
                                                    2,
                                                    color:
                                                    HexColor('#9e1510'),
                                                    height:
                                                    25,
                                                  )),
                                            ),
                                            Text(
                                                "User Guide",
                                                style: TextStyle(
                                                    color:HexColor('#9e1510'),
                                                    fontSize: MediaQuery.of(context).size.height *
                                                        0.02,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontFamily: 'Tajawal-Regular')),
                                            Expanded(
                                              child: new Container(
                                                  margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                                                  child: Divider(
                                                    thickness:
                                                    2,
                                                    color:
                                                    HexColor('#9e1510'),
                                                    height:
                                                    25,
                                                  )),
                                            ),
                                          ]),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          // Text(
                                          //     "Choose you Bus Line.",
                                          //     style: TextStyle(
                                          //         color: HexColor(
                                          //             '#BD0006'),
                                          //         fontSize: MediaQuery.of(context).size.height *
                                          //             0.02,
                                          //         fontWeight: FontWeight
                                          //             .bold,
                                          //         fontFamily:
                                          //         'Tajawal-Regular')),
                                          Container(
                                              child: Image
                                                  .asset(
                                                "assets/images/BUS Application_Page_3.jpg",
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                    0.50,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                    : SizedBox(),
                                Row(children: <Widget>[
                                  Expanded(
                                    child: new Container(
                                        margin:
                                        const EdgeInsets
                                            .only(
                                            left: 10.0,
                                            right: 15.0),
                                        child: Divider(
                                          thickness: 2,
                                          color: HexColor('#9e1510'),
                                          height: 25,
                                        )),
                                  ),
                                  Text("Driver contact Info",
                                      style: TextStyle(
                                          color: HexColor('#9e1510'),
                                          fontSize: MediaQuery.of(
                                              context)
                                              .size
                                              .height *
                                              0.02,
                                          fontWeight:
                                          FontWeight.bold,
                                          fontFamily:
                                          'Tajawal-Regular')),
                                  Expanded(
                                    child: new Container(
                                        margin:
                                        const EdgeInsets
                                            .only(
                                            left: 15.0,
                                            right: 10.0),
                                        child: Divider(
                                          thickness: 2,
                                          color: HexColor('#9e1510'),
                                          height: 25,
                                        )),
                                  ),
                                ]),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                          elevation: 22,
                                          child: ClipPath(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 25, vertical: 25),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                    right: BorderSide(
                                                        color:HexColor('#9e1510'),
                                                        width: 12)),
                                                color: HexColor('#f2f3ef'),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      Image.asset(
                                                          "assets/images/without_number.png",
                                                        width: 35,
                                                        height: 40,
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Text(
                                                        'Contact the driver',
                                                        textAlign: TextAlign.right,
                                                        style: TextStyle(
                                                            color: HexColor('#9e1510'),
                                                            fontSize: MediaQuery.of(context).size.height*0.02,
                                                            fontWeight: FontWeight.bold,
                                                            fontFamily: 'Tajawal-Regular'),
                                                      ),

                                                        ],
                                                  ),
                                                  SizedBox(height: 15,),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceAround,
                                                    children: <Widget>[

                                                      InkWell(
                                                        onTap: ()async{
                                                          await FlutterPhoneDirectCaller.callNumber(snapshot.data[0].driverNo);
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.all(5),
                                                          decoration: BoxDecoration(
                                                            color: HexColor('#9e1510'),
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(15.0) //                 <--- border radius here
                                                            ),
                                                          ),
                                                          child: Icon(
                                                            Icons.call,
                                                            color: Colors.white,
                                                            size: MediaQuery.of(context).size.width*0.04,
                                                          ),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        snapshot.data[0].driverName,
                                                        style: TextStyle(
                                                            color: HexColor('#9e1510'),
                                                            fontSize: MediaQuery.of(context).size.height*0.02,
                                                            fontWeight: FontWeight.bold,
                                                            fontFamily: 'Tajawal-Regular'),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            clipper: ShapeBorderClipper(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(15))),
                                          ),
                                        ),
                                      ),
                                      Row(children: <Widget>[
                                        Expanded(
                                          child: new Container(
                                              margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                                              child: Divider(
                                                thickness: 2,
                                                color:HexColor('#9e1510'),
                                                height: 25,
                                              )),
                                        ),

                                        Text("Pickup points",style: TextStyle(
                                            color: HexColor('#9e1510'),
                                            fontSize: MediaQuery.of(context).size.height*0.02,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Tajawal-Regular')),

                                        Expanded(
                                          child: new Container(
                                              margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                                              child: Divider(
                                                thickness: 2,
                                                color:HexColor('#9e1510'),
                                                height: 25,
                                              )),
                                        ),
                                      ]),
                                      Expanded(
                                        child: SizedBox(
                                          height: MediaQuery.of(context).size.height*0.9,
                                          child: ListView.builder(
                                              itemCount: snapshot.data[0].pickup.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => BookScreenAndPayment(
                                                          pointsId:
                                                          snapshot.data[0].pickup[index].pickId,
                                                          busId: widget.busList.busId.toString(),
                                                          name: snapshot
                                                              .data[0].pickup[index].pickNameEn
                                                              .toString(),
                                                          Image: snapshot
                                                              .data[0].pickup[index].pickImage
                                                              .toString(),
                                                          DropDown: snapshot
                                                              .data[0].pickup[index].pickMsg
                                                              .toString(),
                                                          bothStatus: snapshot
                                                              .data[0].pickup[index].bothStatus
                                                              .toString(),
                                                          dir: widget.bus.image,
                                                          time: snapshot
                                                              .data[0].pickup[index].pickTime,
                                                          Date: snapshot
                                                              .data[0].pickup[index].pickDate,
                                                        )));
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Card(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20.0),
                                                      ),
                                                      elevation: 22,
                                                      child: ClipPath(
                                                        child: Container(
                                                          padding: const EdgeInsets.symmetric(
                                                              horizontal: 25, vertical: 25),
                                                          decoration: BoxDecoration(
                                                            border: Border(
                                                                right: BorderSide(
                                                                    color: HexColor('#9e1510'),
                                                                    width: 12)),
                                                            color: HexColor('#f2f3ef'),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.spaceAround,
                                                                children: <Widget>[
                                                                  Image.asset(
                                                                    "assets/images/without_number.png",
                                                                    width: 35,
                                                                    height: 35,
                                                                  ),
                                                                  Spacer(),
                                                                  Text(
                                                                    snapshot.data[0].pickup[index]
                                                                        .pickNameEn,
                                                                    style: TextStyle(
                                                                        color: HexColor('#9e1510'),
                                                                        fontSize: MediaQuery.of(context).size.width*0.04,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontFamily: 'Tajawal-Regular'),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 30,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.spaceBetween,
                                                                children: <Widget>[
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons.today_rounded,
                                                                        color: HexColor('#9e1510'),
                                                                        size: 15,
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 6,
                                                                      ),
                                                                      Text(snapshot.data[0]
                                                                          .pickup[index].pickDate)
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons.date_range,
                                                                        color: HexColor('#9e1510'),
                                                                        size: 15,
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 6,
                                                                      ),
                                                                      Text(snapshot.data[0]
                                                                          .pickup[index].pickDay)
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .access_time_filled_rounded,
                                                                        color: HexColor('#9e1510'),
                                                                        size: 15,
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 6,
                                                                      ),
                                                                      Text(snapshot.data[0]
                                                                          .pickup[index].pickTime),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        clipper: ShapeBorderClipper(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                BorderRadius.circular(15))),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }


                      } else {
                        return SizedBox(
                            height: 500,
                            child: Center(child: CircularProgressIndicator()));
                      }
                    },
                  )),
                ),
              ],
        ));
  }

  // Widget generateBluredImage() {
  //   return Container(
  //     decoration: const BoxDecoration(
  //       image: DecorationImage(
  //         image: NetworkImage(
  //             'https://www.cic-cairo.edu.eg/wp-content/uploads/2022/04/website-09.jpg'),
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //     //I blured the parent container to blur background image, you can get rid of this part
  //     child: BackdropFilter(
  //       filter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
  //       child: Container(
  //         //you can change opacity with color here(I used black) for background.
  //         decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
  //       ),
  //     ),
  //   );
  // }

  Future<List<PickupElement>> getPickup() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? BusID = widget.busList.busId;
    final String? tripID = widget.bus.busId;
    final String? _token = prefs.getString('_token');
    final String? campus = prefs.getString('campus');
    //final String? username = prefs.getString('username');
    print("Bus IDDDDDDDDDDDDDDDDDDDDDDDD");
    print(BusID);
    print("dirrrrrrrrrrrrrrrrrrrrrr");
    print(tripID);
    print (campus);
    // print(PointID);
    // print(BusID);
    // print(username);
    // print(changeValue);

    Map data = {'bus_id': BusID, 'dir': tripID, 'campus': campus};

    _setAuthHeaders() =>
        {'Accept': 'application/json', 'Authorization': 'Bearer $_token'};

    final url = Uri.parse('http://mobile.cic-cairo.edu.eg/BUS/BusPoints');
    final response = await http.post(url, body: data);
    print(response);
    List<dynamic> data1 = json.decode(response.body);
    List<PickupElement> list = [];
    if (response.statusCode == 200) {
      list = data1.map((item) => PickupElement.fromJson(item)).toList();

      // if (response.statusCode == 200) {
      //
      // }
      // return(json.decode(response.body));
      // setState(() => isLoading = false);
    }
    return list;
  }
}
