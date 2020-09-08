import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class WaveTimer extends StatelessWidget {
  final double height;
  final double width;
  final double value;
  final Color foamColor;
  final Color color;

  WaveTimer({
    this.height,
    this.width,
    this.value,
    this.foamColor,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          width: width,
          child: LiquidCircularProgressIndicator(
            value: value + value * 0.1,
            valueColor: AlwaysStoppedAnimation(foamColor),
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            borderWidth: 0,
            direction: Axis.vertical,
          ),
        ),
        Container(
          height: height,
          width: width,
          child: LiquidCircularProgressIndicator(
            value: value,
            valueColor: AlwaysStoppedAnimation(color),
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            borderWidth: 0,
            direction: Axis.vertical,
          ),
        ),
      ],
    );
  }
}
