import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final Function onTap;
  final Function onLongTap;

  CircularButton({
    this.width,
    this.height,
    this.color,
    this.icon,
    this.onTap,
    this.onLongTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongTap,
        borderRadius: BorderRadius.circular(100),
        splashColor: Theme.of(context).primaryColorLight,
        child: Ink(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: icon,
          ),
        ),
      ),
    );
  }
}
