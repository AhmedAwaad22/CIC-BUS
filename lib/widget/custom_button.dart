import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomButtons extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const CustomButtons({Key? key, this.text = "", this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
                primary: Colors.green,
                backgroundColor: Color(0xFFD41E00),
                padding: const EdgeInsets.all(11)),
            child: CustomText(
              alignment: Alignment.center,
              text: text,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
