import 'dart:convert';

import 'package:cicbus/model/booking.dart';
import 'package:cicbus/model/getConfirmData.dart';
import 'package:cicbus/screens/NoInternatePageMain.dart';
import 'package:cicbus/screens/SaveData.dart';
import 'package:cicbus/widget/my_square.dart';
import 'package:cicbus/widget/totalPriceAfterVerified.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class BookScreenAndPayment extends StatefulWidget {
  const BookScreenAndPayment({
    Key? key,
    required this.pointsId,
    required this.busId,
    required this.name,
    required this.Image,
    required this.DropDown,
    required this.bothStatus,
    required this.Date,
    required this.time,
    required this.dir,
  }) : super(key: key);
  final String pointsId;
  final String busId;
  final String name;
  final String Image;
  final String DropDown;
  final String bothStatus;
  final String Date;
  final String time;
  final String dir;

  @override
  State<BookScreenAndPayment> createState() => _BookScreenAndPaymentState();
}


class _BookScreenAndPaymentState extends State<BookScreenAndPayment> {

  String? CountryId;
  List<BusBook> countries = [];
  List<BusBook> book = [];
  final GlobalKey<ScaffoldState> _modelScaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController? controller;

  Future? _doctorsFuture;
  late Future _omarFuture;

  Future<void> secureScreen() async {
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
  
  String last = "";
  bool chk_box = false;
  int cal = 0;
  int limit_o = -100;

  TextEditingController questionController = TextEditingController();

  late List<DropdownMenuItem<String>> _menuItems;
  late SharedPreferences prefs;
  String _value = "1";

  _read() async {
  prefs = await SharedPreferences.getInstance();
  setState(() {
    _value = prefs.getString("T") ?? "1"; // get the value
    });
  }

  String? pointsId = "33";
  String? busId = "11";
  bool visible = false;

  String BusAvaiable = '1';
  List<dynamic> states = [];
  List<dynamic> DropDown = [];
  var _isLoading = false;
  bool _isAcceptTermsAndConditions = false;

  @override
  initState() {
  super.initState();
  _doctorsFuture = _getBook();
  _read();
  secureScreen();
  }

  Future<List<BusBook>> _getBook() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? PointID = widget.pointsId;
    final String? BusID = widget.busId;
    final String? _token = prefs.getString('_token');
    final String? username = prefs.getString('username');
    final String? T = prefs.getString("T");


    Map data = {
      'BusId': BusID,
      'pickupid': PointID,
      'dir': widget.dir,
      'date': widget.Date,
    };

    print("and hna aho");
    print(_value);

    _setAuthHeaders() =>
        {'Accept': 'application/json', 'Authorization': 'Bearer $_token'};

    final url = Uri.parse('http://mobile.cic-cairo.edu.eg/BUS/GetChairs');
    final response = await http.post(url, body: data);
    print(response);
    List<dynamic> data1 = json.decode(response.body);

    setState(() {
      DropDown = data1;
    });

    List dataList = DropDown[0]["opened"];
    _menuItems = List.generate(
      dataList.length,
      (i) => DropdownMenuItem(
        value: dataList[i]["id"],
        child: Text("${dataList[i]["label"]}"),
      ),
    );

    List<BusBook> list = [];
    if (response.statusCode == 200) {
      list = data1.map((item) => BusBook.fromJson(item)).toList();

    }
    return list;
  }

  Future<List<GetConfirmData>> _GetConfirmationData_topay() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? PointID = widget.pointsId;
    final String? BusID = widget.busId;
    final String? BothStatus = chk_box.toString();
    final String? _token = prefs.getString('_token');
    final String? username = prefs.getString('username');
    final String? campus = prefs.getString('campus');
    final String? T = prefs.getString('T');
    String value = questionController.value.text;

    print(BothStatus);
    print("the_dircations_is");
    print(BothStatus);
    print(widget.dir);
    print(PointID);
    print(BusID);
    print(username);
    print(widget.Date);
    print(widget.time);
    print("the value moham gdn");
    print(value);

