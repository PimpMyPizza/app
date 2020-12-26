import 'package:flutter/material.dart';
import 'package:pilsbot/components/RosBoolButton.dart';

class ButtonParty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ButtonRosBool(
      size: MediaQuery.of(context).size.width * 0.065,
      subscriberTopic: '/lighting/party',
      publisherTopic: '/app/cmd/lighting/party',
      icon: Icons.mood,
    );
  }
}
