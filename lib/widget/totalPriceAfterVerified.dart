import 'package:flutter/material.dart';

import '../main.dart';

class AfterVerified extends StatefulWidget {
  const AfterVerified({Key? key, required this.txt1, required this.txt2, required this.txt3,required this.txt4})
      : super(key: key);

  final String txt1;
  final String txt2;
  final String txt3;
  final String txt4;

  @override
  State<AfterVerified> createState() => _AfterVerifiedState();
}

class _AfterVerifiedState extends State<AfterVerified> {
  @override
  Widget build(BuildContext context) {

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
                    color: HexColor('#BD0006'),
                    width: MediaQuery.of(context).size.width * .02)),
            color: HexColor('#ffffff'),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    widget.txt1,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width*0.04,
                      fontFamily: 'Cairo-VariableFont_wght',
                      color: HexColor('#BD0006'),
                    ),
                  ),
                ),
                Row(
                  
                  children: [

                    Container(
                      child: Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Text(
                            widget.txt3,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:MediaQuery.of(context).size.width*0.05,
                              fontFamily: 'Tajawal-Regular',
                              color: HexColor('#BD0006'),
                            ),
                          ),
                        ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                    Container(
                      margin: EdgeInsets.only(top: 3),
                      child: Text(
                        widget.txt4,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width*0.04,
                          fontFamily: 'Tajawal-Regular',
                          color: HexColor('#BD0006'),
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                    CustomPaint(
                      foregroundPainter: linePainter(),
                      child: Container(
                        margin: EdgeInsets.only(top: 3),
                          child: Text(
                            widget.txt2,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:MediaQuery.of(context).size.width*0.05,
                              fontFamily: 'Tajawal-Regular',
                              color: HexColor('#BD0006'),
                            ),
                          ),
                        ),

                    ),
                  ],
                )
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

class CustomClipPath extends CustomClipper<Path> {
  var radius=20.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 100);
    path.lineTo(50,50);
    path.lineTo(100,0);
    path.lineTo(10, 0);
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class linePainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 3..color = Colors.green;
    canvas.drawLine(

      Offset(size.width*1/5,size.height*1/1),
      Offset(size.width*5/7,size.height*0),
      paint
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;

}
