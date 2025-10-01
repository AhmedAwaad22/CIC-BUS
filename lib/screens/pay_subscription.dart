import 'dart:convert';

import 'package:cicbus/main.dart';
import 'package:cicbus/screens/WebView_Screen.dart';
import 'package:cicbus/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class PaySubscription extends StatefulWidget {
  final subamount; // Declare a variable to receive subamount

  // Constructor to receive subamount value
  const PaySubscription({Key? key, required this.subamount}) : super(key: key);
  
  @override
  _PaySubscriptionState createState() => _PaySubscriptionState();
}

class _PaySubscriptionState extends State<PaySubscription> {
  String? selectedCollege;
  List<String> campusZY = ['Business', 'Engineering'];
  List<String> campusNC = [
    'Business',
    'Engineering',
    'Mass Communication',
    'Computer Science'
  ];
  List<String> availableColleges = [];
  final TextEditingController priceController = TextEditingController();

  bool visible = false;
  

  @override
  void initState() {
    super.initState();
    _loadCampusAndSetColleges();
    WebViewPlatform.instance;
  }

  _loadCampusAndSetColleges() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? campusSh =
        prefs.getString('campus');

    if (campusSh != null) {
      setState(() {
        if (campusSh == 'zy') {
          availableColleges = campusZY;
        } else if (campusSh == 'nc') {
          availableColleges = campusNC;
        }
      });
    }
  }

  void _paysubscription() async {
    String price = priceController.text;
    if (price.isNotEmpty && selectedCollege != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? username = prefs.getString('username');

      if (username != null) {
        final response =
            await _getPaymentDetails(username, selectedCollege!, price);

        if (response != null && response['result']['iframeLink'] != null) {
          String iframeLink = response['result']['iframeLink'];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  WebViewPage(url: iframeLink), // Navigate to WebViewPage
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Error: Could not get payment details')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student ID not found!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      setState(() {
        visible = false;
      });
    }
  }

  // Function to make the network request to get payment details
  Future<Map<String, dynamic>?> _getPaymentDetails(
      String username, String selectedCollege, String price) async {
    try {
      // Construct the API URL or endpoint
      final String url =
          'https://mobile.cic-cairo.edu.eg/BUS/OnLnPayment/$username/$selectedCollege/$price/subfees';
      // Send GET request
      final response = await http.get(Uri.parse(url));
  print(url);
  print('hamaaaaaaaaaaaaaada');
      // If the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse and return the JSON response
        return json.decode(response.body);
      } else {
        throw 'Failed to load payment details';
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pay Subscription Fees',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            fontFamily: 'Cairo-VariableFont_wght',
          ),
        ),
        backgroundColor: Color(0xFF9e1510),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, true);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            ).then((value) {
              if (value == true) {
                // Refresh logic here
                setState(() {
                  // Update your state to refresh the UI
                });
              }
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Image.asset('assets/images/logo_2.png'),
            const SizedBox(height: 16),
            const Text(
              'Pay Subscription Fees:',
            style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Dropdown to select college based on campus
            if (availableColleges.isNotEmpty)
              DropdownButton<String>(
                hint: const Text('Choose College'),
                value: selectedCollege,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCollege = newValue;
                  });
                },
                items: availableColleges.map((String college) {
                  return DropdownMenuItem<String>(
                    value: college,
                    child: Text(college),
                  );
                }).toList(),
              ),

            // Display the selected college
            if (selectedCollege != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Your College: $selectedCollege',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ),

            const SizedBox(height: 16),

            const Text(
              'Pay Fees:',
            style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
             ),
            ),
            TextField(
              controller: priceController..text = widget.subamount,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d?\d*')),
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              readOnly: true,
            ),

            const SizedBox(height: 16),
        
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(
                  fontSize: 20,
                  color: HexColor('#9e1510'),
                ),
                minimumSize: Size.fromHeight(40),
                primary: HexColor('#9e1510'),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                setState(() {
                  visible = true;
                  _paysubscription();
                });
              },
              child: visible
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.white,
                        ),
                        SizedBox(width: 25),
                        Text(
                          "Please wait...",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    )
                  : Text(
                      'Next',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo-VariableFont_wght',
                          fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  
  // Display help dialog
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('How to Pay Online'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('1. Choose Your College.'),
                Text('3. Click Next.'),
                Text('4. Proceed With Your Panment on the Payment Gateway.'),
                Text('5. After Successfully Paid Press (Go To Home).'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Got it!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
