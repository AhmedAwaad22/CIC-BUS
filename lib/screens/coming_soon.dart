import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ComingSoon extends StatefulWidget {
  const ComingSoon({Key? key}) : super(key: key);

  @override
  State<ComingSoon> createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          generateBluredImage(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              rectShapeContainer(),
            ],
          ),
        ],
      ),
    ));
  }

  Widget generateBluredImage() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://www.cic-cairo.edu.eg/wp-content/uploads/2022/04/website-09.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      //I blured the parent container to blur background image, you can get rid of this part
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        child: Container(
          //you can change opacity with color here(I used black) for background.
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
        ),
      ),
    );
  }

  Widget rectShapeContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        //you can get rid of below line also
        borderRadius: BorderRadius.circular(10.0),
        //below line is for rectangular shape
        shape: BoxShape.rectangle,
        //you can change opacity with color here(I used black) for rect
        color: Colors.black.withOpacity(0.5),
        //I added some shadow, but you can remove boxShadow also.
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
            offset: Offset(5.0, 5.0),
          ),
        ],
      ),
      child: Column(
        children: const <Widget>[
          Text(
            // 'There\'s only one corner of the universe you can be certain of improving and that\'s your own self.',,
            'This application will be available by the coming semester (FALL 2022)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }
}
