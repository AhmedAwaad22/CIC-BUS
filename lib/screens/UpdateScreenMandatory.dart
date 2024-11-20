import 'package:cicbus/Controlers/UpdateController.dart';
import 'package:cicbus/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class UpdateScreenMandatory extends StatelessWidget {
  const UpdateScreenMandatory({Key? key}) : super(key: key);

    Future<bool?> showWaiting(BuildContext context) async => showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Do you want to exit the application?",
                  style: TextStyle(
                    color: HexColor('#BD0006'),
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: Text("Yes",
                    style: TextStyle(
                    color: HexColor('#BD0006'),
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                     ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("No",
                    style: TextStyle(
                    color: HexColor('#BD0006'),
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                     ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldpop = await showWaiting(context);
        return shouldpop ?? false;
      },
      child: Scaffold(
        backgroundColor: HexColor('#eeeeee'),
        body: Column(
          children: [
            GetBuilder<UpdateScreenCrt>(
                init: UpdateScreenCrt(),
                builder: (value) {
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Lottie.asset('assets/images/${value.imgName}'));
                }),
            GetBuilder<UpdateScreenCrt>(
                init: UpdateScreenCrt(),
                builder: (value) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: HexColor('#BD0006'),
                      padding: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                          side:
                              BorderSide(color: HexColor('#BD0006'), width: 1),
                          borderRadius: BorderRadius.circular(25.0)),
                    ),
                    onPressed: () {
                      // set up the buttons
                      value.ButtonToMakeUpdate();
                    },
                    child: Text(
                      "Update now",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Kanit-Light'),
                   ),
                 );
              },
            ),
          ],
        ),
      ),
    );
  }
}
