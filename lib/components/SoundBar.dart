import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pilsbot/components/ButtonIcon.dart';
import 'package:pilsbot/model/Communication.dart';
import 'package:roslib/roslib.dart';

class SoundBar extends StatefulWidget {
  SoundBar();

  @override
  _SoundBarState createState() => _SoundBarState();
}

class _SoundBarState extends State<SoundBar> {
  /// What is the pilsbot current sound volume
  double volume = 0;
  /// This attribute stores the old volume value when the pilsbot is muted
  /// in order to know which volume to take when un-muting
  double savedVolume = 0;
  /// Is the pilsbot sound muted?
  bool mute = false; // mute volume
  /// ROS topics to use
  Topic sub;
  Topic pub;
  /// Communication with ROS
  var com;

  @override
  void initState(){
    com = RosCom();
    sub = Topic(ros: com.ros, name: '/system/sound', type: "std_msgs/Float32", reconnectOnClose: true, queueLength: 10, queueSize: 10);
    pub = Topic(ros: com.ros, name: '/app/cmd/sound/value', type: "std_msgs/Float32", reconnectOnClose: true, queueLength: 10, queueSize: 10);
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
    IconData icon;
    Color color;
    Color colorSoundBar;
    if(volume == 0 || mute){
      icon = Icons.volume_off;
      color = Colors.grey;
      colorSoundBar = Colors.black12;
    } else {
      icon = Icons.volume_up;
      color = Colors.blue;
      colorSoundBar = Colors.black54;
    }
    return Container(
      width: 56,
      padding: EdgeInsets.all(3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 180,
            child: Bevel(
              cutLength: 10,
              child: Container(
                width: 44,
                color: color,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Slider(
                    value: volume,
                    activeColor: colorSoundBar,
                    onChanged: (v){
                      pub.publish({'data': volume});
                      setState(() { volume = v; });
                    },
                  )
                ),
              ),
            ),
          ),
          ButtonIcon(
            icon: icon,
            size: 44,
            color: color,
            opacity: 1.0,
            callback: (){
              setState(() {
                mute = !mute;
                if(!mute){
                  // Restore old volume after un-muting
                  volume = savedVolume;
                } else {
                  // Save the old volume for later and mute
                  savedVolume = volume;
                  volume = 0;
                }
                pub.publish({'data': volume});
              });
            },
          ),
        ],
      )
    );
  }
}
