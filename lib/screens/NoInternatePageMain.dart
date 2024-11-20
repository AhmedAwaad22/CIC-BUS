import 'package:cicbus/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/maintenace.svg',
              height: MediaQuery.of(context).size.height * .2,
              width: MediaQuery.of(context).size.width * .2,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 25,
            ),
            Column(
              children: [
                Text(
                  "No Internet connection",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Check your connection, then refresh the page",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                ),
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.blue, width: 1),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              onPressed: () {
                setState(() {
                  // Add any logic here to update the state or refresh data.
                  // For example, re-fetch data or reset variables.
                });
              },
              child: const Text(
                "Refresh",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
