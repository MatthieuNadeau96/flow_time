import 'package:flow_time/providers/settings_provider.dart';
import 'package:flow_time/screens/flow_screen.dart';
import 'package:flow_time/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
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
  // @override
  // void initState() {
  //   WidgetsBinding.instance.addObserver(this);
  //   super.initState();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   print(state);
  //   super.didChangeAppLifecycleState(state);
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    List<PageViewModel> getPages() {
      return [
        PageViewModel(
          title:
              "Flow time is designed to help you get into a flow state of mind. Making sure you stay focused and fully immersed in your work.",
          body: '',
          decoration: PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 20,
            ),
          ),
          image: Center(
            child: Container(
              height: 200,
              width: 200,
              child: Placeholder(),
            ),
          ),
        ),
        PageViewModel(
          title: "",
          bodyWidget: Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.80,
              child: Image.asset('assets/images/onboarding_screenshot.png'),
            ),
          ),
        ),
        PageViewModel(
          title: "",
          bodyWidget: Container(
            height: MediaQuery.of(context).size.height * 0.80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Image.asset('assets/images/undraw_onboarding.png'),
                ),
                Text(''),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: const EdgeInsets.all(20),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    setState(() {
                      SettingsProvider settingsProvider =
                          Provider.of<SettingsProvider>(context, listen: false);
                      settingsProvider.swapFirstTime();
                    });
                  },
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                      color: Theme.of(context).canvasColor,
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return Scaffold(
          body: !settingsProvider.getFirstTime
              ? IntroductionScreen(
                  done: Text(
                    '',
                    style: theme.textTheme.bodyText2.copyWith(),
                  ),
                  onDone: () {
                    setState(() {
                      SettingsProvider settingsProvider =
                          Provider.of<SettingsProvider>(context, listen: false);
                      settingsProvider.swapFirstTime();
                    });
                  },
                  dotsDecorator: DotsDecorator(
                    size: const Size.square(10.0),
                    activeSize: const Size(20.0, 10.0),
                    activeColor: theme.accentColor,
                    color: theme.iconTheme.color,
                    spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                    activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  pages: getPages(),
                )
              : FlowScreen(
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