    Map data = {
      'pickupid': PointID,
      'busid': BusID,
      'count': _value,
      'username': username,
      'date': widget.Date,
      'time': widget.time,
      'both': BothStatus,
      'dir': widget.dir,
      'campus': campus,
      'promo': value,
      // 'promo':  questionValue,
    };

    final url = Uri.parse('http://mobile.cic-cairo.edu.eg/BUS/GetConfirmData');
    final response = await http.post(url, body: data);
    print(response);
    print("The value of check box");
    print(chk_box);
    List data1 = json.decode(response.body);
    List<GetConfirmData> list = [];
    if (response.statusCode == 200) {
      list = data1.map((item) => GetConfirmData.fromJson(item)).toList();
    }
    return list;
  }

  Future<List<GetConfirmData>> _getBal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? PointID = widget.pointsId;
    final String? BusID = widget.busId;
    final String? BothStatus = chk_box.toString();
    final String? _token = prefs.getString('_token');
    final String? username = prefs.getString('username');
    final String? campus = prefs.getString('campus');
    final String? T = prefs.getString('T');
    String value = questionController.value.text;

    prefs.setString('promo', value);

    setState(() {
      visible = true;
    });

    // print("the dircations is kol haga");
    // print(BusID);
    // print(username);
    // print(promo);

    Map data = {
      'pickupid': PointID,
      'busid': BusID,
      'count': _value,
      'username': username,
      'date': widget.Date,
      'time': widget.time,
      'both': BothStatus,
      'dir': widget.dir,
      'campus': campus,
      'promo': value,
    };

    final url = Uri.parse('http://mobile.cic-cairo.edu.eg/BUS/GetConfirmData');
    final response = await http.post(url, body: data);
    // print(response);
    // print("The value of check box");

    List<dynamic> data1 = json.decode(response.body);
    List<GetConfirmData> list = [];
    if (response.statusCode == 200) {
      list = data1.map((item) => GetConfirmData.fromJson(item)).toList();
      var current_balance = int.parse(data1[0]["current_balance"]);
      //new feature
      var limit = data1[0]["pay_status"];
      var to_pay = int.parse(data1[0]["to_pay"]);
      var value_H = int.parse(_value);

      if (value_H == 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Select numbers of seats first",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          backgroundColor: HexColor('#9e1510'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white, width: 0),
            borderRadius: BorderRadius.circular(20),
          ),
        ));
      } else if (limit == 'N') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Head to the finance department to recharge your wallet",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          backgroundColor: HexColor('#9e1510'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white, width: 0),
            borderRadius: BorderRadius.circular(20),
          ),
        ));

        //limit == 'Y' ده الكونديشن الاصل
      } else if (limit == 'Y') {
        print("hna s3r b3d promo");
        print(list[0].toPayAfter);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SaveData(
                      busName: data1[0]["bus_name"],
                      pickName: data1[0]["pick_name"],
                      To_pickTime: data1[0]["to_pick_time"],
                      count: data1[0]["count"],
                      toPay: data1[0]["to_pay"],
                      currentBalance: data1[0]["current_balance"],
                      balanceAfter: data1[0]["balance_after"],
                      pickId: PointID.toString(),
                      busId: BusID.toString(),
                      message: data1[0]["pick_msg"],
                      balanceType: data1[0]["balance_type"],
                      BothStatus: BothStatus.toString(),
                      From_pickTime: data1[0]["from_pick_time"],
                      dir: widget.dir,
                      Date: widget.Date,
                      to_campus: data1[0]["to_title"],
                      from_campus: data1[0]["from_title"],
                      openPromo: data1[0]["openPromo"],
                      promo: data1[0]["promo"],
                      ToPayAfter: list[0].toPayAfter,
                    )));
      }
    }

    setState(() {
      visible = false;
    });

    return list;

  }
  
  Future<List<GetConfirmData>> _GetConfirmationData_ConfirmPromo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? PointID = widget.pointsId;
    final String? BusID = widget.busId;
    final String? BothStatus = chk_box.toString();
    final String? _token = prefs.getString('_token');
    final String? username = prefs.getString('username');
    final String? campus = prefs.getString('campus');
    final String? promocode = prefs.getString('promocode');
    // final String ? Promo = PromoCode;

    print(BothStatus);
    print("the_dircations_is");
    //print(questionValue);
    print(BothStatus);
    print(widget.dir);
    print(PointID);
    print(BusID);
    print(_value);
    print(username);
    print(widget.Date);
    print(widget.time);

    // print(BusID);
    // print(username);
    // print(changeValue);

    Map data = {
      'pickupid': PointID,
      'busid': BusID,
      'count': _value,
      'username': username,
      'date': widget.Date,
      'time': widget.time,
      'both': BothStatus,
      'dir': widget.dir,
      'campus': campus,
    };

    _setAuthHeaders() =>
        {'Accept': 'application/json', 'Authorization': 'Bearer $_token'};

    final url = Uri.parse('http://mobile.cic-cairo.edu.eg/BUS/GetConfirmData');
    final response = await http.post(url, body: data);
    print(response);
    print("The value of check box");
    print(chk_box);
    List<dynamic> data1 = json.decode(response.body);
    List<GetConfirmData> list = [];
    if (response.statusCode == 200) {
      list = data1.map((item) => GetConfirmData.fromJson(item)).toList();
      controller = _modelScaffoldKey.currentState!.showBottomSheet(
        (context) => Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Add promo code",
                        style: TextStyle(
                            color: HexColor('#9e1510'),
                            fontSize: MediaQuery.of(context).size.width * 0.09,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Marmelad'),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10, left: 10),
                    child: TextField(
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: questionController.clear,
                            icon: Icon(Icons.clear),
                          ),
                          enabledBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(1.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(3.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          filled: true,
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Marmelad',
                          ),
                          hintText: "Enter your promo code",
                          fillColor: Colors.white),
                      controller: questionController,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 18),
                      child: Text(
                        "Enter the code in order to claim and use your promo",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal-Regular'),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: 10,
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: HexColor('#9e1510')),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel',
                                style: TextStyle(
                                    //color: Colors.white,
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Tajawal-Regular')),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: HexColor('#9e1510'),
                            ),
                            onPressed: () {
                              String value = questionController.value.text;
                              _GetConfirmationData_Promo(value);
                              Navigator.pop(context);
                            },
                            child: Text('Verify',
                                style: TextStyle(
                                    //color: Colors.white,
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Tajawal-Regular')),
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(20),
                        child: Lottie.asset(
                            'assets/images/lf30_editor_hsgynfpx.json')),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return list;
  }
  
  Future<List<GetConfirmData>> _GetConfirmationData_Promo(
      String PromoCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? PointID = widget.pointsId;
    final String? BusID = widget.busId;
    final String? BothStatus = chk_box.toString();
    final String? _token = prefs.getString('_token');
    final String? username = prefs.getString('username');
    final String? campus = prefs.getString('campus');
    final String? promocode = prefs.getString('promocode');
    // final String ? Promo = PromoCode;

    print(BothStatus);
    print("the_dircations_is");
    //print(questionValue);
    print(BothStatus);
    print(widget.dir);
    print(PointID);
    print(BusID);
    print(_value);
    print(username);
    print(widget.Date);
    print(widget.time);
    print(promocode);
    // print(username);
    // print(changeValue);

    Map data = {
      'pickupid': PointID,
      'busid': BusID,
      'count': _value,
      'username': username,
      'date': widget.Date,
      'time': widget.time,
      'both': BothStatus,
      'dir': widget.dir,
      'campus': campus,
      'promo': PromoCode,
    };

    _setAuthHeaders() =>
        {'Accept': 'application/json', 'Authorization': 'Bearer $_token'};

    final url = Uri.parse('http://mobile.cic-cairo.edu.eg/BUS/GetConfirmData');
    final response = await http.post(url, body: data);
    print('_______________________________________________________________________________');
    print(response);
    print("The value of check box");
    print(chk_box);
    List<dynamic> data1 = json.decode(response.body);
    print('HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH');
    print(data1);
    List<GetConfirmData> list = [];
    if (response.statusCode == 200) {
      list = data1.map((item) => GetConfirmData.fromJson(item)).toList();
      print("marwan");
      print(list[0].promo);

      print("questionController: ${questionController.text}");
      setState(() {
        PromoCode = questionController.text;
      });

      print("maro_remove");
      print(PromoCode);
    }

    return list;
  }
  
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
      return Column(
         mainAxisAlignment: MainAxisAlignment.start,
          children: [
          Provider.of<InternetConnectionStatus>(context) == InternetConnectionStatus.disconnected
        ? Expanded(child: NoInternet())
        : Expanded(
            child: Scaffold(
              key: _modelScaffoldKey,
              appBar: AppBar(
                title: Text(
                  widget.DropDown + ' ' + widget.name,
                  style: TextStyle(
                    fontFamily: 'Cairo-VariableFont_wght',
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: HexColor('#9e1510'),
                iconTheme: IconThemeData(color: Colors.white),
                actions: <Widget>[
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        pressed = !pressed;
                      });
                    },
                    icon: Icon(
                      pressed ? Icons.help : Icons.help_outline,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              body: Column(
                children: [
                  FutureBuilder(
                    future: _doctorsFuture,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      print('The data is omar omar $snapshot.data');
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Oops! something went wrong occurred',
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        if (widget.bothStatus == "N") {
                          return Expanded(
                            child: FutureBuilder(
                              future: _GetConfirmationData_topay(),
                              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot_oamr) {
                                print('The data is omar hakim $snapshot_oamr.data');
                                if (snapshot_oamr.connectionState == ConnectionState.done) {
                                  if (snapshot_oamr.data[0].openPromo == 'Y') {
                                    if (snapshot_oamr.data[0].promo == 'Y') {
                                      return Column(
                                        children: [
                                          if (pressed) 
                                            Expanded(
                                              child: SingleChildScrollView(
                                                child: Container(
                                                  decoration: BoxDecoration(color: Colors.white),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Container(
                                                              margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                                                              child: Divider(
                                                                thickness: 2,
                                                                color: HexColor('#9e1510'),
                                                                height: 25,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            "User Guide",
                                                            style: TextStyle(
                                                              color: HexColor('#9e1510'),
                                                              fontSize: MediaQuery.of(context).size.height * 0.02,
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: 'Tajawal-Regular',
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                                                              child: Divider(
                                                                thickness: 2,
                                                                color: HexColor('#9e1510'),
                                                                height: 25,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        child: Image.asset(
                                                          "assets/images/BUS Application_Page_4.jpg",
                                                          width: MediaQuery.of(context).size.height * 0.50,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ) 
                                          else 
                                            SizedBox(),

                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                                                  child: Divider(
                                                    thickness: 2,
                                                    color: HexColor('#9e1510'),
                                                    height: 25,
                                                  ),
                                                ),
                                              ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.8,
                                              child: Text(
                                                "Book Your Seat",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: HexColor('#9e1510'),
                                                  fontSize: MediaQuery.of(context).size.height * 0.02,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Tajawal-Regular',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                              Container(
                                                margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                                                height: 25,
                                                color: HexColor('#9e1510'),
                                              ),
                                            ],
                                          ),

                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: snapshot.data.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Padding(
                                                  padding: EdgeInsets.all(35),
                                                  child: Card(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20.0),
                                                    ),
                                                    elevation: 22,
                                                    child: ClipPath(
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                                                        decoration: BoxDecoration(
                                                          border: Border(
                                                            right: BorderSide(color: HexColor('#9e1510'), width: 12),
                                                          ),
                                                          color: HexColor('#f4f4f4'),
                                                        ),
                                                        child: Center(
                                                          child: Column(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment.center,
                                                                child: Container(
                                                                  child: Image.asset(
                                                                    "assets/images/without_number.png",
                                                                    width: 35,
                                                                    height: 35,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(height: 10),
                                                              Align(
                                                                alignment: Alignment.center,
                                                                child: Container(
                                                                  child: Text(
                                                                    widget.name,
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 18,
                                                                      fontFamily: 'Tajawal-Regular',
                                                                      color: HexColor('#BD0006'),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      clipper: ShapeBorderClipper(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          
                                          // Add the rest of your widgets below the ListView.builder if needed
                                          FutureBuilder(
                                            future: _GetConfirmationData_topay(),
                                            builder: (BuildContext context, AsyncSnapshot snapshot_toPay) {
                                              if (snapshot_toPay.hasData) {
                                                return AfterVerified(
                                                  txt1: "Total price",
                                                  txt2: snapshot_toPay.data[0].toPay,
                                                  txt3: snapshot_toPay.data[0].toPayAfter,
                                                  txt4: 'Instead of',
                                                );
                                              } else if (snapshot_toPay.hasError) {
                                                return Center(
                                                  child: Lottie.asset(
                                                    'assets/images/lf30_editor_iuu7wud2.json',
                                                    width: MediaQuery.of(context).size.width * 0.6,
                                                  ),
                                                );
                                              } else {
                                                return Center(
                                                  child: Lottie.asset(
                                                    'assets/images/lf30_editor_iuu7wud2.json',
                                                    width: MediaQuery.of(context).size.width * 0.6,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                          SizedBox(height: 20),
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Text(
                                              "No. of Seats",
                                              style: TextStyle(
                                                color: HexColor('#9e1510'),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                                            Expanded( 
                                              child: DropdownButtonFormField(
                                                value: _value,
                                                items: _menuItems,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius: const BorderRadius.all(
                                                      Radius.circular(10.0),
                                                    ),
                                                  ),
                                                  hintText: "Seats",
                                                  hintStyle: TextStyle(
                                                    color: HexColor('#9e1510'),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    _value = value as String;
                                                  });
                                                  prefs.setString("T", _value);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Row(
                                              children: [
                                                SizedBox(width: 16),
                                                Image.asset(
                                                  'assets/images/success.png',
                                                  width: MediaQuery.of(context).size.width * 0.06,
                                                ),
                                                SizedBox(width: 15),
                                                Container(
                                                  margin: EdgeInsets.only(top: 4),
                                                  child: Text(
                                                    "Verified",
                                                    style: TextStyle(
                                                      fontSize: 21,
                                                      fontFamily: 'Cairo-VariableFont_wght',
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                textStyle: TextStyle(
                                                  fontSize: 20,
                                                  color: HexColor('#9e1510'),
                                                ),
                                                minimumSize: Size.fromHeight(40),
                                                primary: HexColor('#9e1510'),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5.0),
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  visible = true;
                                                  _getBal();
                                                });
                                              },
                                              child: visible
                                                ? Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      CircularProgressIndicator(color: Colors.white),
                                                      SizedBox(width: 25),
                                                      Text("Please wait..."),
                                                    ],
                                                  )
                                                : Text(
                                                    'Next',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Cairo-VariableFont_wght',
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }else if (snapshot_oamr.data[0].promo == 'N') {
                                      return Column(
                                      children: [
                                        pressed? Expanded(
                                                child: SingleChildScrollView(
                                                  child: Container(
                                                    decoration: BoxDecoration(color: Colors.white),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Container(
                                                                margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                                                                child: Divider(
                                                                  thickness: 2,
                                                                  color: HexColor('#9e1510'),
                                                                  height: 25,
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              "User Guide",
                                                              style: TextStyle(
                                                                color: HexColor('#BD0006'),
                                                                fontSize: MediaQuery.of(context).size.height * 0.02,
                                                                fontWeight: FontWeight.bold,
                                                                fontFamily: 'Tajawal-Regular',
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                                                                child: Divider(
                                                                  thickness: 2,
                                                                  color: HexColor('#9e1510'),
                                                                  height: 25,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          child: Image.asset(
                                                            "assets/images/BUS Application_Page_4.jpg",
                                                            width: MediaQuery.of(context).size.height * 0.50,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                                                child: Divider(
                                                  thickness: 2,
                                                  color: HexColor('#9e1510'),
                                                  height: 25,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                "Book Your Seat",
                                                style: TextStyle(
                                                  color: HexColor('#9e1510'),
                                                  fontSize: MediaQuery.of(context).size.height * 0.02,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Tajawal-Regular',
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                                                child: Divider(
                                                  thickness: 2,
                                                  color: HexColor('#9e1510'),
                                                  height: 25,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.all(35),
                                                      child: Card(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(20.0),
                                                        ),
                                                        elevation: 22,
                                                        child: ClipPath(
                                                          child: Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                                                            decoration: BoxDecoration(
                                                              border: Border(
                                                                right: BorderSide(color: HexColor('#9e1510'), width: 12),
                                                              ),
                                                              color: HexColor('#f4f4f4'),
                                                            ),
                                                            child: Center(
                                                              child: Column(
                                                                children: [
                                                                  Align(
                                                                    alignment: Alignment.center,
                                                                    child: Container(
                                                                      child: Image.asset(
                                                                        "assets/images/without_number.png",
                                                                        width: 35,
                                                                        height: 35,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 10),
                                                                  Align(
                                                                    alignment: Alignment.center,
                                                                    child: Container(
                                                                      child: Text(
                                                                        widget.name,
                                                                        style: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: 18,
                                                                          fontFamily: 'Tajawal-Regular',
                                                                          color: HexColor('#BD0006'),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                                                        ),
                                                      ),
                                                    ),
                                                    MySquare(txt1: "Capacity", txt2: snapshot.data[index].busCapacity),
                                                    MySquare(txt1: "Reserve", txt2: snapshot.data[index].busReserve),
                                                    MySquare(txt1: "Available", txt2: snapshot.data[index].busAvailable),
                                                    FutureBuilder(
                                                      future: _GetConfirmationData_topay(),
                                                      builder: (BuildContext context, AsyncSnapshot snapshot_toPay) {
                                                        if (snapshot_toPay.hasData) {
                                                          return MySquare(txt1: "Total price", txt2: snapshot_toPay.data[0].toPay);
                                                        } else {
                                                          return Center(
                                                            child: Lottie.asset(
                                                              'assets/images/lf30_editor_iuu7wud2.json',
                                                              width: MediaQuery.of(context).size.width * 0.6,
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                    SizedBox(height: 20),
                                                    Padding(
                                                      padding: EdgeInsets.all(10),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "No. of Seats",
                                                            style: TextStyle(
                                                              color: HexColor('#9e1510'),
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                                                          Expanded(
                                                            child: DropdownButtonFormField(
                                                              value: _value,
                                                              items: _menuItems,
                                                              decoration: InputDecoration(
                                                                border: OutlineInputBorder(
                                                                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                                                ),
                                                                hintText: "Seats",
                                                                hintStyle: TextStyle(color: HexColor('#9e1510'), fontWeight: FontWeight.bold),
                                                              ),
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  _value = value as String;
                                                                });
                                                                prefs.setString("T", _value);
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.all(10),
                                                      child: InkWell(
                                                        onTap: () {
                                                          _GetConfirmationData_ConfirmPromo();
                                                        },
                                                        child: Row(
                                                          children: [
                                                            SizedBox(width: 16),
                                                            Image.asset(
                                                              'assets/images/plus.png',
                                                              color: Colors.black,
                                                              width: MediaQuery.of(context).size.width * 0.04,
                                                            ),
                                                            SizedBox(width: 15),
                                                            Container(
                                                              margin: EdgeInsets.only(top: 4),
                                                              child: Text(
                                                                "Add promo code",
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 18,
                                                                  fontFamily: 'Tajawal-Regular',
                                                                  color: HexColor('#9e1510'),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.all(10),
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          textStyle: TextStyle(fontSize: 20, color: HexColor('#9e1510')),
                                                          minimumSize: Size.fromHeight(40),
                                                          primary: HexColor('#9e1510'),
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            visible = true;
                                                            _getBal();
                                                          });
                                                        },
                                                        child: visible
                                                            ? Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  CircularProgressIndicator(color: Colors.white),
                                                                  SizedBox(width: 25),
                                                                  Text("Please wait...")
                                                                ],
                                                              )
                                                            : Text(
                                                                'Next',
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontFamily: 'Cairo-VariableFont_wght',
                                                                  fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                     );
                                    }
                                  }
                                }
                                return Column(); // i don't no
                              },
                            ),
                          );
                        }
                      }
//////////////////////////////////////

return Expanded(
  child: Column(
    children: [
      if (pressed)
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                          child: Divider(
                            thickness: 2,
                            color: HexColor('#9e1510'),
                            height: 25,
                          ),
                        ),
                      ),
                      Text(
                        "User Guide",
                        style: TextStyle(
                          color: HexColor('#9e1510'),
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal-Regular',
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                          child: Divider(
                            thickness: 2,
                            color: HexColor('#9e1510'),
                            height: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Image.asset(
                      "assets/images/BUS Application_Page_4.jpg",
                      width: MediaQuery.of(context).size.height * 0.50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      else
        SizedBox(),

      Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10.0, right: 15.0),
              child: Divider(
                thickness: 2,
                color: HexColor('#9e1510'),
                height: 25,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    "Book Your Seat",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: HexColor('#9e1510'),
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal-Regular',
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 15.0, right: 10.0),
            height: 25,
            color: HexColor('#9e1510'),
          ),
        ],
      ),

      // هنا نستخدم Expanded لحجز المساحة المناسبة لـ ListView
      Expanded(
        child: ListView.builder(
          itemCount: snapshot.hasData ? snapshot.data.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.all(35),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 22,
                child: ClipPath(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: HexColor('#9e1510'), width: 12),
                      ),
                      color: HexColor('#f4f4f4'),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              child: Image.asset(
                                "assets/images/without_number.png",
                                width: 35,
                                height: 35,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              child: Text(
                                widget.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  fontFamily: 'Tajawal-Regular',
                                  color: HexColor('#BD0006'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),

      FutureBuilder(
        future: _GetConfirmationData_topay(),
        builder: (BuildContext context, AsyncSnapshot snapshot_toPay) {
          if (snapshot_toPay.hasData) {
            return AfterVerified(
              txt1: "Total price",
              txt2: snapshot_toPay.data[0].toPay,
              txt3: snapshot_toPay.data[0].toPayAfter,
              txt4: 'Instead of',
            );
          } else if (snapshot_toPay.hasError) {
            return Center(
              child: Lottie.asset(
                'assets/images/lf30_editor_iuu7wud2.json',
                width: MediaQuery.of(context).size.width * 0.6,
              ),
            );
          } else {
            return Center(
              child: Lottie.asset(
                'assets/images/lf30_editor_iuu7wud2.json',
                width: MediaQuery.of(context).size.width * 0.6,
              ),
            );
          }
        },
      ),

      SizedBox(height: 20),

      Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Text(
              "No. of Seats",
              style: TextStyle(
                color: HexColor('#9e1510'),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.1),
            Expanded(
              child: DropdownButtonFormField(
                value: _value,
                items: _menuItems,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  hintText: "Seats",
                  hintStyle: TextStyle(
                    color: HexColor('#9e1510'),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _value = value as String;
                  });
                  prefs.setString("T", _value);
                },
              ),
            ),
          ],
        ),
      ),

      Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            SizedBox(width: 16),
            Image.asset(
              'assets/images/success.png',
              width: MediaQuery.of(context).size.width * 0.06,
            ),
            SizedBox(width: 15),
            Container(
              margin: EdgeInsets.only(top: 4),
              child: Text(
                "Verified",
                style: TextStyle(
                  fontSize: 21,
                  fontFamily: 'Cairo-VariableFont_wght',
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),

      Padding(
        padding: EdgeInsets.all(10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(
              fontSize: 20,
              color: HexColor('#9e1510'),
            ),
            minimumSize: Size.fromHeight(40),
            primary: HexColor('#9e1510'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          onPressed: () {
            setState(() {
              visible = true;
              _getBal();
            });
          },
          child: visible
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(width: 25),
                  Text("Please wait..."),
                ],
              )
            : Text(
                'Next',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo-VariableFont_wght',
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
    ],
  ),
);

/////////////////////////////////
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }