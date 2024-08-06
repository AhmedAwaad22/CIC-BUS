import 'package:flutter/material.dart';

import '../main.dart';

class MySquare extends StatelessWidget {
  const MySquare({Key? key, required this.txt1, required this.txt2})
      : super(key: key);

  final String txt1;
  final String txt2;

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).orientation
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 22,
      child: ClipPath(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          decoration: BoxDecoration(
            border: Border(
                right: BorderSide(
                    color: HexColor('#9e1510'),
                    width: MediaQuery.of(context).size.width * .02)),
            color: HexColor('#ffffff'),
          ),
          child: Center(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      txt1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: 'Cairo-VariableFont_wght',
                        color: HexColor('#9e1510'),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    child: Text(
                      txt2,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: 'Tajawal-Regular',
                        color: HexColor('#9e1510'),
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
                borderRadius: BorderRadius.circular(15))),
      ),
    );
  }
}
