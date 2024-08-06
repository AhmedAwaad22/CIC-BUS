import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatefulWidget {
  final String version;
  final String description;
  final String appLink;
  final String apple;
  final bool allowDismissal;

  const UpdateDialog({Key? key,
    this.version = " ",
   required this.description,
    required this.appLink,
    required this.allowDismissal, required this.apple
  }) : super(key: key);

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  double screenHeight = 0;
  double screenWidth = 0;

  static const htmlData = r"""
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>$widget.description</title>
</head>
<body>
<p id="RipVanWinkle">
  RipVanWinkle paragraph.
</p>
</body>
</html>
  
  """;

  @override
  void dispose() {
    if(!widget.allowDismissal) {
      print("EXIT APP");
      // SystemNavigator.pop(); this will close the app
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: content(context),
      ),
    );
  }

  Widget content(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: screenHeight / 10,
          width: screenWidth / 1.5,
          decoration:  BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            color: Colors.white,
          ),
          child: Center(
            child: Image.asset(
              "assets/images/logo2.jpg",
              width: 35,
              height: 35,
            ),
          ),
        ),
        Container(
          height: screenHeight / 3,
          width: screenWidth / 1.5,
          decoration:  BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            color:  Colors.white,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Stack(
                            children: [
                               Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "ABOUT UPDATE",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: HexColor('#BD0006'),
                                      fontFamily: 'Kanit-Light'
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  widget.version,
                                  style:  TextStyle(
                                    fontWeight: FontWeight.bold,
                                      color: HexColor('#BD0006'),
                                    fontFamily: 'Kanit-Light'
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12,),
                        Expanded(
                          flex: 5,
                          child: SingleChildScrollView(
                            child: Html(
                              data: widget.description,

                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        widget.allowDismissal ? Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 30,
                              width: 120,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: HexColor('#BD0006'),
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child:  Center(
                                child: Text(
                                  "LATER",
                                  style: TextStyle(
                                    color: HexColor('#BD0006'),
                                    fontWeight: FontWeight.bold,
                                      fontFamily: 'Kanit-Light'
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ) : const SizedBox(),
                        SizedBox(width: widget.allowDismissal ? 16 : 0,),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              // await launchUrl(Uri.parse(widget.appLink));
                              if (Platform.isAndroid || Platform.isIOS) {
                                final appId = Platform.isAndroid ? 'com.zcic.cicbus' : '1640899336';
                                final url = Uri.parse(
                                  Platform.isAndroid
                                      ? "market://details?id=$appId"
                                      : "https://apps.apple.com/app/id$appId",
                                );
                               await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                            child: Container(
                              height: 30,
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white24,

                              ),
                              child:  Center(
                                child: Text(
                                  "UPDATE",
                                  style: TextStyle(
                                    color:  HexColor('#BD0006'),
                                    fontWeight: FontWeight.bold,
                                      fontFamily: 'Kanit-Light'
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}