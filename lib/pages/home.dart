import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tvgui/channelspls/channel.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
// import 'package:auto_orientation/auto_orientation.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'bottomNavBar.dart';
import 'bottomNavBar.dart';
import 'setting.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
    this.title,
    //  this.cache,
  }) : super(key: key);

  final String title;
  //final List<Channel> cache;

  String url;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  PageController _pageController;
  Orientation get orientation => MediaQuery.of(context).orientation;
  IjkMediaController mediaController = IjkMediaController();
  int _currentIndex = 1;
  bool playInBackground ;
  List _categories = [
    // "Popular",
    "News",
    "Kids",
    "Sport",
    "Movies",
    "Music",
    "Classic",
    "Entertaniment",
    "Religion",
    "Documentaries",
    "Series"
  ];
  Widget topWidget;
  final List<Tab> tabs = <Tab>[];

  TabController _tabController;

  static const PrimaryColor = Color(0xff20232C);
  static const AppColorYellow = Color(0xfffbdd33);
  static const AppColorGray = Color(0xff74777f);

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getSettings();
    topWidget = pic();

    var option1 = IjkOption(IjkOptionCategory.format, "fflags", "fastseek");

    mediaController.setIjkPlayerOptions(
      [TargetPlatform.iOS, TargetPlatform.android],
      [option1].toSet(),
    );

    for (int index = 0; index < _categories.length; index++) {
      tabs.add(new Tab(
        text: _categories[index],
      ));
    }
    _tabController = new TabController(vsync: this, length: tabs.length);
    //BackButtonInterceptor.add(myInterceptor);
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    BuildVideoPlayer();
    // BackButtonInterceptor.remove(myInterceptor);
    mediaController?.dispose();

    _tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
    _pageController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print(state);
    if (state == AppLifecycleState.paused && playInBackground==false) {
      await mediaController.pause();
    } else if (state == AppLifecycleState.resumed) {
      mediaController.play();
    }
    print(playInBackground);
  }
  // bool myInterceptor(bool stopDefaultButtonEvent) {

  //   print("BACK BUTTON!"); // Do some stuff.
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Warning'),
          content: Text('Do you really want to exit'),
          actions: [
            FlatButton(
              child: Text('Yes'),
              onPressed: () => Navigator.pop(c, true),
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () => Navigator.pop(c, false),
            ),
          ],
        ),
      ),
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(10.0), // here the desired height
            child: AppBar(
                // ...
                )),
        body: Column(children: <Widget>[
          AspectRatio(
            aspectRatio: 1280 / 720,
            child: topWidget,
          ),
          Flexible(

              // this will host our Tab Views
              child: new Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: AppBar(
                elevation: 1.0,
                bottom: new TabBar(
                  isScrollable: true,
                  unselectedLabelColor: AppColorGray,
                  labelColor: AppColorYellow,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: new BubbleTabIndicator(
                    indicatorHeight: 35.0,
                    indicatorColor: PrimaryColor,
                    tabBarIndicatorSize: TabBarIndicatorSize.tab,
                  ),
                  tabs: tabs,
                  controller: _tabController,
                ),
              ),
            ),
            body: new TabBarView(
              controller: _tabController,
              children: tabs.map((Tab tab) {
                return new Container(child: _buildBody(tab.text));
              }).toList(),
            ),
          ))
        ]),
      ),
    );
  }

  Widget pic() {
    return Container(height: 200, child: Image.asset('assets/img/logo.png'));
  }

  getSettings() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      playInBackground = (sharedPrefs.getBool('playInBackground') ?? false);
    });
  }

  Widget BuildVideoPlayer() {
    return Container(
      height: 200,
      child: IjkPlayer(
        mediaController: mediaController,
        controllerWidgetBuilder: (mediaController) {
          return DefaultIJKControllerWidget(
            horizontalGesture: false,
            verticalGesture: false,
            hideSystemBarOnFullScreen: true,
            controller: mediaController,
            doubleTapPlay: true,
            onFullScreen: (bool onFull) {
              if (onFull) {
              } else {
                // AutoOrientation.portraitUpMode();
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildBody(String category) {
    final channelsBox = Hive.box('channels');

    List<Channel> channels = [];

    channelsBox.get(Channel);

    for (var i = 0; i < channelsBox.length; i++) {
      final channel = channelsBox.get(i) as Channel;
      if (category.toLowerCase() ==
          channel.categories.toString().toLowerCase()) {
        // print(channel.categories);
        channels.add(channel);
      }
    }

    return ListView.builder(
      itemCount: channels.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            setState(() {
              topWidget = BuildVideoPlayer();
              mediaController.setNetworkDataSource(channels[index].urls,
                  autoPlay: true);
            });
          },
          leading: CachedNetworkImage(
            imageUrl: channels[index].logo,
            imageBuilder: (context, imageProvider) => Container(
                child: CircleAvatar(
              backgroundImage: imageProvider,
              backgroundColor: PrimaryColor,
            )),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.broken_image),
          ),
          title: Text(
            channels[index].title,
            style: TextStyle(color: Colors.white),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: AppColorYellow,
                ),
                onPressed: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}
