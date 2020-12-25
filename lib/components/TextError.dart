import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pilsbot/model/globals.dart' as globals;

class TextError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(globals.errorMessage,
        style: TextStyle(
          color: Colors.redAccent,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
