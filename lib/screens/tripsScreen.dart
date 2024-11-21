import 'dart:convert';

import 'package:cicbus/model/trips.dart';
import 'package:cicbus/screens/NoInternatePageMain.dart';
import 'package:cicbus/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../model/SearchModel.dart';
import 'LoginScreen.dart';
import 'details_screen.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({Key? key, required this.bus}) : super(key: key);
  final Trips bus;

  @override
  State<TripsScreen> createState() => _TripsState();
}

class _TripsState extends State<TripsScreen> {
  String tripId = '41';

  @override
  void initState() {
    super.initState();

    // getTripList();
    getStatusToHoliday();
    secureScreen();
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future refresh() async {
    setState(() {
      getStatusToHoliday();
    });
  }

  bool pressed = false;
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
                    backgroundColor: HexColor('#9e1510'),
                    elevation: 0.0,
                    titleSpacing: 0.0,
                    iconTheme: IconThemeData(
                        color: Colors
                            .white), // Sets the color of the back button to white
                    actions: <Widget>[
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            pressed = !pressed; // Toggle pressed state
                          });
                        },
                        icon: Icon(
                          pressed ? Icons.help : Icons.help_outline,
                          color: Colors
                              .white, // Sets the color of the help icon to white
                        ),
                      ),
                    ],
                    flexibleSpace: SafeArea(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${widget.bus.enName}",
                          style: TextStyle(
                            fontFamily: 'Cairo-VariableFont_wght',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  body: Align(
                    alignment: Alignment.center,
                    child: RefreshIndicator(
                      onRefresh: refresh,
                      child: FutureBuilder<List<SearchModel>>(
                          future: getStatusToHoliday(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasData) {
                              if (snapshot.data![0].activeStatus == 'N') {
                                return Scaffold(
                                  backgroundColor: Colors.white70,
                                  body: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                        SvgPicture.asset(
                                          'assets/images/holiday.svg',
                                          height: MediaQuery.of(context).size.height * 0.2,
                                          width: MediaQuery.of(context).size.width * 0.2,
                                          fit: BoxFit.cover,
                                        ),
                                    SizedBox(height: 30),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                        horizontal: MediaQuery.of(context).size.width * 0.050,
                                        ),
                                    child: Container(
                                    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.040),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.red, Colors.white],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          offset: Offset(0, 4),
                                          blurRadius: 6,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                      child: Column(
                                      children: [
                                        Text(
                                          snapshot.data![0].activeMsg,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18, // Increased font size for better visibility
                                            fontWeight: FontWeight.w600, // Make the text bolder
                                          ),
                                          textAlign: TextAlign.center, // Ensure the text is centered
                                        ),
                                       ],
                                      ),
                                    ),
                                   ),
                                    SizedBox(height: 25),
                                       ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            textStyle: TextStyle(fontSize: 18, color: Colors.white),
                                            primary: HexColor('#BD0006'),
                                            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: HexColor('#BD0006'),
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.circular(30.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              refresh();
                                            });
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
                                     );
                              } else if (snapshot.data![0].activeStatus ==
                                  'Y') {
                                List<SearchModel>? data1 = snapshot.data;
                                return Column(
                                  children: [
                                    pressed
                                        ? Expanded(
                                            child: SingleChildScrollView(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white),
                                                child: Column(
                                                  children: [
                                                    Row(children: <Widget>[
                                                      Expanded(
                                                        child: new Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        15.0),
                                                            child: Divider(
                                                              thickness: 2,
                                                              color: HexColor(
                                                                  '#9e1510'),
                                                              height: 25,
                                                            )),
                                                      ),
                                                      Text("User Guide",
                                                          style: TextStyle(
                                                              color: HexColor(
                                                                  '#9e1510'),
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.02,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Tajawal-Regular')),
                                                      Expanded(
                                                        child: new Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 15.0,
                                                                    right:
                                                                        10.0),
                                                            child: Divider(
                                                              thickness: 2,
                                                              color: HexColor(
                                                                  '#9e1510'),
                                                              height: 25,
                                                            )),
                                                      ),
                                                    ]),
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
                                                        child: Image.asset(
                                                      "assets/images/BUS Application_Page_2.jpg",
                                                      width:
                                                          MediaQuery.of(context)
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
                                            margin: const EdgeInsets.only(
                                                left: 10.0, right: 15.0),
                                            child: Divider(
                                              thickness: 2,
                                              color: HexColor('#9e1510'),
                                              height: 25,
                                            )),
                                      ),
                                      Text("Bus Lines",
                                          style: TextStyle(
                                              color: HexColor('#9e1510'),
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
                                              color: HexColor('#9e1510'),
                                              height: 25,
                                            )),
                                      ),
                                    ]),
                                    Expanded(
                                      child: GridView.builder(
                                        itemCount: snapshot.data!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return CategoryBuses(
                                            title: data1![index].enName,
                                            image:
                                                "assets/images/omar_stop.png",
                                            press: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailsScreen(
                                                            busList:
                                                                data1[index],
                                                            bus: widget.bus,
                                                          )));
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             TripsScreen(busList:data[index])));
                                            },
                                          );
                                        },
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 5,
                                                mainAxisSpacing: 5),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            } else {
                              return CircularProgressIndicator();
                            }
                            return CircularProgressIndicator();
                          }),
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  var data = [];
  List<Trips> results = [];
  String urlList = 'http://mobile.cic-cairo.edu.eg/BUS/SearchDirection';

  Future<List<Trips>> getTripList() async {
    var url = Uri.parse(urlList);
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? campus = prefs.getString('campus');
      //final String? _token = prefs.getString('_token');
      final String? username = prefs.getString('username');
      print(campus);
      print(username);
      print(tripId);
      Map postdata = {'campus': campus, 'dir': tripId};

      var response = await http.post(url, body: postdata);

      if (response.statusCode == 200) {
        data = json.decode(response.body);
        results = data.map((e) => Trips.fromJson(e)).toList();
        print("this the resultssssssssssssssssssssssssssss");

        // res = data.map((e) => Busdatum.fromJson(e)).toList();
      } else {
        print("fetch error");
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return results;
  }

  var data2 = [];
  var data3 = [];
  List<SearchModel> results3 = [];
  List<Trips> trip = [];

  //The bus name lines
  String urlList2 = 'http://mobile.cic-cairo.edu.eg/BUS/SearchLines';
  Future<List<SearchModel>> getStatusToHoliday() async {
    var url = Uri.parse(urlList2);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? campus = prefs.getString('campus');
    //final String? _token = prefs.getString('_token');
    final String? username = prefs.getString('username');
    print(campus);
    print(username);
    print("The dir is ");
    print(widget.bus.image);
    //print(screen.busId.toString());
    // print(trip[0].busId.toString()??"");
    // print(getTheTripId.res.toults[0].busId);
    //print(res[0].busId);

    Map postdata = {'campus': campus, 'dir': widget.bus.image};

    var response = await http.post(url, body: postdata);

    if (response.statusCode == 200) {
      data3 = json.decode(response.body);
      results3 = data3.map((e) => SearchModel.fromJson(e)).toList();
    } else {
      print("Error to fetch data");
    }

    return results3;
  }
}
