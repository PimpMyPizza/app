import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pilsbot/components/ButtonText.dart';
import 'package:pilsbot/screens/Connecting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ButtonConnect extends StatelessWidget {

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 1300),
      pageBuilder: (context, animation, secondaryAnimation) => ConnectingScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var offsetAnimation = animation.drive(Tween(begin: Offset(3.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.ease)));
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ButtonText(
      width: MediaQuery.of(context).size.width*0.4,
      height: 50,
      color: Colors.blue,
      opacity: 1.0,
      text: AppLocalizations.of(context).login,
      fontWeight: FontWeight.bold,
      callback: (){
        Navigator.of(context).push(_createRoute());
      },
    );
  }
}