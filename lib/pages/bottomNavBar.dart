import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../model/theme.dart';
import '../model/theme.dart';
import '../model/theme.dart';
import 'home.dart';
import 'setting.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({Key key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Container(
              child: MyHomePage(),
            ),
            Container(
              child: MyHomePage(),
            ),
            Container(
              child: SettingsPage(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        itemCornerRadius: 70,
        backgroundColor: ThemeDate.PrimaryColor,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.animateToPage(index,
              curve: Curves.ease, duration: Duration(milliseconds: 300));
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              textAlign: TextAlign.center,
              activeColor: ThemeDate.AppYellow,
              inactiveColor: ThemeDate.AppGray,
              icon: new Icon(Icons.search),
              title: new Text('Search')),
          BottomNavyBarItem(
              textAlign: TextAlign.center,
              activeColor: ThemeDate.AppYellow,
              inactiveColor: ThemeDate.AppGray,
              icon: new Icon(Icons.tv),
              title: new Text('Channles')),
          BottomNavyBarItem(
            textAlign: TextAlign.center,
            activeColor: ThemeDate.AppYellow,
            inactiveColor: ThemeDate.AppGray,
            icon: new Icon(Icons.settings),
            title: new Text(
              "Settings",
            ),
          ),
        ],
      ),
    );
  }
}
