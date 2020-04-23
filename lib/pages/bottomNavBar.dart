import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvgui/bloc/Page/page_bloc.dart';
import 'package:tvgui/model/categories.dart';
import 'package:tvgui/model/channel/channel.dart';
import 'package:tvgui/pages/home.dart';
import 'package:tvgui/pages/search.dart';

import '../model/theme.dart';

import 'setting.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({Key key, this.cache, this.categories, this.sortedByCoutry})
      : super(key: key);
  final List<Channel> cache;
  final List<Category> categories;
  final List<SortedByCountry> sortedByCoutry;
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  Home _homePage;
  final SettingsPage _settingsPage = new SettingsPage();
  final SearchPage _searchPage = new SearchPage();

  @override
  void initState() {
    _homePage = new Home(
      cache: widget.cache,
      categories: widget.categories,
      sortedByCounty: widget.sortedByCoutry,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageBloc, int>(builder: (context, state) {
      return Scaffold(
        body: SizedBox.expand(
          child: IndexedStack(
            children: <Widget>[_searchPage, _homePage, _settingsPage],
            index: state,
          ),
        ),
        bottomNavigationBar: BottomNavyBar(
          itemCornerRadius: 70,
          backgroundColor: AppThemeData.PrimaryColor,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          selectedIndex: state,
          onItemSelected: (index) {
            BlocProvider.of<PageBloc>(context).add(ChangePage(page: index));
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
                textAlign: TextAlign.center,
                activeColor: AppThemeData.AppYellow,
                inactiveColor: AppThemeData.AppGray,
                icon: new Icon(Icons.search),
                title: new Text('بحث')),
            BottomNavyBarItem(
                textAlign: TextAlign.center,
                activeColor: AppThemeData.AppYellow,
                inactiveColor: AppThemeData.AppGray,
                icon: new Icon(Icons.tv),
                title: new Text('القنوات')),
            BottomNavyBarItem(
              textAlign: TextAlign.center,
              activeColor: AppThemeData.AppYellow,
              inactiveColor: AppThemeData.AppGray,
              icon: new Icon(Icons.settings),
              title: new Text(
                "الإعدادات",
              ),
            ),
          ],
        ),
      );
    });
  }
}
