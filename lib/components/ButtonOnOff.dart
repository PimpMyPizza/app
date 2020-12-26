import 'package:flutter/material.dart';
import 'package:pilsbot/components/RosBoolButton.dart';

class ButtonOnOff extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ButtonRosBool(
      size: MediaQuery.of(context).size.width * 0.065,
      subscriberTopic: '/system/on',
      publisherTopic: '/app/cmd/emergency/stop',
      icon: Icons.power_settings_new,
    );
  }
}
