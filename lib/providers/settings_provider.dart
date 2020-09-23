import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  int _flowDuration;
  int flowDuration = 5400;

  int _breakDuration;
  int breakDuration = 1200;

  bool _notifications;

  bool _sound;

  bool _coffeeTimer;

  bool _darkTheme;

  bool _firstTime = true;

  SettingsProvider({
    int flowDuration,
    int breakDuration,
    bool isNotificationOn,
    bool isSoundOn,
    bool isCoffeeTimerOn,
    bool isDarkThemeOn,
    bool isFirstTime,
  }) {
    _flowDuration = flowDuration;
    _breakDuration = breakDuration;
    _notifications = isNotificationOn ? true : false;
    _sound = isSoundOn ? true : false;
    _coffeeTimer = isCoffeeTimerOn ? true : false;
    _darkTheme = isDarkThemeOn ? true : false;
    _firstTime = isFirstTime ? true : false;
  }

  Future<void> flowDurationChange(int newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _flowDuration = newValue;
    prefs.setInt('flowDuration', _flowDuration);
    notifyListeners();
  }

  Future<void> breakDurationChange(int newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _breakDuration = newValue;
    prefs.setInt('breakDuration', _breakDuration);
    notifyListeners();
  }

  Future<void> swapNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _notifications = !_notifications;
    prefs.setBool('isNotifications', _notifications);
    notifyListeners();
  }

  Future<void> swapSound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _sound = !_sound;
    prefs.setBool('isSound', _sound);
    notifyListeners();
  }

  Future<void> swapCoffee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _coffeeTimer = !_coffeeTimer;
    prefs.setBool('isCoffeeTimer', _coffeeTimer);
    notifyListeners();
  }

  Future<void> swapDarkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _darkTheme = !_darkTheme;
    prefs.setBool('isDarkTheme', _darkTheme);
    notifyListeners();
  }

  Future<void> swapFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _firstTime = !_firstTime;
    prefs.setBool('isFirstTime', _firstTime);
    notifyListeners();
  }

  int get getFlowDuration => _flowDuration;

  int get getBreakDuration => _breakDuration;

  bool get getNotifications => _notifications;

  bool get getSound => _sound;

  bool get getCoffee => _coffeeTimer;

  bool get getDarkTheme => _darkTheme;

  bool get getFirstTime => _firstTime;
}
