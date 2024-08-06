import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PromoCodeScreen extends StatefulWidget {
  const PromoCodeScreen({Key? key}) : super(key: key);

  @override
  State<PromoCodeScreen> createState() => _PromoCodeScreenState();
}

class _PromoCodeScreenState extends State<PromoCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#BD0006'),
        title: Text("Promo Code"),
      ),
      backgroundColor: Colors.white,
      body: Text("Hello"),
    );
  }
}
