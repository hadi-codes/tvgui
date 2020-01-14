import "package:flutter/material.dart";
import 'package:tvgui/model/theme.dart';
import 'package:tvgui/pages/home.dart';
import 'package:tvgui/pages/setting.dart';

class BottomNavBarPage extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBarPage> {
  var _curIndex = 0;
  var contents = "Home";
  Widget CurrentPage=SettingsPage();
  Widget _indexBottom() => BottomNavigationBar(
     elevation: 100.0,
            
            backgroundColor: ThemeDate.PrimaryColor,
            unselectedItemColor: Colors.white,
            selectedItemColor: Colors.yellow,
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.search), title: new Text('Search')),
          BottomNavigationBarItem(
              icon: new Icon(Icons.tv), title: new Text('Channles')),
          BottomNavigationBarItem(
            icon: new Icon(Icons.settings),
            title: new Text(
              "Settings",
            ),
          )
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _curIndex,
        onTap: (index) {
          setState(() {
            _curIndex = index;
            switch (_curIndex) {
              case 0:
                contents = "Search";
                break;
              case 1:
                contents = "Channels";
                break;
              case 2:
              setState(() {
                CurrentPage=SettingsPage();
              });
                break;
            }
          });
        },
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Container(child: CurrentPage,));
  }
}
