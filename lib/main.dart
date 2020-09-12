import 'dart:async';

import 'package:flow_time/providers/settings_provider.dart';
import 'package:flow_time/screens/flow_screen.dart';
import 'package:flutter/material.dart';
import 'package:highlighter_coachmark/highlighter_coachmark.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(
    ChangeNotifierProvider(
      child: MyApp(),
      create: (BuildContext context) => SettingsProvider(
        flowDuration: prefs.getInt('flowDuration') ?? 90,
        breakDuration: prefs.getInt('breakDuration') ?? 20,
        isNotificationOn: prefs.getBool('isNotifications') ?? true,
        isSoundOn: prefs.getBool('isSound') ?? true,
        isCoffeeTimerOn: prefs.getBool('isCoffeeTimer') ?? true,
        isDarkThemeOn: prefs.getBool('isDarkTheme') ?? false,
        isFirstTime: prefs.getBool('isFirstTime') ?? false,
      ),
    ),
  );
}

// Primary Color 3A7BF2
// Primary Color Light 6A9BF6
// Accent Color A3BCFE
// Canvas Color FAFCFF
// Font Color 010813
// Light Grey F2F4F7
// Dark Grey D1D9E0
// Coffee Color 6D4D3E
// Coffee Color Light 947060

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return MaterialApp(
          title: 'Flow Time',
          debugShowCheckedModeBanner: false,
          theme: !settingsProvider.getDarkTheme
              // LIGHT THEME
              ? ThemeData(
                  primaryColor: Color(0xff3A7BF2),
                  primaryColorLight: Color(0xff6A9BF6),
                  accentColor: Color(0xffA3BCFE),
                  canvasColor: Color(0xffFAFCFF),
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  textTheme: TextTheme(
                    bodyText2: TextStyle(
                      color: Color(0xff010813),
                    ),
                    bodyText1: TextStyle(
                      // coffee color
                      color: Color(0xff6D4D3E),
                    ),
                  ),
                  iconTheme: IconThemeData(
                    color: Color(0xffD1D9E0),
                  ),
                )
              // DARK THEME
              : ThemeData(
                  primaryColor: Color(0xff083487),
                  primaryColorLight: Color(0xff0A43AE),
                  accentColor: Color(0xff7297FE),
                  canvasColor: Color(0xff021027),
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  textTheme: TextTheme(
                    bodyText2: TextStyle(
                      color: Color(0xffFAFCFF),
                    ),
                    bodyText1: TextStyle(
                      color: Color(0xff412E25), // coffee color
                    ),
                  ),
                  iconTheme: IconThemeData(
                    color: Color(0xffFAFCFF),
                  ),
                ),
          home: RootPage(),
        );
      },
    );
  }
}

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  GlobalKey _buttonKey = GlobalObjectKey("button");
  GlobalKey _timerKey = GlobalObjectKey("timer");

  bool _firstTime;

  void showCoachMarkButton() {
    CoachMark coachMark = CoachMark();
    RenderBox target = _buttonKey.currentContext.findRenderObject();
    Rect markRect = target.localToGlobal(Offset.zero) & target.size;
    markRect = Rect.fromCircle(
      center: markRect.center,
      radius: markRect.longestSide * 0.16,
    );
    coachMark.show(
        targetContext: _buttonKey.currentContext,
        markRect: markRect,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 100),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Long tap on button to see more options",
                style: TextStyle(
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).canvasColor,
                ),
              ),
            ),
          ),
        ],
        duration: null,
        onClose: () {
          Timer(Duration(seconds: 1), () => showCoachMarkTimer());
        });
  }

  void showCoachMarkTimer() {
    CoachMark coachMark = CoachMark();
    RenderBox target = _timerKey.currentContext.findRenderObject();
    Rect markRect = target.localToGlobal(Offset.zero) & target.size;
    markRect = Rect.fromCircle(
      center: markRect.center,
      radius: markRect.longestSide * 0.5,
    );
    coachMark.show(
      targetContext: _buttonKey.currentContext,
      markRect: markRect,
      children: [
        Container(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "Long tap on timers to see time remaining",
              style: TextStyle(
                fontSize: 20.0,
                fontStyle: FontStyle.italic,
                color: Theme.of(context).canvasColor,
              ),
            ),
          ),
        ),
      ],
      duration: null,
    );
  }

  void onBoardYo() {
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    if (!settingsProvider.getFirstTime) {
      Timer(Duration(seconds: 1), () => showCoachMarkButton());
    }
  }

  @override
  void initState() {
    super.initState();
    onBoardYo();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return Scaffold(
          body: FlowScreen(
            buttonKey: _buttonKey,
            timerKey: _timerKey,
            flowDuration: settingsProvider.getFlowDuration * 60,
            breakDuration: settingsProvider.getBreakDuration * 60,
            soundHandle: settingsProvider.getSound,
            notificationHandle: settingsProvider.getNotifications,
          ),
        );
      },
    );
  }
}
