import 'package:flutter/material.dart';
import 'package:pilsbot/components/ButtonIcon.dart';
import 'package:roslib/roslib.dart';
import 'package:pilsbot/model/globals.dart' as globals;

class ButtonRosBool extends StatefulWidget {
  final String subscriberTopic;
  final String publisherTopic;
  final IconData icon;
  final double size;
  ButtonRosBool({this.size, this.subscriberTopic, this.publisherTopic, this.icon});

  @override
  _ButtonRosBoolState createState() => _ButtonRosBoolState();
}

class _ButtonRosBoolState extends State<ButtonRosBool> {
  /// Is the switch on?
  /// 1=yes, 0=no, -1= pilsbot did not give the info
  int isOn;
  /// ROS topic to subscribe to
  Topic sub;
  Topic pub;

  @override
  void initState(){
    sub = Topic(ros: globals.com.ros, name: widget.subscriberTopic, type: 'std_msgs/Bool', reconnectOnClose: true, queueLength: 10, queueSize: 10);
    pub = Topic(ros: globals.com.ros, name: widget.publisherTopic, type: 'std_msgs/Bool', reconnectOnClose: true, queueLength: 10, queueSize: 10);
    super.initState();
    isOn = -1;
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
          Color colorFill;
          isOn = -1;
          if(snapshot.hasData){
            var value = Map<String, dynamic>.from(Map<String, dynamic>.from(snapshot.data)['msg'])['data'];
            value == true ? isOn = 1 : isOn = 0;
          }
          if(isOn==1){
            colorFill = Colors.orange;
          } else if(isOn==0){
            colorFill = Colors.blue;
          } else {
            colorFill = Colors.grey;
          }
          return ButtonIcon(
            size: widget.size,
            opacity: 1.0,
            color: colorFill,
            icon: widget.icon,
            callback: () {
              if(isOn == 1){
                pub.publish({'data': false});
              } else {
                pub.publish({'data': true});
              }
            },
          );
        }
    );
  }
}
