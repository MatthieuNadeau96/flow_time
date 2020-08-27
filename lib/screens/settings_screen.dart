import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsOn = true;
  bool soundOn = true;
  bool coffeTimerOn = true;
  bool darkThemeOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_rounded,
              size: 30,
              color:
                  Theme.of(context).textTheme.bodyText2.color.withOpacity(0.75),
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
                          '90min',
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
                          '20min',
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
                      value: notificationsOn,
                      onChanged: (newValue) {
                        setState(() {
                          notificationsOn = !notificationsOn;
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
                      value: soundOn,
                      onChanged: (newValue) {
                        setState(() {
                          soundOn = !soundOn;
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
                      value: coffeTimerOn,
                      onChanged: (newValue) {
                        setState(() {
                          coffeTimerOn = !coffeTimerOn;
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
                      value: darkThemeOn,
                      onChanged: (newValue) {
                        setState(() {
                          darkThemeOn = !darkThemeOn;
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
  }

  _showDialog(String text) async {
    await showDialog<String>(
      context: context,
      child: AlertDialog(
        content: Row(
          children: [
            Expanded(
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: '$text Duration',
                  labelStyle: TextStyle(fontSize: 22),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        actions: [
          FlatButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('CONFIRM'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
