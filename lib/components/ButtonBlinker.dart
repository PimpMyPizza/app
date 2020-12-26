import 'package:flutter/material.dart';
import 'package:pilsbot/components/RosBoolButton.dart';

class ButtonBlinker extends StatelessWidget {
  final String orientation;
  ButtonBlinker({this.orientation});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    if(this.orientation == 'right'){
      icon = Icons.arrow_right;
    } else {
      icon = Icons.arrow_left;
    }
    return ButtonRosBool(
      size: MediaQuery.of(context).size.width * 0.065,
      subscriberTopic: '/lighting/indicator/'+this.orientation,
      publisherTopic: '/app/cmd/lighting/indicator/'+this.orientation,
      icon: icon,
    );
  }
}
