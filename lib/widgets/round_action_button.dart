import 'package:flow_time/widgets/circular_button.dart';
import 'package:flutter/material.dart';

class RoundActionButton extends StatelessWidget {
  final Animation animation;
  final Function radiansFromDegree;
  final AnimationController animationController;
  final Function skipTimer;
  final Function stopTimer;
  bool isPlaying;
  final Function timerHandler;

  RoundActionButton({
    this.animation,
    this.radiansFromDegree,
    this.animationController,
    this.skipTimer,
    this.stopTimer,
    this.isPlaying,
    this.timerHandler,
  });

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    bool smallDevice = deviceSize.width < 300;
    return Stack(
      children: [
        Transform.translate(
          offset: Offset.fromDirection(
            radiansFromDegree(0.0),
            animation.value * 100,
          ),
          child: Transform.scale(
            scale: animation.value,
            child: Container(
              height: 117,
              child: CircularButton(
                width: smallDevice ? 40 : 50,
                height: smallDevice ? 40 : 50,
                color: Color(0xff85A6FE).withOpacity(animation.value),
                icon: Icon(
                  Icons.skip_next,
                  color: Theme.of(context).canvasColor,
                ),
                onTap: skipTimer,
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: Offset.fromDirection(
            radiansFromDegree(180.0),
            animation.value * 100,
          ),
          child: Transform.scale(
            scale: animation.value,
            child: Container(
              height: 117,
              child: CircularButton(
                width: smallDevice ? 40 : 50,
                height: smallDevice ? 40 : 50,
                color: Color(0xff85A6FE).withOpacity(animation.value),
                icon: Icon(
                  Icons.stop,
                  color: Theme.of(context).canvasColor,
                ),
                onTap: stopTimer,
              ),
            ),
          ),
        ),
        CircularButton(
          width: smallDevice ? 90 : 117,
          height: smallDevice ? 90 : 117,
          color: Theme.of(context).accentColor,
          icon: isPlaying
              ? Icon(
                  Icons.pause,
                  size: 60,
                  color: Theme.of(context).canvasColor,
                )
              : Icon(
                  Icons.play_arrow,
                  size: 60,
                  color: Theme.of(context).canvasColor,
                ),
          onTap: timerHandler,
          onLongTap: () {
            if (animationController.isCompleted) {
              animationController.reverse();
            } else {
              animationController.forward();
            }
          },
        ),
      ],
    );
  }
}
