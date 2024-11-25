import 'package:cicbus/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoServer extends StatefulWidget {
  const NoServer({Key? key}) : super(key: key);

  @override
  State<NoServer> createState() => _NoServerState();
}

class _NoServerState extends State<NoServer> {
  bool _isLoading = false;

  void _refreshPage() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate a delay for the refresh action (e.g., re-fetching data or retrying a connection)
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => HomeScreen()), // Replace MainPage with your actual main page widget
  );
  }
  @override
  Widget build(BuildContext context) {
/*     return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  "No Server connection",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "We are unable to connect to the server at the moment. Please check your internet connection and try again later.",
                  style: TextStyle(color: Colors.black, fontSize: 16, ),
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
 
 */ 
 
 return Scaffold(
  backgroundColor: Colors.white,
  body: Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/maintenace.svg',
            height: MediaQuery.of(context).size.height * 0.25,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 40),
          const Text(
            "No Connection",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "We are unable to connect to the server at the moment. Please check your internet connection and try again later.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 30),
          _isLoading
                  ? const CircularProgressIndicator():
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(
                  vertical: 14.0, horizontal: 32.0),
            ),
            onPressed: _refreshPage,
            child: const Text(
              "Try Again",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);

  }
}
