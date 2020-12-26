import 'package:clippy_flutter/bevel.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback callback;
  final Color color;
  final double opacity;
  final Widget child;

  Button({this.width, this.height, this.color, this.opacity, this.child, this.callback});

  @override
  Widget build(BuildContext context) {
    double cutLength = this.height * 0.25;
    return GestureDetector(
      onTap: (){
        this.callback();
      },
      child: Container(
        padding: EdgeInsets.all(3),
        child: Bevel(
          cutLength: cutLength,
          child: Container(
            width: this.width,
            height: this.height,
            decoration: BoxDecoration(
              color: this.color,
            ),
            child: Center(
              child: this.child,
            ),
          ),
        ),
      )
    );
  }
}
