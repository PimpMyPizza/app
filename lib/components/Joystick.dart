import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:control_pad/views/joystick_view.dart';
import 'package:pilsbot/model/Communication.dart';
import 'package:roslib/roslib.dart';
import 'package:global_configuration/global_configuration.dart';

class Joystick extends StatefulWidget {
  Joystick();

  @override
  _JoystickState createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  /// x value of the left joystick
  double xl=0;
  /// y value of the left joystick
  double yl=0;
  /// x value of the right joystick
  double xr=0;
  /// y value of the right joystick
  double yr=0;
  /// The joystick refresh minimum period in milliseconds
  int period = 200;
  /// Timer that sends out joystick values every period of time
  Timer timer;
  /// ROS topics to use
  Topic pub;
  Topic sub;
  /// Communication with ROS
  var com;
  /// Steering mode:
  /// mode == {unknown, automatic, one_joystick, two_joysticks}
  String mode='two_joysticks';
  /// Sensitivity of the joystick. Can be changed in the OptionScreen
  double sensitivity;

  @override
  void initState(){
    com = RosCom();
    pub = Topic(ros: com.ros, name: '/app/cmd/joystick', type: "sensors_msgs/Joy", reconnectOnClose: true, queueLength: 10, queueSize: 10);
    sub = Topic(ros: com.ros, name: '/control/mode', type: "std_msgs/String", reconnectOnClose: true, queueLength: 10, queueSize: 10);
    super.initState();
    sensitivity = double.parse(GlobalConfiguration().getValue('joystick_sensitivity'));
    initConnection();
    timer = Timer.periodic(Duration(milliseconds: period), (tim) async{
      if(com.ros.status != Status.CONNECTED) {
        timer.cancel();
      }
      var msg = {'header': {'frame_id': 'app_joystick'}, 'axes': [xl, yl, xr, yr, 0, 0], 'buttons': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]};
      pub.publish(msg);
    });
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
  void dispose(){
    timer.cancel();
    destroyConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: sub.subscription,
      builder: (context, snapshot)
      {
        if(snapshot.hasData){
          mode = Map<String, dynamic>.from(Map<String, dynamic>.from(snapshot.data)['msg'])['data'];
        }
        List<Widget> widgets = List<Widget>();
        if(mode == 'one_joystick' || mode == 'two_joysticks'){
          widgets.add(
            JoystickView(size: MediaQuery.of(context).size.height * 0.3,
              backgroundColor: Colors.blue,
              innerCircleColor: Colors.black54.withOpacity(0.8),
              iconsColor: Colors.orange,
              interval: Duration(milliseconds: 100),
              showArrows: true,
              onDirectionChanged: (degree, distance) {
                double v = degree * 0.01745329252; // ( * pi / 180 )
                xl = distance * sin(v) * sensitivity;
                yl = distance * cos(v) * sensitivity;
              },
            )
          );
        }
        if (mode == 'two_joysticks'){
          widgets.add(
              JoystickView(size: MediaQuery.of(context).size.height * 0.3,
                backgroundColor: Colors.blue,
                innerCircleColor: Colors.black54.withOpacity(0.8),
                iconsColor: Colors.orange,
                interval: Duration(milliseconds: 100),
                showArrows: true,
                onDirectionChanged: (degree, distance) {
                  double v = degree * 0.01745329252; // ( * pi / 180 )
                  xr = distance * sin(v) * sensitivity;
                  yr = distance * cos(v) * sensitivity;
                },
              )
          );
        } else {
          widgets.add(Container());
        }
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widgets
          )
        );
      }
    );
  }
}
