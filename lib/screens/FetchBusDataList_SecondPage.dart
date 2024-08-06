// import 'dart:convert';
//
// import 'package:cicbus/model/BusLineAPI.dart';
// import 'package:cicbus/model/busdata.dart';
// import 'package:cicbus/model/trips.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../main.dart';
//
//
// class FetchBusDataList {
//   var data = [];
//
//   List<Buss> results = [];
//   List<Trips> trip = [];
//
//
//
//
//
//   String urlList = 'https://cms.cic-cairo.com/mobadmin/SearchBusLines';
//
//   Future<List<Buss>> getBusDataListSearch({String? query}) async {
//
//
//     var url = Uri.parse(urlList);
//
//
//     try {
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       final String? campus = prefs.getString('campus');
//       //final String? _token = prefs.getString('_token');
//       final String? username = prefs.getString('username');
//
//
//       print(campus);
//       print(username);
//       print("The dir is ");
//      // print(trip[0].busId);
//       //print(screen.busId.toString());
//      // print(trip[0].busId.toString()??"");
//      // print(getTheTripId.res.toults[0].busId);
//       //print(res[0].busId);
//
//
//       Map postdata = {'campus': campus };
//
//       var response = await http.post(url,body: postdata);
//
//       if (response.statusCode == 200) {
//
//         data = json.decode(response.body);
//         results = data.map((e) => Buss.fromJson(e)).toList();
//         print("The name of bus lines");
//         print(results[0].enName);
//         // res = data.map((e) => Busdatum.fromJson(e)).toList();
//         if (query!= null){
//           results = results.where((element) => element.enName.contains((query.toLowerCase()))).toList();
//
//           // res = res.where((element) => element.enName.contains((query.toLowerCase()))).toList();
//
//           /// Find a person in the list using loop
//         }
//       } else {
//           print("Error to fetch data");
//       }
//     } on Exception catch (e) {
//       print('error: $e');
//     }
//     return results;
//   }
//
//
//
//   }
