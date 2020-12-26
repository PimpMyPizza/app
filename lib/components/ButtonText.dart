import 'package:flutter/material.dart';
import 'package:pilsbot/components/Button.dart';

class ButtonText extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback callback;
  final Color color;
  final double opacity;
  final String text;
  final FontWeight fontWeight;

  ButtonText({this.width, this.height, this.color, this.opacity, this.text, this.callback, this.fontWeight = FontWeight.normal });

  @override
  Widget build(BuildContext context) {
    double fontSize = this.height * 0.55;
    return Button(
      width: this.width,
      height: this.height,
      color: this.color,
      opacity: this.opacity,
      child: Text(this.text,
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: this.fontWeight,
            color: Colors.black54
        ),
      ),
      callback: (){
        this.callback();
      },
    );
  }
}
