import 'package:flutter/material.dart';
import 'package:pilsbot/components/ButtonIcon.dart';
import 'package:pilsbot/screens/Options.dart';

class ButtonSettings extends StatelessWidget {

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 1300),
      pageBuilder: (context, animation, secondaryAnimation) => OptionsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(Tween(begin: Offset(3.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.ease))),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ButtonIcon(
      size: 50,
      color: Colors.blue,
      opacity: 1.0,
      icon: Icons.settings,
      callback: (){
        Navigator.of(context).push(_createRoute());
      },
    );
  }
}
