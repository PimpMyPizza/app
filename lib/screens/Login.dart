import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:pilsbot/components/ButtonConnect.dart';
import 'package:pilsbot/components/ButtonSettings.dart';
import 'package:pilsbot/components/TextError.dart';

class LoginScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonSettings(),
                SizedBox(width: 10),
                ButtonConnect(),
              ]
            ),
            SizedBox(height: 10),
            TextError(),
          ],
        ),
      )
    );
  }
}
