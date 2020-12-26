import 'package:flutter/material.dart';
import 'package:pilsbot/components/RosBoolButton.dart';

class ButtonHeadlight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ButtonRosBool(
      size: MediaQuery.of(context).size.width * 0.065,
      subscriberTopic: '/lighting/headlight',
      publisherTopic: '/app/cmd/lighting/headlight',
      icon: Icons.wb_sunny,
    );
  }
}
