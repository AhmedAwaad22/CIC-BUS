import 'dart:convert';

import 'package:cicbus/model/BusLineAPI.dart';
import 'package:cicbus/model/busdata.dart';
import 'package:cicbus/model/trips.dart';
import 'package:cicbus/screens/API_SERVICES.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../model/SearchModel.dart';
import 'FetchBusDataList_SecondPage.dart';
import 'details_screen.dart';
import 'home.dart';
import 'package:http/http.dart' as http;

class SearchUser extends SearchDelegate {
  final Trips trip;
  SearchUser(this.trip);
  @override
  List<Widget> buildActions(BuildContext context) {
    var data = [];
    List<SearchModel> results = [];

    return [
      IconButton(

        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.close),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }



  @override
  Widget buildResults(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white60,
      body:FutureBuilder<List<SearchModel>>(
        future: getBusDataListSearch(query: query),
        builder: (context,snapshot){
          if(snapshot.hasError)
            {
               return Center(child:Text("no data found"),);
            }
          else if(snapshot.hasData)
            {

              return ListView.builder(
                  itemCount:snapshot.data!.length,
                  itemBuilder: (context,index)
                  {
                    return ListTile(title: Text(snapshot.data![index].enName,style: TextStyle(color: HexColor('#BD0006'),fontFamily: 'Tajawal-Regular',fontSize: 15,fontWeight: FontWeight.bold),),onTap:() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                busList:snapshot.data![index],
                                bus: trip,
                              )));
                    },);
                  }

              );
            }
          else
            {
              return Center(child: CircularProgressIndicator(),);
            }

        },

      ),
    );


  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/images/Searchimg.svg',
                height: MediaQuery.of(context).size.height * .3,
                width: MediaQuery.of(context).size.width * .3,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "Search in bus lines",
                style:
                TextStyle(color: Colors.black, fontSize: 17),
              ),
            ],
          ),
        ),
      ),
    );
  }

  var data = [];
  List<SearchModel> results = [];
  String urlList = 'http://cms.cic-cairo.com/mobadmin/SearchLines';

  Future <List<SearchModel>> getBusDataListSearch({String? query}) async {
    var url = Uri.parse(urlList);

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? campus = prefs.getString('campus');
      //final String? _token = prefs.getString('_token');
      final String? username = prefs.getString('username');
      // print(trip[0].busId);
      //print(screen.busId.toString());
      // print(trip[0].busId.toString()??"");
      // print(getTheTripId.res.toults[0].busId);
      //print(res[0].busId);

      Map postdata = {'campus': campus};

      var response = await http.post(url, body: postdata);
      if (response.statusCode == 200) {
        data = json.decode(response.body);
        results = data.map((e) => SearchModel.fromJson(e)).toList();
        print("The name of bus lines");
        // res = data.map((e) => Busdatum.fromJson(e)).toList();



            if(query != null)
              {
                results = results
                    .where((element) => element.enName.toLowerCase().contains((query.toLowerCase())))
                    .toList();
              }





      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return results;
  }
}
