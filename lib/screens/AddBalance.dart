import 'dart:convert';

import 'package:cicbus/main.dart';
import 'package:cicbus/screens/WebView_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart'; 
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';


class AddBalance extends StatefulWidget {
  @override
  _AddBalanceState createState() => _AddBalanceState();
}

class _AddBalanceState extends State<AddBalance> {
  String? selectedCollege;
  List<String> campusZY = ['Business', 'Engineering'];
  List<String> campusNC = ['Business', 'Engineering', 'Mass Communication', 'Computer Science'];
  List<String> availableColleges = [];
  final TextEditingController priceController = TextEditingController();
  
  bool visible = false;

  @override
  void initState() {
    super.initState();
    _loadCampusAndSetColleges();
    // Initialize the WebView when the widget is initialized
    WebViewPlatform.instance;
  }

  // Load campus and set available colleges from SharedPreferences
  _loadCampusAndSetColleges() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? campusSh = prefs.getString('campus'); // Get campus from SharedPreferences

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

  // Add balance function
  void _addBalance() async {
    String price = priceController.text;
    if (price.isNotEmpty && selectedCollege != null) {
      // Get student ID (username) from SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? username = prefs.getString('username');

      if (username != null) {
        // Prepare the API request to get the JSON response
        final response = await _getPaymentDetails(username, selectedCollege!, price);
        //print('awaaaaaaaaaaaaaad the start');
        //print(username);
        //print('awaaaaaaaaaaaaaad the end');
        if (response != null && response['result']['iframeLink'] != null) {
          // If response contains iframeLink, open it in a new WebView page
          String iframeLink = response['result']['iframeLink'];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewPage(url: iframeLink), // Navigate to WebViewPage
            ),
          );

          //Show confirmation message
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Balance Added: \$' + price)),
          // );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Could not get payment details')),
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
  Future<Map<String, dynamic>?> _getPaymentDetails(String username, String selectedCollege, String price) async {
    try {
      // Construct the API URL or endpoint
      final String url = 'http://mobile.cic-cairo.edu.eg/BUS/OnLnPayment/$username/$selectedCollege/$price';
      // Send GET request
      final response = await http.get(Uri.parse(url));

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
          'Add Balance',
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
            Navigator.of(context).pop();
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
              'Add Money To Wallet:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),

            const SizedBox(height: 16),

            const Text('Add Money:'),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter Amount',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
            const SizedBox(height: 16),


            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(
                  fontSize:20,
                  color: HexColor('#9e1510'),),
                minimumSize: Size.fromHeight(40),
                primary: HexColor('#9e1510'),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius:
                        BorderRadius.circular(8),),),
                onPressed: () {
                  setState(() {visible =true;
                    _addBalance(); });
                },
              child: visible? Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [CircularProgressIndicator(
                            color: Colors.white,),
                          SizedBox(width: 25),
                          Text("Please wait...",
                          style: TextStyle(
                            color: Colors.white
                          ),
                          )
                        ],): Text('Next',
                      style: TextStyle( color: Colors.white,
                          fontFamily: 'Cairo-VariableFont_wght',
                          fontWeight: FontWeight.bold),),
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
                Text('2. Enter Required Amount.'),
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