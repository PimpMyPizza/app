import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pilsbot/model/globals.dart' as globals;

class TextError extends StatefulWidget {
  @override
  _TextErrorState createState() => _TextErrorState();
}

class _TextErrorState extends State<TextError> {
  double opacity = 1.0;

  @override
  void initState() {
    super.initState();
    changeOpacity();
  }

  changeOpacity() {
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        opacity = 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: Duration(seconds: 5),
      // The green box must be a child of the AnimatedOpacity widget.
      child: Container(
        child: Text(globals.errorMessage,
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      )
    );
  }
}
