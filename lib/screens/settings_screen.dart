import 'package:flow_time/providers/settings_provider.dart';
import 'package:flow_time/widgets/settings_number_item.dart';
import 'package:flow_time/widgets/settings_switch_item.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import 'help_screen.dart';

class SettingsScreen extends StatefulWidget {
  final Function adHandler;
  SettingsScreen({
    this.adHandler,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int flowDuration = 90;
  int breakDuration = 30;
  bool notificationsOn = true;
  bool soundOn = true;
  bool coffeTimerOn = true;
  bool darkThemeOn = false;

  final flowTextController = TextEditingController();

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HelpScreen(),
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
    var theme = Theme.of(context);
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        bool dark = settingsProvider.getDarkTheme;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).canvasColor,
            elevation: 0,
            leading: Container(
              width: 56,
              height: 56,
              child: GestureDetector(
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 24,
                  color: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .color
                      .withOpacity(0.75),
                ),
                onTap: () {
                  // widget.adHandler();
                  Navigator.pop(context);
                },
              ),
            ),
            actions: [
              Container(
                width: 56,
                height: 56,
                child: Center(
                  child: GestureDetector(
                    child: Icon(
                      Icons.help_outline,
                      size: 24,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .color
                          .withOpacity(0.75),
                    ),
                    onTap: () {
                      // widget.adHandler();

                      Navigator.of(context).push(_createRoute());
                    },
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SettingsNumberItem(
                    title: 'Flow Duration',
                    numberText: '${settingsProvider.getFlowDuration} min',
                    color: dark ? theme.accentColor : theme.primaryColor,
                    onTap: () => _showDialog('Flow'),
                  ),
                  SettingsNumberItem(
                    title: 'Break Duration',
                    numberText: '${settingsProvider.getBreakDuration} min',
                    color: dark ? theme.accentColor : theme.primaryColor,
                    onTap: () => _showDialog('Break'),
                  ),
                  SettingsSwitchItem(
                    title: 'Notifications',
                    value: settingsProvider.getNotifications,
                    onChange: (newValue) {
                      setState(() {
                        SettingsProvider settingsProvider =
                            Provider.of<SettingsProvider>(context,
                                listen: false);
                        settingsProvider.swapNotifications();
                      });
                    },
                    color: dark ? theme.accentColor : theme.primaryColor,
                  ),
                  SettingsSwitchItem(
                    title: 'Sound',
                    value: settingsProvider.getSound,
                    onChange: (newValue) {
                      setState(() {
                        SettingsProvider settingsProvider =
                            Provider.of<SettingsProvider>(context,
                                listen: false);
                        settingsProvider.swapSound();
                      });
                    },
                    color: dark ? theme.accentColor : theme.primaryColor,
                  ),
                  SettingsSwitchItem(
                    title: 'Coffee Timer',
                    value: settingsProvider.getCoffee,
                    onChange: (newValue) {
                      setState(() {
                        SettingsProvider settingsProvider =
                            Provider.of<SettingsProvider>(context,
                                listen: false);
                        settingsProvider.swapCoffee();
                      });
                    },
                    color: dark ? theme.accentColor : theme.primaryColor,
                  ),
                  SettingsSwitchItem(
                    title: 'Dark Theme',
                    value: settingsProvider.getDarkTheme,
                    onChange: (newValue) {
                      setState(() {
                        SettingsProvider settingsProvider =
                            Provider.of<SettingsProvider>(context,
                                listen: false);
                        settingsProvider.swapDarkTheme();
                      });
                    },
                    color: dark ? theme.accentColor : theme.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _showDialog(String text) async {
    bool isFlow = text == 'Flow';

    await showDialog<int>(
      context: context,
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          var theme = Theme.of(context);
          bool dark = settingsProvider.getDarkTheme;

          return AlertDialog(
            backgroundColor: theme.canvasColor,
            title: Text(
              '$text Duration',
              style: TextStyle(
                color: theme.textTheme.bodyText2.color,
              ),
            ),
            content: NumberPicker.integer(
              initialValue: isFlow
                  ? settingsProvider.getFlowDuration
                  : settingsProvider.getBreakDuration,
              minValue: 1,
              maxValue: 120,
              step: 1,
              onChanged: (newValue) {
                SettingsProvider settingsProvider =
                    Provider.of<SettingsProvider>(context, listen: false);
                setState(
                  () {
                    if (isFlow) {
                      settingsProvider.flowDurationChange(newValue);
                    } else {
                      settingsProvider.breakDurationChange(newValue);
                    }
                  },
                );
              },
            ),
            actions: [
              FlatButton(
                child: Text(
                  'CONFIRM',
                  style: TextStyle(
                    color: dark ? theme.accentColor : theme.primaryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
