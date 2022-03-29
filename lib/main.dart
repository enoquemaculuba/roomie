import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roomie/pages/favorites.dart';
import 'package:roomie/pages/home.dart';
import 'package:roomie/pages/login.dart';
import 'package:roomie/pages/reservations.dart';
import 'package:roomie/pages/settings.dart';
import 'dart:collection';

import 'package:roomie/util/globals.dart' as globals;

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  globals.page = "home";

  runApp(const MyApp());
}

String initial = LoginPage.routeName;

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initial,
      routes: {
        LoginPage.routeName: (context) => const LoginPage(),
        MainPage.routeName: (context) => const MainPage(),
      },
      theme: ThemeData(
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Colors.orange),
        // fontFamily: 'SourceSansPro',
        textTheme: TextTheme(
          headline3: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 45.0,
            // fontWeight: FontWeight.w400,
            color: Colors.pink,
          ),
          button: const TextStyle(
            // OpenSans is similar to NotoSans but the uppercases look a bit better IMO
            fontFamily: 'OpenSans',
          ),
          caption: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: Colors.pink[300],
          ),
          headline1: const TextStyle(fontFamily: 'Quicksand'),
          headline2: const TextStyle(fontFamily: 'Quicksand'),
          headline4: const TextStyle(fontFamily: 'Quicksand'),
          headline5: const TextStyle(fontFamily: 'NotoSans'),
          headline6: const TextStyle(fontFamily: 'NotoSans'),
          subtitle1: const TextStyle(fontFamily: 'NotoSans'),
          bodyText1: const TextStyle(fontFamily: 'NotoSans'),
          bodyText2: const TextStyle(fontFamily: 'NotoSans'),
          subtitle2: const TextStyle(fontFamily: 'NotoSans'),
          overline: const TextStyle(fontFamily: 'NotoSans'),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink),
      ),
      home: const MainPage(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MainPage extends StatefulWidget {
  static const String routeName = '/main';
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MainPage> {
  final ListQueue<int> _navigationQueue = ListQueue();
  int index = 0;

  final List<Widget> _pages = const <Widget>[
    HomePage(),
    ReservationsPage(),
    FavoritesPage(),
    SettingsPage(),
  ];

  void addToQueue(String name) {
    if (globals.pageQueue.length >= 4) {
      globals.pageQueue.removeLast();
      globals.pageQueue.add(name);
    } else {
      globals.pageQueue.add(name);
    }
  }

  void _onItemTapped(int value) {
    if (value != index) {
      _navigationQueue.removeWhere((element) => element == index);
      _navigationQueue.addLast(index);
      setState(() {
        index = value;
      });
      addToQueue(globals.page);
      switch (index) {
        case 0:
          globals.page = "home";
          break;
        case 1:
          globals.page = "reservations";
          break;
        case 2:
          globals.page = "favorites";
          break;
        case 3:
          globals.page = "settings";
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (initial == LoginPage.routeName) {
      initial = MainPage.routeName;
    }
    return WillPopScope(
      onWillPop: () async {
        if (_navigationQueue.isEmpty) return true;
        setState(() {
          _navigationQueue.removeLast();
          int position = _navigationQueue.isEmpty ? 0 : _navigationQueue.last;
          index = position;
        });
        return false;
      },
      child: Scaffold(
        body: _pages[index],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 15,
          selectedIconTheme: IconThemeData(color: Colors.pink[600], size: 30),
          selectedItemColor: Colors.pink[600],
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedIconTheme: const IconThemeData(
            color: Colors.black,
          ),
          showUnselectedLabels: true,
          elevation: 0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Koti',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              label: 'Varaukset',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              label: 'Suosikit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.app_settings_alt_outlined),
              label: 'Asetukset',
            ),
          ],
          currentIndex: index,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
