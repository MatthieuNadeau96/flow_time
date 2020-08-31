import 'package:flow_time/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return Scaffold(
          appBar: AppBar(
              backgroundColor: Theme.of(context).canvasColor,
              elevation: 0,
              leading: GestureDetector(
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 30,
                  color: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .color
                      .withOpacity(0.75),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )),
          body: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Flow Duration',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 18,
                            ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 60,
                        child: GestureDetector(
                          child: Center(
                            child: Text(
                              '${settingsProvider.getFlowDuration} min',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          onTap: () => _showDialog('Flow'),
                        ),
                      )
                    ],
                  ),
                  // SizedBox(height: 15),
                  Divider(
                    color: Theme.of(context).iconTheme.color,
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Break Duration',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 18,
                            ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 60,
                        child: GestureDetector(
                          child: Center(
                            child: Text(
                              '$breakDuration min',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          onTap: () => _showDialog('Break'),
                        ),
                      )
                    ],
                  ),
                  // SizedBox(height: 15),
                  Divider(
                    color: Theme.of(context).iconTheme.color,
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notifications',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 18,
                            ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 60,
                        child: Switch(
                          activeColor: Theme.of(context).primaryColor,
                          value: settingsProvider.getNotifications,
                          onChanged: (newValue) {
                            setState(() {
                              SettingsProvider settingsProvider =
                                  Provider.of<SettingsProvider>(context,
                                      listen: false);
                              settingsProvider.swapNotifications();
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  // SizedBox(height: 15),
                  Divider(
                    color: Theme.of(context).iconTheme.color,
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sound',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 18,
                            ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 60,
                        child: Switch(
                          activeColor: Theme.of(context).primaryColor,
                          value: settingsProvider.getSound,
                          onChanged: (newValue) {
                            setState(() {
                              SettingsProvider settingsProvider =
                                  Provider.of<SettingsProvider>(context,
                                      listen: false);
                              settingsProvider.swapSound();
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  // SizedBox(height: 15),
                  Divider(
                    color: Theme.of(context).iconTheme.color,
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Coffee Timer',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 18,
                            ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 60,
                        child: Switch(
                          activeColor: Theme.of(context).primaryColor,
                          value: settingsProvider.getCoffee,
                          onChanged: (newValue) {
                            setState(() {
                              SettingsProvider settingsProvider =
                                  Provider.of<SettingsProvider>(context,
                                      listen: false);
                              settingsProvider.swapCoffee();
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  // SizedBox(height: 15),
                  Divider(
                    color: Theme.of(context).iconTheme.color,
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dark Theme',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 18,
                            ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 60,
                        child: Switch(
                          activeColor: Theme.of(context).primaryColor,
                          value: settingsProvider.getDarkTheme,
                          onChanged: (newValue) {
                            setState(() {
                              SettingsProvider settingsProvider =
                                  Provider.of<SettingsProvider>(context,
                                      listen: false);
                              settingsProvider.swapDarkTheme();
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  // SizedBox(height: 15),
                  Divider(
                    color: Theme.of(context).iconTheme.color,
                    thickness: 1,
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
      child: AlertDialog(
        title: Text('$text Duration'),
        content: NumberPicker.integer(
            initialValue: isFlow ? flowDuration : breakDuration,
            minValue: 20,
            maxValue: 100,
            step: 1,
            onChanged: (newValue) {
              setState(() {
                isFlow ? flowDuration = newValue : breakDuration = newValue;
              });
              SettingsProvider settingsProvider =
                  Provider.of<SettingsProvider>(context, listen: false);
              settingsProvider.flowDurationChange(newValue);
            }),
        actions: [
          FlatButton(
            child: Text(
              'CONFIRM',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
