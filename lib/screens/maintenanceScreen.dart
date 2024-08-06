
  import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../main.dart';

class Maintenance extends StatefulWidget {
  const Maintenance({Key? key}) : super(key: key);

  @override
  State<Maintenance> createState() => _MaintananceState();
}

class _MaintananceState extends State<Maintenance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Center(
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/images/maintenace.svg',
                height: MediaQuery.of(context).size.height*.2,
                width: MediaQuery.of(context).size.width*.2,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                color: HexColor('#BD0006'),
                child: Column(
                  children: [
                    Text(
                      "No Internet connection",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                    SizedBox(height:10 ,),
                    Text(
                      "Check your connection, then refresh the page",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                    ElevatedButton(onPressed: (){
                      
                    }, child: Text("Refresh"))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
