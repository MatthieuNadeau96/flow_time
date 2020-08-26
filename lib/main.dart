import 'package:flow_time/screens/flow_screen.dart';
import 'package:flow_time/screens/settings_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
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
    return MaterialApp(
      title: 'Flow Time',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff3A7BF2),
        primaryColorLight: Color(0xff6A9BF6),
        accentColor: Color(0xffA3BCFE),
        canvasColor: Color(0xffFAFCFF),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyText2: TextStyle(
            color: Color(0xff010813),
          ),
        ),
        iconTheme: IconThemeData(
          color: Color(0xffD1D9E0),
        ),
      ),
      home: RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  PageController _pageController = PageController(
    initialPage: 0,
  );
  int _selectedIndex = 0;

  final screens = [
    FlowScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).iconTheme.color,
        unselectedIconTheme: IconThemeData(
          size: 20,
        ),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.waves),
            title: Text('Flow'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
        onTap: (value) {
          _selectedIndex = value;
          _pageController.animateToPage(
            value,
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
          );
          setState(() {});
        },
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
        children: [
          screens[0],
          screens[1],
        ],
      ),
    );
  }
}
