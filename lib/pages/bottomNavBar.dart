import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tvgui/channelspls/channel.dart';
import 'package:tvgui/pages/searchPage.dart';

import '../model/theme.dart';

import 'home.dart';
import 'setting.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({Key key,this.cache}) : super(key: key);
  final List<Channel> cache;
  
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 1;
  PageController pageController;
  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Container(
              child: SearchPage(),
            ),
            Container(
              child: MyHomePage(cache: widget.cache,),
            ),
            Container(
              child: SettingsPage(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        itemCornerRadius: 70,
        backgroundColor: AppThemeData.PrimaryColor,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              textAlign: TextAlign.center,
              activeColor: AppThemeData.AppYellow,
              inactiveColor: AppThemeData.AppGray,
              icon: new Icon(Icons.search),
              title: new Text('Search')),
          BottomNavyBarItem(
              textAlign: TextAlign.center,
              activeColor: AppThemeData.AppYellow,
              inactiveColor: AppThemeData.AppGray,
              icon: new Icon(Icons.tv),
              title: new Text('Channles')),
          BottomNavyBarItem(
            textAlign: TextAlign.center,
            activeColor: AppThemeData.AppYellow,
            inactiveColor: AppThemeData.AppGray,
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
