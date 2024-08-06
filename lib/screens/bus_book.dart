


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../model/booking.dart';
import 'package:http/http.dart' as http;

import '../widget/App_theme.dart';
import 'home.dart';

class BusBookSeat extends StatefulWidget {
  const BusBookSeat({Key? key, required this.Pointid, required this.Busid}) : super(key: key);
  final String Pointid;
  final String Busid;

  @override
  State<BusBookSeat> createState() => _BusBookSeatState();
}



class _BusBookSeatState extends State<BusBookSeat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppTheme.nearlyWhite,
        child: Scaffold(
          body: FutureBuilder(
            future:_getBook() ,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              print("omar");
              print(_getBook());
              print(snapshot.data);
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Oops! something went wrong occurred',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
              else if(snapshot.hasData){
                    final user = snapshot.data as BusBook;

                    return ListView(

                      physics: BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(top: 30),
                      children: [
                        const SizedBox(height: 24),
                        buildCicID(user),
                        const SizedBox(height: 24),
                        //NumbersWidget(),
                        // const SizedBox(height: 48),
                        // buildCicID(user),
                        // const SizedBox(height: 48),
                        // buildMajor(user),
                        // const SizedBox(height: 48),
                        // buildConcentration(user),
                        // const SizedBox(height: 48),
                        // buildCohort(user),
                        // const SizedBox(height: 48),
                        // buildNational(user),
                        // const SizedBox(height: 48),
                        // buildPhone(user),
                      ],
                    );
                  }
                 return Text("user.busCapacity");

            },

          ),
        ),
      ),
    );
  }
  Future<BusBook?> _getBook() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? PointID = widget.Pointid;
    final String? BusID = widget.Busid;
    final String? _token = prefs.getString('_token');  
    print(PointID);
    print(BusID);

    Map data = {'PointId': PointID, 'BusId': BusID};

    _setAuthHeaders() =>
        {'Accept': 'application/json', 'Authorization': 'Bearer $_token'};

    final url = Uri.parse('https://cms.cic-cairo.com/mobadmin/GetChairs');
    final response = await http.post(url, body: data);
    print(response);

    if (response.statusCode == 200) {
      final List lines = json.decode(response.body);

      // setState(() => isLoading = false);


    } else {
      throw Exception();
    }
  }

  Widget buildCicID(BusBook user) => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Student ID',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: HexColor('#D32E2F'),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.busCapacity.toString(),
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            height: 1.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
