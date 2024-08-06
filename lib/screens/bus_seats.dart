// import 'package:audioplayers/audioplayers.dart';
// import 'package:cicbus/screens/coming_soon.dart';
// import 'package:flutter/material.dart';
//
// import '../widget/custom_button.dart';
// import '../widget/custom_text.dart';
//
// class BusSeats extends StatefulWidget {
//   final String title;
//   final String id;
//
//
//   const BusSeats({Key? key, required this.title, required this.id}) : super(key: key);
//
//   @override
//   _BusSeatsState createState() => _BusSeatsState();
// }
//
// class _BusSeatsState extends State<BusSeats> {
//   final player = AudioPlayer();
//
//   var _chairStatus = [
//     [1, 1, 1, 1, 1],
//     [1, 1, 1, 1, 1],
//     [1, 1, 1, 1, 1],
//     [1, 1, 1, 1, 1],
//     [1, 1, 1, 1, 1],
//     [1, 1, 1, 1, 1],
//     [1, 1, 1, 1, 1],
//     [1, 1, 1, 1, 1],
//     [1, 1, 1, 1, 1],
//     [1, 1, 1, 1, 1],
//   ];
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios,
//             color: Colors.black,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Pickup Point: ' + widget.title+ widget.id,
//     style: const TextStyle(color: Color(0xFFD41E00)),
//         ),
//
//         backgroundColor: Color(0xFFFFFFFF),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: Material(
//         child: Column(
//           children: [
//             Padding(padding: EdgeInsets.all(10)),
//             Row(
//               children: const [
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Icon(
//                   Icons.event_seat,
//                   color: Colors.grey,
//                   size: 35.0,
//                 ),
//                 Text('Available',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey,
//                     )),
//                 SizedBox(
//                   width: 15,
//                 ),
//                 Icon(
//                   Icons.event_seat,
//                   color: Color(0xFFD41E00),
//                   size: 35.0,
//                 ),
//                 Text('Your Choice',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFFD41E00),
//                     )),
//                 SizedBox(
//                   width: 15,
//                 ),
//                 Icon(
//                   Icons.person,
//                   color: Colors.grey,
//                   size: 35.0,
//                 ),
//                 Text('Reserved',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey,
//                     )),
//               ],
//             ),
//             Divider(
//               color: Colors.grey,
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: <Widget>[
//                     Container(
//                       margin: EdgeInsets.only(top: 15),
//                       child: Row(
//                         children: [
//                           Expanded(
//                               child: Container(
//                                   // height: 60,
//                                   //margin: const EdgeInsets.all(5),
//                                   child: Column(
//                             children: [
//                               InkWell(
//                                 onTap: () async {
//                                   await player
//                                       .play(AssetSource('audio/carhorn.mp3'));
//                                 }, // Image tapped
//                                 splashColor:
//                                     Colors.black12, // Splash color over image
//                                 child: Icon(
//                                   Icons.person,
//                                   color: Color(0xFFD41E00),
//                                   size: 40.0,
//                                 ),
//                               ),
//                               Text(
//                                 'Driver',
//                                 style: TextStyle(
//                                     color: Color(0xFFD41E00),
//                                     fontWeight: FontWeight.bold),
//                               )
//                             ],
//                           ))),
//
//                           //Padding(padding: EdgeInsets.only(top: 100)),
//
//                           Spacer(),
//                           Expanded(
//                               child: Container(
//                                   // height: 60,
//                                   margin: const EdgeInsets.all(5),
//                                   child: Column(
//                                     children: [
//                                       Icon(
//                                         Icons.exit_to_app_sharp,
//                                         color: Color(0xFFD41E00),
//                                         size: 40.0,
//                                       ),
//                                       Text(
//                                         'Entrance',
//                                         style: TextStyle(
//                                             color: Color(0xFFD41E00),
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ))),
//                         ],
//                       ),
//                     ),
//                     for (int i = 0; i < 10; i++)
//                       Container(
//                         margin: EdgeInsets.only(top: i == 0 ? 15 : 0),
//                         child: Row(
//                           children: <Widget>[
//                             for (int x = 1; x < 6; x++)
//                               Expanded(
//                                 child: (x == 0) || (x == 3)
//                                     ? Container()
//                                     : Container(
//                                         height: 60,
//                                         margin: const EdgeInsets.all(5),
//                                         child: _chairStatus[i][x - 1] == 1
//                                             ? availableChair(i, x - 1)
//                                             : _chairStatus[i][x - 1] == 2
//                                                 ? selectedChair(i, x - 1)
//                                                 : reservedChair(),
//                                       ),
//                               ),
//                           ],
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//             Divider(
//               color: Colors.grey,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Column(
//                     children: const [
//                       Text(
//                         '50 EGP',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                             color: Color(0xFFD41E00)),
//                       ),
//                       CustomText(
//                         text: "/Ticket",
//                         color: Color(0xFFD41E00),
//                         fontSize: 15,
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     width: 15,
//                   ),
//                   Column(
//                     children: const [
//                       Text(
//                         '0',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                             color: Color(0xFFD41E00)),
//                       ),
//                       CustomText(
//                         text: "Seats",
//                         color: Color(0xFFD41E00),
//                         fontSize: 15,
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     width: 15,
//                   ),
//                   Column(
//                     children: const [
//                       Text(
//                         '200 EGP',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                             color: Color(0xFFD41E00)),
//                       ),
//                       CustomText(
//                         text: "Total",
//                         color: Color(0xFFD41E00),
//                         fontSize: 15,
//                       )
//                     ],
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(20),
//                     width: 150,
//                     height: 100,
//                     child:  CustomButtons(
//                       text: 'Book',
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) =>  ComingSoon()),
//                           );
//                         }
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget selectedChair(int a, int b) {
//     return InkWell(
//       onTap: () {
//         _chairStatus[a][b] = 1;
//         setState(() {});
//       },
//       child: Container(
//         child: Center(
//             child: Icon(
//           Icons.event_seat,
//           color: Color(0xFFD41E00),
//           size: 50.0,
//         )),
//       ),
//     );
//   }
//
//   Widget availableChair(int a, int b) {
//     return InkWell(
//       onTap: () {
//         _chairStatus[a][b] = 2;
//         setState(() {});
//       },
//       child: Container(
//         child: Center(
//             child: Icon(
//           Icons.event_seat,
//           color: Colors.grey,
//           size: 50.0,
//         )),
//       ),
//     );
//   }
//
//   Widget reservedChair() {
//     return InkWell(
//       onTap: () {
//         final snackBar = SnackBar(
//           content: const Text(
//             'This seat is already reserved!',
//             style: TextStyle(color: Color(0xFFD41E00)),
//           ),
//           backgroundColor: Colors.white,
//           action: SnackBarAction(
//             label: 'Ok',
//             onPressed: () {},
//           ),
//         );
//         ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       },
//       child: Container(
//         child: Center(
//             child: Icon(
//           Icons.person,
//           color: Colors.white,
//           size: 50.0,
//         )),
//         decoration: BoxDecoration(
//           color: Colors.grey,
//           borderRadius: BorderRadius.circular(3.0),
//         ),
//       ),
//     );
//   }
// }
