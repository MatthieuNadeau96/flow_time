import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  int _flowDuration;
  int flowDuration = 40; // test // real is -> 5400

  int _breakDuration;
  int breakDuration = 20; // test // real is -> 1200

  bool _notifications;
  bool notifications = true;

  bool _sound;
  bool sound = true;

  bool _coffeeTimer;
  bool coffeeTimer = true;

  bool _darkTheme;
  bool darkTheme = false;

  SettingsProvider({
    int flowDuration,
    int breakDuration,
    bool isNotificationOn,
    bool isSoundOn,
    bool isCoffeeTimerOn,
    bool isDarkThemeOn,
  }) {
    _flowDuration = flowDuration;
    _breakDuration = breakDuration;
    _notifications = isNotificationOn ? true : false;
    _sound = isSoundOn ? true : false;
    _coffeeTimer = isCoffeeTimerOn ? true : false;
    _darkTheme = isDarkThemeOn ? true : false;
  }

  void flowDurationChange(int newValue) {
    _flowDuration = newValue;
    notifyListeners();
  }

  void breakDurationChange(int newValue) {
    _flowDuration = newValue;
    notifyListeners();
  }

  void swapNotifications() {
    _notifications = !_notifications;
    notifyListeners();
  }

  void swapSound() {
    _sound = !_sound;
    notifyListeners();
  }

  void swapCoffee() {
    _coffeeTimer = !_coffeeTimer;
    notifyListeners();
  }

  void swapDarkTheme() {
    _darkTheme = !_darkTheme;
    notifyListeners();
  }

  int get getFlowDuration => _flowDuration;

  bool get getNotifications => _notifications;

  bool get getSound => _sound;

  bool get getCoffee => _coffeeTimer;

  bool get getDarkTheme => _darkTheme;
}
