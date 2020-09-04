import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flow_time/providers/settings_provider.dart';
import 'package:flow_time/screens/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';

class FlowScreen extends StatefulWidget {
  int flowDuration;
  int breakDuration;
  bool soundHandle;
  bool notificationHandle;
  FlowScreen({
    this.flowDuration,
    this.breakDuration,
    this.soundHandle,
    this.notificationHandle,
  });

  @override
  _FlowScreenState createState() => _FlowScreenState();
}

class _FlowScreenState extends State<FlowScreen> with WidgetsBindingObserver {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AudioPlayer audioPlayer = AudioPlayer();
  static AudioCache player = AudioCache();

  int _counter = 5000;
  int _flowDuration = 5400;
  int _flowTestTime = 10;
  int _breakDuration = 12;

  int _coffeeDuration = 1200;
  int _coffeeTestTime = 20;
  int _coffeeCounter = 1200;

  bool _isPlaying;
  bool _timeForBreak;
  bool _isCoffeePlaying;
  Timer _timer;
  Timer _coffeeTimer;
  bool _coffeeIsOn = true;

  bool _lifeCyclePaused = false;

  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;

  void _showNotification(String mode) async {
    if (widget.notificationHandle == true) {
      switch (mode) {
        case 'flow':
          {
            await _flowNotification();
          }
          break;
        case 'break':
          {
            await _breakNotification();
          }
          break;
        case 'coffee':
          {
            await _coffeeNotification();
          }
          break;
      }
    }
    return;
  }

  Future<void> _flowNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_ID',
      'channel_name',
      'channel_description',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'test ticker',
    );

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, 'Flow Finished', 'Ready for a break?', platformChannelSpecifics,
        payload: 'flow payload');
  }

  Future<void> _breakNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_ID',
      'channel_name',
      'channel_description',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'test ticker',
    );

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, 'Break Finished', 'Ready to work?', platformChannelSpecifics,
        payload: 'break payload');
  }

  Future<void> _coffeeNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_ID',
      'channel_name',
      'channel_description',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'test ticker',
    );

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, 'Coffee Finished', 'Time to refuel?', platformChannelSpecifics,
        payload: 'coffee payload');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _isPlaying = false;
    _timeForBreak = false;
    _isCoffeePlaying = false;
    initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    setState(() {
      state == AppLifecycleState.paused
          ? _lifeCyclePaused = true
          : _lifeCyclePaused = false;
    });
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('Notification payload: $payload');
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }

  void _timerHandler() {
    if (_isPlaying == true) {
      setState(() {
        _isPlaying = false;
      });
      _pauseTimer();
    } else {
      _startTimer(_counter);
    }
  }

  void _startTimer(int timerDuration) {
    _timeForBreak
        ? _counter = widget.breakDuration * 60
        : _counter = widget.flowDuration * 60;
    print(_counter);
    setState(() {
      _isPlaying = true;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {
          if (_counter > 0) {
            _counter--;
          } else {
            _timer.cancel();
            _lifeCyclePaused
                ? _timeForBreak
                    ? _showNotification('break')
                    : _showNotification('flow')
                : widget.soundHandle == true
                    ? player.play('sounds/ding.mp3')
                    : null;
            _isPlaying = false;
            _timeForBreak = !_timeForBreak;
            _counter = widget.breakDuration;
          }
        });
      }
    });
  }

  void _pauseTimer() {
    print(_counter);
    _timer.cancel();
  }

  void _coffeeTimerHandler() {
    if (_isCoffeePlaying == true) {
      setState(() {
        _isCoffeePlaying = false;
      });
      _pauseCoffeeTimer();
    } else {
      _startCoffeeTimer(_coffeeCounter);
    }
  }

  void _startCoffeeTimer(int timerDuration) {
    _coffeeCounter = timerDuration;
    setState(() {
      _isCoffeePlaying = true;
    });
    _coffeeTimer = Timer.periodic(Duration(seconds: 1), (Timer coffeeTimer) {
      if (mounted) {
        setState(() {
          if (_coffeeCounter > 0) {
            _coffeeCounter--;
          } else {
            _coffeeTimer.cancel();
            _showNotification('coffee');
            _isCoffeePlaying = false;
            _coffeeCounter = _coffeeTestTime;
          }
        });
      }
    });
  }

  void _pauseCoffeeTimer() {
    _coffeeTimer.cancel();
  }

  String formatTime(double time) {
    Duration duration = Duration(seconds: time.round());
    return [duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  double doubleConverter(double d, int time) => d / time;

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        height: 240,
                        width: 240,
                        child: LiquidCircularProgressIndicator(
                          value: _timeForBreak
                              ? doubleConverter(
                                  (_counter.toDouble()) + .5,
                                  widget.breakDuration,
                                )
                              : doubleConverter(
                                  (_counter.toDouble()) + .5,
                                  widget.flowDuration,
                                ),
                          valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).primaryColorLight),
                          backgroundColor: Colors.transparent,
                          borderColor: Colors.transparent,
                          borderWidth: 0,
                          direction: Axis.vertical,
                        ),
                      ),
                      Container(
                        height: 240,
                        width: 240,
                        child: LiquidCircularProgressIndicator(
                          value: _timeForBreak
                              ? doubleConverter(
                                  _counter.toDouble(),
                                  widget.breakDuration,
                                )
                              : doubleConverter(
                                  _counter.toDouble(),
                                  widget.flowDuration,
                                ),
                          valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).primaryColor),
                          backgroundColor: Colors.transparent,
                          borderColor: Colors.transparent,
                          borderWidth: 0,
                          direction: Axis.vertical,
                        ),
                      ),
                      Text('${_counter}'),
                    ],
                  ),
                  // Text(
                  //   formatTime(_counter.toDouble()),
                  //   style: Theme.of(context).textTheme.headline6,
                  // ),
                  InkWell(
                    onTap: _timerHandler,
                    borderRadius: BorderRadius.circular(100),
                    splashColor: Theme.of(context).primaryColorLight,
                    child: Ink(
                      width: 117,
                      height: 117,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: _isPlaying
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
                      ),
                    ),
                  ),
                  if (settingsProvider.getCoffee)
                    GestureDetector(
                      onTap: _coffeeTimerHandler,
                      child: Container(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 64,
                                  width: 64,
                                  child: LiquidCircularProgressIndicator(
                                    value: doubleConverter(
                                        (_coffeeCounter.toDouble()) + 2,
                                        _coffeeTestTime),
                                    valueColor: AlwaysStoppedAnimation(
                                        Colors.brown[300]),
                                    backgroundColor: Colors.transparent,
                                    borderColor: Colors.transparent,
                                    borderWidth: 0,
                                    direction: Axis.vertical,
                                  ),
                                ),
                                Container(
                                  height: 64,
                                  width: 64,
                                  child: LiquidCircularProgressIndicator(
                                    value: doubleConverter(
                                        _coffeeCounter.toDouble(),
                                        _coffeeTestTime),
                                    valueColor: AlwaysStoppedAnimation(
                                      Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                    ),
                                    backgroundColor: Colors.transparent,
                                    borderColor: Colors.transparent,
                                    borderWidth: 0,
                                    direction: Axis.vertical,
                                  ),
                                ),
                                Text('$_coffeeCounter'),
                              ],
                            ),
                            // Text(
                            //   formatTime(_coffeeCounter.toDouble()),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  GestureDetector(
                    child: Icon(
                      Icons.settings_rounded,
                      size: 35,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .color
                          .withOpacity(0.75),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen()),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
