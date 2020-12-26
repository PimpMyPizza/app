import 'package:flutter/material.dart';
import 'package:pilsbot/components/Button.dart';

class ButtonIcon extends StatelessWidget {
  final double size;
  final VoidCallback callback;
  final Color color;
  final double opacity;
  final IconData icon;

  ButtonIcon({this.size, this.color, this.opacity, this.icon, this.callback});

  @override
  Widget build(BuildContext context) {
    double iconSize = this.size - 10;
    return Button(
      width: this.size,
      height: this.size,
      color: this.color,
      opacity: this.opacity,
      child: Icon(
        this.icon,
        size: iconSize,
        color: Colors.black54,
      ),
      callback: (){
        this.callback();
      },
    );
  }
}
