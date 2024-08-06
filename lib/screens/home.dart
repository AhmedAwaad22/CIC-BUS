import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cicbus/screens/API_SERVICES.dart';
import 'package:cicbus/screens/Colse.dart';
import 'package:cicbus/screens/HoldScreen.dart';
import 'package:cicbus/screens/NoInternatePageMain.dart';
import 'package:cicbus/screens/SubscriptionScreen.dart';
import 'package:cicbus/screens/TicketScreen.dart';
import 'package:cicbus/screens/tripsScreen.dart';
import 'package:cicbus/widget/updatingdialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../model/BusLineAPI.dart';
import '../model/trips.dart';
import 'package:http/http.dart' as http;
import 'LoginScreen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BusList>? bus;
  String query = '';
  List<dynamic> DropDown = [];
  List<BusList> result = [];
  String tripId = '41';

  String name = '';
  bool isLoggedIn = false;
  bool isLoading = true;
  bool visible = false;

  String ref_no = '';
  String? userAgent;
  bool visible_new = false;
  bool pressed = false;
  bool pressed_pdf = false;
  bool visibilityTag = true;
  bool omar = false;
  bool visibilityObs = false;
  String Subscription = SubscriptionScreen().toString();
  String Home = HomeScreen().toString();
  FetchUserList _userList = FetchUserList();
  GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  bool name_first = false;
  late var timer;

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
    getTripList();
    secureScreen();

    final newVersion = NewVersion(
      androidId: 'com.zcic.cicbus',
      iOSId: '1640899336',
    );

    super.initState();
    if (mounted) {
      Timer(const Duration(milliseconds: 800), () {
        checkNewVersion(newVersion);
      });
      // timer = Timer.periodic(Duration(seconds: 10), (Timer t) => setState((){
      //
      // }));
    }
    _userList.getUserList();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   timer.cancel();
  // }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  void checkNewVersion(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      if (status.canUpdate) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return UpdateDialog(
              allowDismissal: true,
              description: status.releaseNotes!,
              version: status.storeVersion,
              appLink: status.appStoreLink,
              apple: status.appStoreLink,
            );
          },
        );
      }
    }
  }

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
          Provider.of<InternetConnectionStatus>(context) ==
                  InternetConnectionStatus.disconnected
              ? Expanded(
                  child: NoInternet(),
                )
              : Expanded(
                  child: Scaffold(
                      body: FutureBuilder(
                          future: _userList.getUserList(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<BusList>> snapshot) {
                            if (snapshot.hasError) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasData) {
                              ref_no =
                                  snapshot.data![0].reservation[0].ticketNo;
                              if (snapshot.data![0].activisionStatus == "Y") {
                                if (snapshot.data![0].subscription == "Y") {
                                  if (snapshot.data![0].holdStatus == 'Y') {
                                    return HoldScreen();
                                  } else if (snapshot.data![0].holdStatus ==
                                      'N') {
                                    if (snapshot.data![0].reservationStatus ==
                                        "N") {
                                      return Scaffold(
                                        appBar: AppBar(
                                          backgroundColor: HexColor('#9e1510'),
                                          elevation: 0.0,
                                          titleSpacing: 0.0,
                                          title: Align(
                                            alignment: Alignment.topLeft,
                                            child: InkWell(
                                              onTap: () async {
                                                Widget AcceptButton =
                                                    TextButton(
                                                        onPressed: () {
                                                          //visible = true;
                                                          Logout();
                                                        },
                                                        child: Text('Yes',
                                                            style: TextStyle(
                                                                color: HexColor(
                                                                    '#BD0006'),
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)));
                                                Widget RejectButton =
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('No',
                                                            style: TextStyle(
                                                                color: HexColor(
                                                                    '#BD0006'),
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)));

                                                // set up the AlertDialog
                                                AlertDialog alert = AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0)),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.all(30),
                                                  title: Text(
                                                    "Logout",
                                                    style: TextStyle(
                                                        color:
                                                            HexColor('#ffffff'),
                                                        fontSize: 19,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  content: Text(
                                                    'Are you sure to logout from application ?',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  actions: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
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
                                                  builder:
                                                      (BuildContext context) {
                                                    return alert;
                                                  },
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      child: Icon(
                                                        Icons.logout,
                                                        color: Colors.white,
                                                        size: 30.0,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Logout',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Cairo-ExtraLight',
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          actions: <Widget>[
                                            IconButton(
                                            color: Colors.white,
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
                                              icon: pressed
                                                  ? Icon(Icons.help)
                                                  : Icon(Icons.help_outline),
                                            ),
                                          ],
                                          automaticallyImplyLeading: false,
                                          flexibleSpace: SafeArea(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: AutoSizeText(
                                                "CIC Bus",
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.03,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontFamily:
                                                        'Cairo-VariableFont_wght'),
                                              ),
                                            ),
                                          ),
                                        ),
                                        body: Stack(
                                          children: <Widget>[
                                            Container(
                                              height: MediaQuery.of(context)
                                                          .orientation ==
                                                      Orientation.portrait
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      3.0
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      3.0,
                                              width: MediaQuery.of(context)
                                                          .orientation ==
                                                      Orientation.portrait
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.0
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.0,
                                              decoration: BoxDecoration(
                                                color: HexColor('#9e1510'),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.zero,
                                                  topRight: Radius.zero,
                                                  bottomLeft:
                                                      Radius.circular(25),
                                                  bottomRight:
                                                      Radius.circular(25),
                                                ),
                                              ),
                                            ),
                                            SafeArea(
                                              child: Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: AutoSizeText(
                                                            'Hello, \n$name',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    'Kanit-Light',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800),
                                                            maxFontSize: 20,
                                                            maxLines: 2,
                                                            minFontSize: 15,
                                                          ),
                                                        ),
                                                        Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                AutoSizeText(
                                                                  'Balance',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily:
                                                                        'Kanit-Light',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                  ),
                                                                  minFontSize:
                                                                      15,
                                                                  maxLines: 1,
                                                                  maxFontSize:
                                                                      20,
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
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      fontFamily:
                                                                          'Kanit-Light',
                                                                      fontSize:
                                                                          20),
                                                                  maxFontSize:
                                                                      20,
                                                                  maxLines: 1,
                                                                  minFontSize:
                                                                      15,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 25,
                                                    ),
                                                    //hna awel al work
                                                    Expanded(
                                                        child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 50),
                                                      child: RefreshIndicator(
                                                        onRefresh:
                                                            refresh_busLines,
                                                        child: FutureBuilder<
                                                                List<Trips>>(
                                                            future:
                                                                getTripList(),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (!snapshot
                                                                  .hasData) {
                                                                return Center(
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                );
                                                              }
                                                              List<Trips>?
                                                                  data =
                                                                  snapshot.data;
                                                              return Column(
                                                                children: [
                                                                  pressed
                                                                      ? Expanded(
                                                                          child:
                                                                              SingleChildScrollView(
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(color: Colors.white),
                                                                              child: Column(
                                                                                children: [
                                                                                  Row(children: <Widget>[
                                                                                    Expanded(
                                                                                      child: new Container(
                                                                                          margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                                                                                          child: Divider(
                                                                                            thickness: 2,
                                                                                            color: HexColor('#BD0006'),
                                                                                            height: 25,
                                                                                          )),
                                                                                    ),
                                                                                    Text("User Guide", style: TextStyle(color: HexColor('#BD0006'), fontSize: MediaQuery.of(context).size.height * 0.02, fontWeight: FontWeight.bold, fontFamily: 'Tajawal-Regular')),
                                                                                    Expanded(
                                                                                      child: new Container(
                                                                                          margin: const EdgeInsets.only(left: 15.0, right: 10.0),
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
                                                                                  Container(
                                                                                      child: Image.asset(
                                                                                    "assets/images/BUS Application_Page_1.jpg",
                                                                                    width: MediaQuery.of(context).size.height * 0.50,
                                                                                  )),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : SizedBox(),
                                                                  Row(children: <
                                                                      Widget>[
                                                                    // Expanded(
                                                                    //   child: new Container(
                                                                    //       margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                                                                    //       child: Divider(
                                                                    //         thickness:
                                                                    //             2,
                                                                    //         color:
                                                                    //             HexColor('#BD0006'),
                                                                    //         height:
                                                                    //             25,
                                                                    //       )),
                                                                    // ),
                                                                    // Text(
                                                                    //     "Bus Trips",
                                                                    //     style: TextStyle(
                                                                    //         color: HexColor(
                                                                    //             '#BD0006'),
                                                                    //         fontSize: MediaQuery.of(context).size.height *
                                                                    //             0.02,
                                                                    //         fontWeight:
                                                                    //             FontWeight.bold,
                                                                    //         fontFamily: 'Tajawal-Regular')),
                                                                    // Expanded(
                                                                    //   child: new Container(
                                                                    //       margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                                                                    //       child: Divider(
                                                                    //         thickness:
                                                                    //             2,
                                                                    //         color:
                                                                    //             HexColor('#BD0006'),
                                                                    //         height:
                                                                    //             25,
                                                                    //       )),
                                                                    // ),
                                                                  ]),
                                                                  Expanded(
                                                                    child: GridView
                                                                        .builder(
                                                                      itemCount: snapshot
                                                                          .data!
                                                                          .length,
                                                                      itemBuilder:
                                                                          (BuildContext context,
                                                                              int index) {
                                                                        tripId =
                                                                            data![index].busId;
                                                                        print(
                                                                            tripId);
                                                                        return ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Container(
                                                                              // padding: const EdgeInsets.all(20),
                                                                              decoration: BoxDecoration(color: HexColor('#ffc209'), borderRadius: BorderRadius.circular(15), boxShadow: const [
                                                                                BoxShadow(offset: Offset(0, 17), blurRadius: 20, spreadRadius: -100, color: Colors.blueGrey)
                                                                              ]),
                                                                              //home page
                                                                              child: Material(
                                                                                color: Colors.transparent,
                                                                                child: InkWell(
                                                                                  onTap: () {
                                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => TripsScreen(bus: data[index])));
                                                                                  },
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(10.0),
                                                                                    child: Column(
                                                                                      children: <Widget>[
                                                                                        Expanded(child: Image.asset("assets/images/home_first.png", width: MediaQuery.of(context).size.width * .5, height: MediaQuery.of(context).size.height * .5)),
                                                                                        Text(
                                                                                          data[index].enName,
                                                                                          style: TextStyle(color: HexColor('#9e1510'), fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Kanit-Light'),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                          crossAxisCount:
                                                                              2,
                                                                          crossAxisSpacing:
                                                                              15,
                                                                          mainAxisSpacing:
                                                                              15),
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            }),
                                                      ),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      //cancelation and reservation important (New)
                                      return TicketScreen();
                                    }
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                } else {
                                  return Column(children: [
                                    Expanded(child: SubscriptionScreen())
                                  ]);
                                }
                              } else if (snapshot.data![0].activisionStatus ==
                                  "N") {
                                return Close();
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          })),
                ),
        ],
      ),
    );
  }

  _Cancel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _token = prefs.getString('_token');
    final String? username = prefs.getString('username');
    final String? campus = prefs.getString('campus');

    setState(() {
      visible = true;
    });

    print("ref nooooooo");
    print(ref_no);

    //print(changeValue);

    Map data = {'username': username, 'refno': ref_no, 'campus': campus};

    _setAuthHeaders() =>
        {'Accept': 'application/json', 'Authorization': 'Bearer $_token'};

    final url = Uri.parse('http://mobile.cic-cairo.edu.eg/BUS/CancelReserve');
    final response = await http.post(url, body: data);
    print(response);
    List<dynamic> data1 = json.decode(response.body);

    if (response.statusCode == 200) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
          (Route<dynamic> route) => false);
    }

    setState(() {
      visible = false;
    });

    // if (response.statusCode == 200) {
    //
    // }
    // return(json.decode(response.body));
    // setState(() => isLoading = false);
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
      Map postdata = {'campus': campus};

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

  Future refresh() async {
    setState(() {
      // _getBusLines();
    });
  }

  Future refresh_busLines() async {
    setState(() {
      _userList.getUserList();
    });
  }

  Future<bool?> showWairing(BuildContext context) async => showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Do you want close the application ?"),
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("No")),
              ElevatedButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: const Text("Yes"))
              //SystemNavigator.pop()
            ],
          ));

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
      Get.to(() => LoginScreen());
      prefs.remove('login');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout'),
          duration: Duration(seconds: 2),
        ),
      );
      // here

      setState(() {
        visible = false;
      });
    }
  }
}

remove_seats() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.remove('T');
}

class CategoryBuses extends StatefulWidget {
  final String image;
  final String title;
  final VoidCallback press;

  CategoryBuses(
      {required this.image, required this.title, required this.press});

  @override
  State<CategoryBuses> createState() => _CategoryBusesState();
}

class _CategoryBusesState extends State<CategoryBuses> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          decoration: BoxDecoration(
              color: HexColor('#ffc209'),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    offset: Offset(0, 17),
                    blurRadius: 20,
                    spreadRadius: -100,
                    color: Colors.white)
              ]),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.press,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: <Widget>[
                        Expanded(
                            child: Image.asset(widget.image,
                                width: MediaQuery.of(context).size.width * 0.26,
                                height:
                                    MediaQuery.of(context).size.height * 0.26)),
                        Text(
                          widget.title,
                          style: TextStyle(
                              color: HexColor('#BD0006'),
                              fontFamily: 'Tajawal-Regular',
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
