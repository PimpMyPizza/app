import 'package:flutter/material.dart';
import 'package:pilsbot/components/ButtonText.dart';
import 'package:roslib/roslib.dart';
import 'package:pilsbot/model/globals.dart' as globals;

class ButtonControlMode extends StatefulWidget {
  ButtonControlMode();

  @override
  _ButtonControlModeState createState() => _ButtonControlModeState();
}

class _ButtonControlModeState extends State<ButtonControlMode> {
  /// Steering modus:
  /// modus == {unknown, automatic, one_joystick, two_joysticks}
  String modus='unknown';
  /// ROS topics
  Topic sub;
  Topic pub;

  @override
  void initState(){
    sub = Topic(ros: globals.com.ros, name: '/control/mode', type: "std_msgs/String", reconnectOnClose: true, queueLength: 10, queueSize: 10);
    pub = Topic(ros: globals.com.ros, name: '/app/cmd/control/mode', type: "std_msgs/String", reconnectOnClose: true, queueLength: 10, queueSize: 10);
    super.initState();
    initConnection();
  }

  void initConnection() async {
    await sub.subscribe();
    setState(() {});
  }

  void destroyConnection() async {
    await sub.unsubscribe();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: sub.subscription,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          modus = Map<String, dynamic>.from(Map<String, dynamic>.from(snapshot.data)['msg'])['data'];
        }
        String text;
        Color colorFill = Colors.blue;
        if(modus == 'one_joystick'){
          text = 'M1';
        } else if (modus == 'two_joysticks'){
          text = 'M2';
        } else if (modus == 'automatic'){
          text = 'MA';
        } else {
          colorFill = Colors.grey;
          text = 'M?';
        }
        double size = MediaQuery.of(context).size.width*0.065;
        return ButtonText(
          width: size,
          height: size,
          opacity: 1.0,
          color: colorFill,
          text: text,
          fontWeight: FontWeight.bold,
          callback: () {
            setState(() {
              if(modus=='one_joystick'){
                pub.publish({'data': 'two_joysticks'});
              } else if(modus=='two_joysticks') {
                pub.publish({'data': 'automatic'});
              } else if(modus=='automatic'){
                pub.publish({'data': 'one_joystick'});
              } else { // unknown
                pub.publish({'data': 'automatic'});
              }
            });
          },
        );
      }
    );
  }
}
