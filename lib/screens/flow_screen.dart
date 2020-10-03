import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flow_time/providers/settings_provider.dart';
import 'package:flow_time/screens/settings_screen.dart';
import 'package:flow_time/widgets/circular_button.dart';
import 'package:flow_time/widgets/round_action_button.dart';
import 'package:flow_time/widgets/wave_timer.dart';
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
  Function interstitialAdHandler;
  FlowScreen({
    this.flowDuration,
    this.breakDuration,
    this.soundHandle,
    this.notificationHandle,
    this.interstitialAdHandler,
  });

  @override
  _FlowScreenState createState() => _FlowScreenState();
}

class _FlowScreenState extends State<FlowScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AudioPlayer audioPlayer = AudioPlayer();
  static AudioCache player = AudioCache();

  AnimationController animationController;
  Animation degOneTranslationAnimation;

  int _counter;

  int _coffeeDuration = 1200;
  int _coffeeCounter = 1200;

  bool _isPlaying;
  bool _timeForBreak;
  bool _isCoffeePlaying;
  bool _isPaused = false;
  Timer _timer;
  Timer _coffeeTimer;
  bool _waveTimerHeld = false;
  bool _coffeeTimerHeld = false;

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
        0, 'Your coffee is stale!', 'Time to refuel?', platformChannelSpecifics,
        payload: 'coffee payload');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _isPlaying = false;
    _timeForBreak = false;
    _isCoffeePlaying = false;
    initializationSettingsAndroid =
        AndroidInitializationSettings('wave_thick_512');
    initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    degOneTranslationAnimation =
        Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    ));
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // print(state);
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
      // debugPrint('Notification payload: $payload');
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
    if (_isPaused) {
      _counter = timerDuration;
    } else {
      _timeForBreak
          ? _counter = widget.breakDuration
          : _counter = widget.flowDuration;
    }
    // print(_counter);
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
            if (!_lifeCyclePaused) widget.interstitialAdHandler();
          }
        });
      }
    });
  }

  void _stopTimer() {
    setState(() {
      _isPlaying = false;
      _timer.cancel();
      _timeForBreak
          ? _counter = widget.breakDuration
          : _counter = widget.flowDuration;
    });
  }

  void _skipTimer() {
    setState(() {
      _isPlaying = false;
      _timer.cancel();
      if (_timeForBreak) {
        _counter = widget.flowDuration;
        _timeForBreak = false;
      } else {
        _counter = widget.breakDuration;
        _timeForBreak = true;
      }
    });
  }

  void _pauseTimer() {
    // print(_counter);
    _isPaused = true;
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
            _coffeeCounter = _coffeeDuration;
            widget.interstitialAdHandler();
          }
        });
      }
    });
  }

  void _stopCoffeeTimer() {
    setState(() {
      _isCoffeePlaying = false;
      _coffeeTimer.cancel();
      _coffeeCounter = 1200;
    });
  }

  void _pauseCoffeeTimer() {
    _coffeeTimer.cancel();
  }

  String formatTime(double time) {
    Duration duration = Duration(seconds: time.round());

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (time > 3599) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  double doubleConverter(double d, int time) => d / time;

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          SettingsScreen(adHandler: widget.interstitialAdHandler),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    print(deviceSize);
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        if (_counter == null) {
          _counter = widget.flowDuration;
        }
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
                      GestureDetector(
                        onLongPress: () {
                          setState(() {
                            _waveTimerHeld = !_waveTimerHeld;
                          });
                        },
                        child: Container(
                          height: deviceSize.width < 350 ? 180 : 250,
                          width: deviceSize.width < 350 ? 180 : 250,
                          key: GlobalObjectKey('timer'),
                          child: Center(
                            child: WaveTimer(
                              height: 240,
                              width: 240,
                              value: _timeForBreak
                                  ? doubleConverter(
                                      (_counter.toDouble()),
                                      widget.breakDuration,
                                    )
                                  : doubleConverter(
                                      (_counter.toDouble()),
                                      widget.flowDuration,
                                    ),
                              foamColor: Theme.of(context).primaryColorLight,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      if (_waveTimerHeld)
                        Positioned.fill(
                          child: Stack(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  formatTime(_counter.toDouble()),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      .copyWith(
                                        fontWeight: FontWeight.w700,
                                        color:
                                            Theme.of(context).primaryColorLight,
                                      ),
                                ),
                              ),
                              Align(
                                heightFactor: 8,
                                alignment: Alignment.bottomCenter,
                                child: Icon(
                                  _timeForBreak ? Icons.local_cafe : Icons.work,
                                  color: Theme.of(context).primaryColorLight,
                                  // size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  Container(
                    height: deviceSize.width < 350 ? 100 : null,
                    key: GlobalObjectKey('button'),
                    child: RoundActionButton(
                      animation: degOneTranslationAnimation,
                      radiansFromDegree: getRadiansFromDegree,
                      animationController: animationController,
                      skipTimer: _skipTimer,
                      stopTimer: _stopTimer,
                      isPlaying: _isPlaying,
                      timerHandler: _timerHandler,
                    ),
                  ),
                  if (settingsProvider.getCoffee)
                    GestureDetector(
                      onTap: _coffeeTimerHandler,
                      onLongPress: () {
                        setState(() {
                          _coffeeTimerHeld = !_coffeeTimerHeld;
                        });
                      },
                      onHorizontalDragEnd: (DragEndDetails details) {
                        if (details.velocity.pixelsPerSecond.dx > 0) {
                          _showDialog();
                        }
                      },
                      child: Stack(
                        children: [
                          Container(
                            key: GlobalObjectKey('coffee'),
                            child: WaveTimer(
                              height: deviceSize.width < 350 ? 44 : 64,
                              width: deviceSize.width < 350 ? 44 : 64,
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              foamColor: Colors.brown[300],
                              value: doubleConverter(
                                  _coffeeCounter.toDouble(), _coffeeDuration),
                            ),
                          ),
                          if (_coffeeTimerHeld)
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  formatTime(_coffeeCounter.toDouble()),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      .copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: Colors.brown[300],
                                      ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  GestureDetector(
                    child: Icon(
                      Icons.settings_rounded,
                      size: deviceSize.width < 350 ? 28 : 35,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .color
                          .withOpacity(0.75),
                    ),
                    onTap: () {
                      Navigator.of(context).push(_createRoute());
                    },
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _showDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Reset Coffee Timer'),
        content: Text('Are you sure?'),
        actions: [
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.pop(context);
              _stopCoffeeTimer();
            },
          ),
        ],
        elevation: 24.0,
      ),
    );
  }
}
