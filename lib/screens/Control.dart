import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pilsbot/components/ControlModeSwitch.dart';
import 'package:pilsbot/components/ControllingUser.dart';
import 'package:pilsbot/components/EmergencySwitch.dart';
import 'package:pilsbot/components/PartyLight.dart';
import 'package:pilsbot/components/VelocityState.dart';
import 'package:pilsbot/components/Blinker.dart';
import 'package:pilsbot/components/SoundBar.dart';
import 'package:pilsbot/components/Joystick.dart';
import 'package:pilsbot/components/SettingsButton.dart';
import 'package:pilsbot/components/LightsSwitch.dart';
import 'package:pilsbot/components/BatteryState.dart';
import 'package:roslib/roslib.dart';
//import 'package:image/image.dart' as Image;

class ControlScreen extends StatefulWidget {

  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  Ros ros;
  Topic cameraStream;
  Topic joystickStream;

  @override
  void initState(){
    ros = Ros(url: 'ws://192.168.178.39:9090');
    super.initState();
  }

  void initConnection(String url) async {
    ros.url = url;
    cameraStream = Topic(ros: ros, name: '/usb_cam/image_raw', type: "sensor_msgs/Image", reconnectOnClose: true, queueLength: 200, queueSize: 200);
    joystickStream = Topic(ros: ros, name: '/app/cmd/joystick', type: "sensor_msgs/Joy", reconnectOnClose: true, queueLength: 10, queueSize: 10);
    ros.connect();
    //await cameraStream.subscribe();
    setState(() {});
  }

  void destroyConnection() async {
    await ros.close();
    //await cameraStream.unsubscribe();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    /* Fix landscape mode */
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    return Scaffold(
      body: StreamBuilder<Object>(
        stream: ros.statusStream,
        builder: (context, snapshot) {
          if (snapshot.data != Status.CONNECTED)
          {
            final myController = TextEditingController();
            myController.text = 'ws://192.168.178.39:9090';
            return Container(
              alignment: Alignment.center,
              color: Colors.black,
              padding:  EdgeInsets.fromLTRB(140, 20, 140, 0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        fillColor: Colors.blue,
                        focusColor: Colors.blue,
                        hoverColor: Colors.orange,
                      ),
                      controller: myController,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(100, 3, 100, 3),
                      child: ElevatedButton(
                        onPressed: () {
                          this.initConnection(myController.text);
                        },
                        child: Text('Submit', style:  TextStyle(fontSize: 20, color: Colors.white70)),
                      ),
                    ),
                  ],
                ),
              )
            );
          }
          return Container(
            child: Stack(
              children: <Widget>[
                StreamBuilder<Object>(
                  stream: cameraStream.subscription,
                  builder: (context, snapshot) {
                    //Image.Image cameraImage;
                    //Image.Image background;
                    if(snapshot.hasData){
                      print('has data');
                      print(snapshot.data);
                      /*var msg = Map<String, dynamic>.from(snapshot.data)['msg'];
                      var data = Map<String, dynamic>.from(msg)['data'];
                      var height = Map<String, dynamic>.from(msg)['height'];
                      var width = Map<String, dynamic>.from(msg)['width'];*/
                      //var type = Map<String, dynamic>.from(value)['format'];
                      /*print(height);
                      print(width);*/
                      return Container(color: Colors.black,
                        /*decoration: new BoxDecoration(
                          image: new DecorationImage(image: , fit: BoxFit.cover,),
                        ),*/
                      );
                    }
                    return Container(color: Colors.black);
                  }
                ),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SoundBar(ros: ros),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(height: MediaQuery.of(context).size.height*0.08),
                                VelocityState(ros: ros),
                                BatteryState(ros: ros),
                                ControllingUser(ros: ros),
                                SettingsButton(),
                              ],
                            )
                          ]
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ControlModeSwitch(ros: ros),
                                EmergencySwitch(ros: ros),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                LightsSwitch(ros: ros),
                                PartyLight(ros: ros),
                              ],
                            ),
                            Container(height: MediaQuery.of(context).size.width*0.1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Blinker(ros: ros, orientation: 'left'),
                                Blinker(ros: ros, orientation: 'right'),
                              ],
                            ),
                          ],
                        ),
                        //Container(height: MediaQuery.of(context).size.width*0.04),
                      ],
                    ),
                    Joystick(ros: ros),
                  ],
                ),
              ],
            )
          );
        }
      )
    );
  }

  @override
  void dispose() {
    /* Let all orientation mode for the other pages */
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.dispose();
  }
}
