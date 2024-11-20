import 'package:cicbus/Controlers/UpdateController.dart';
import 'package:cicbus/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class UpdateScreenMandatory extends StatelessWidget {
  const UpdateScreenMandatory({Key? key}) : super(key: key);
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldpop = await showWairing(context);
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
                }),
          ],
        ),
      ),
    );
  }
}
