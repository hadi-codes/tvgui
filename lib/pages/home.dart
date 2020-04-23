import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvgui/bloc/video/video_bloc.dart';
import 'package:tvgui/db/db.dart';
import 'package:tvgui/model/categories.dart';
import 'package:tvgui/model/channel/channel.dart';
import 'package:tvgui/model/notes.dart';
import 'package:tvgui/model/settings.dart';
import 'package:tvgui/widgets/better_video_player.dart';
import 'package:tvgui/widgets/title_servers.dart';

import '../model/theme.dart';

class Country {
  String name;
  String icon;
}

class Home extends StatefulWidget {
  Home({Key key, this.cache, this.categories, this.sortedByCounty})
      : super(key: key);
  final List<Channel> cache;
  final List<Category> categories;
  final List<SortedByCountry> sortedByCounty;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  ScrollController _scrollViewController;
  bool _isUpBottomVisible = false;
  final List<Tab> tabs = <Tab>[];
  final List<Tab> countryTabs = <Tab>[];
  TabController _coutryTabController;

  TabController _tabController;
  double position = 0.0;
  double sensitivityFactor = 20.0;
  List<Category> _categories;
  List<SortedByCountry> _sortedByCountrt;
  int favLength;
  @override
  void initState() {
    favLength = Db.getFavouriteChannels().length;
    bool _isFirsTime = Db.getfirtTimeNotes();
    _categories = widget.categories;
    _sortedByCountrt = widget.sortedByCounty;
    _scrollViewController = new ScrollController(initialScrollOffset: 0.0);
    super.initState();
    if (_isFirsTime == true) {
      Db.setFirstTimeNotes(false);
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _devNotes(context);
      });
    }
    for (int index = 0; index < _categories.length; index++) {
      tabs.add(new Tab(
        child: Text(_categories[index].ar),
      ));
    }

    for (int index = 0; index < _sortedByCountrt.length; index++) {
      countryTabs.add(new Tab(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: CachedNetworkImage(
                imageUrl: _sortedByCountrt[index].img,
              ),
            ),
            Text(_sortedByCountrt[index].ar)
          ],
        ),
        // text: _categories[index].ar,
      ));
    }
    _tabController = new TabController(
        vsync: this,
        length: _categories.length,
        initialIndex: favLength == 0 ? 1 : 0);
    _coutryTabController = new TabController(
        vsync: this,
        length: _sortedByCountrt.length,
        initialIndex: favLength == 0 ? 1 : 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _coutryTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SortBy sortBy = Db.getSettings().sortBy;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: AppBar(),
      ),
      body: NotificationListener<ScrollUpdateNotification>(
        onNotification: (ScrollNotification notification) {
          setState(() {
            if (notification.metrics.pixels - position >= sensitivityFactor &&
                notification.metrics.axis == Axis.vertical) {
              print('Axis Scroll Direction : Up');
              position = notification.metrics.pixels;
              _isUpBottomVisible = true;
            }
            if (position - notification.metrics.pixels >= sensitivityFactor &&
                notification.metrics.axis == Axis.vertical) {
              print('Axis Scroll Direction : Down');
              _isUpBottomVisible = false;
              position = notification.metrics.pixels;
            }
          });
        },
        child: NestedScrollView(
          controller: _scrollViewController,
          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(child: BetterVideo()),
              SliverToBoxAdapter(
                child: TitleServers(),
              ),
              SliverToBoxAdapter(
                  child: Divider(
                thickness: 2,
                color: AppThemeData.AppYellow,
              )),
              SliverToBoxAdapter(
                  child: sortBy == SortBy.category
                      ? _tabBarBuilder()
                      : _countryTabBarBuilder()),
              SliverToBoxAdapter(
                  child: Divider(
                thickness: 2,
                color: AppThemeData.AppYellow,
              )),
            ];
          },
          body: TabBarView(
              controller: sortBy == SortBy.category
                  ? _tabController
                  : _coutryTabController,
              children: sortBy == SortBy.category
                  ? _categories.map((Category category) {
                      return new Container(
                        child: _buildBody(category.en),
                      );
                    }).toList()
                  : _sortedByCountrt.map((SortedByCountry country) {
                      return new Container(
                        child: _countrybuildBody(country.countryCode),
                      );
                    }).toList()),
        ),
      ),
      floatingActionButton: _isUpBottomVisible
          ? FloatingActionButton(
              backgroundColor: AppThemeData.AppYellow,
              child: Icon(Icons.arrow_upward),
              onPressed: () {
                _scrollViewController.animateTo(
                    _scrollViewController.position.minScrollExtent,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn);
              },
            )
          : null,
    );
  }

  Future<void> _devNotes(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ملاحظات المطور'),
          content: SingleChildScrollView(
            child: FutureBuilder(
              future: Notes.fetchNotes(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data != null) {
                  List<Note> notes = snapshot.data.notes;
                  List<Widget> widgets = [];
                  TextStyle ts = TextStyle(fontSize: 16, color: Colors.black);
                  for (var i = 0; i < notes.length; i++) {
                    widgets.add(Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              notes[i].text,
                              style: ts,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        )
                      ],
                    ));
                    widgets.add(SizedBox(
                      height: 10,
                    ));
                  }
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: widgets,
                    ),
                  );
                } else {
                  return Center(
                    child: Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          backgroundColor: AppThemeData.AppYellow,
                        )),
                  );
                }
              },
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('اوك'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget showDevNotes() {
    return AlertDialog(
      title: Text('ملاحظات المطور'),
      content: SingleChildScrollView(
        child: FutureBuilder(
          future: Notes.fetchNotes(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null) {
              List<Note> notes = snapshot.data.notes;
              List<Widget> widgets = [];
              TextStyle ts = TextStyle(fontSize: 16, color: Colors.black);
              for (var i = 0; i < notes.length; i++) {
                widgets.add(Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          notes[i].text,
                          style: ts,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    )
                  ],
                ));
                widgets.add(SizedBox(
                  height: 10,
                ));
              }
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: widgets,
                ),
              );
            } else {
              return Center(
                child: Container(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      backgroundColor: AppThemeData.AppYellow,
                    )),
              );
            }
          },
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('اوك'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _tabBarBuilder() {
    return TabBar(
      tabs: tabs,
      controller: _tabController,
      isScrollable: true,
      unselectedLabelColor: AppThemeData.AppGray,
      labelColor: AppThemeData.AppYellow,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: new BubbleTabIndicator(
        indicatorHeight: 35.0,
        indicatorColor: AppThemeData.PrimaryColor,
        tabBarIndicatorSize: TabBarIndicatorSize.tab,
      ),
    );
  }

  Widget _countryTabBarBuilder() {
    return TabBar(
      tabs: countryTabs,
      controller: _coutryTabController,
      isScrollable: true,
      unselectedLabelColor: AppThemeData.AppGray,
      labelColor: AppThemeData.AppYellow,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: new BubbleTabIndicator(
        indicatorHeight: 35.0,
        indicatorColor: AppThemeData.PrimaryColor,
        tabBarIndicatorSize: TabBarIndicatorSize.tab,
      ),
    );
  }

  Widget _countrybuildBody(String category) {
    print(category);
    if (category == "Favourite") {
      List<Channel> list = Db.getFavouriteChannels();
      return tileBuilder(list);
    } else {
      List<Channel> theCategory = [];

      for (var i in widget.cache) {
        if (category != null &&
            category.toLowerCase() == i.countryCode.toString().toLowerCase()) {
          theCategory.add(i);
        }
      }
      return tileBuilder(theCategory);
    }
  }

  Widget _buildBody(String category) {
    if (category == "Favourite") {
      List<Channel> list = Db.getFavouriteChannels();
      return tileBuilder(list);
    } else {
      List<Channel> theCategory = [];

      for (var i in widget.cache) {
        if (category.toLowerCase() == i.categories.toString().toLowerCase()) {
          theCategory.add(i);
        }
      }
      return tileBuilder(theCategory);
    }
  }

  Widget tileBuilder(List<Channel> theCategory) {
    return ListView.builder(
      itemCount: theCategory.length,
      itemBuilder: (BuildContext context, int index) {
        bool isFav = Db.isInFavourite(theCategory[index]);
        return ListTile(
          trailing: IconButton(
            icon: Icon(
              Icons.favorite,
              color: isFav ? AppThemeData.AppYellow : AppThemeData.AppGray,
            ),
            onPressed: () {
              setState(() {
                if (isFav == true) {
                  isFav = false;
                  Db.deleteFormFavourite(theCategory[index]);
                } else {
                  isFav = true;
                  Db.putToFavourite(theCategory[index]);
                }
              });
            },
          ),
          onTap: () {
            setState(() {
              _isUpBottomVisible = false;
            });
            BlocProvider.of<VideoBloc>(context).add(Click(
              channel: theCategory[index],
            ));
            _scrollViewController.animateTo(
                _scrollViewController.position.minScrollExtent,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn);
          },
          leading: CachedNetworkImage(
            imageUrl: theCategory[index].logo,
            imageBuilder: (context, imageProvider) => Container(
                child: CircleAvatar(
              backgroundImage: imageProvider,
              backgroundColor: AppThemeData.PrimaryColor,
            )),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => CircleAvatar(
              child: Icon(
                Icons.broken_image,
                color: AppThemeData.AppGray,
              ),
              backgroundColor: Colors.white,
            ),
          ),
          title: Text(
            theCategory[index].title,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
}
