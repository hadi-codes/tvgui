import 'dart:convert';

import 'package:algolia/algolia.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvgui/bloc/Page/page_bloc.dart';
import 'package:tvgui/bloc/video/video_bloc.dart';
import 'package:tvgui/db/db.dart';
import 'package:tvgui/model/channel/channel.dart';
import 'package:tvgui/model/config.dart';
import 'package:tvgui/model/theme.dart';

import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  SearchPage({
    Key key,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class Application {
  static final Algolia algolia = Algolia.init(
    applicationId: Db.getConfig().searchApp,
    apiKey: Db.getConfig().searchToken,
  );
}

class _SearchPageState extends State<SearchPage> {
  Algolia algolia = Application.algolia;
  Config config;
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio();
  String _searchText = "";
  List<Channel> channels = new List<Channel>();
  List<Channel> filteredChannels = new List<Channel>();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('بحث');
  _SearchPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredChannels = channels;
        });
      } else {
        setState(() {
          //
          _searchText = _filter.text;
          print(_searchText);
          _getChannels();
        });
      }
    });
  }
  @override
  void initState() {
    config = Db.getConfig();
    this._getChannels();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List tempList = new List<Channel>();
      for (int i = 0; i < filteredChannels.length; i++) {
        tempList.add(filteredChannels[i]);
      }
      filteredChannels = tempList;
    }
    return ListView.builder(
      itemCount: channels.length,
      itemBuilder: (BuildContext context, int index) {
        bool isFav = Db.isInFavourite(channels[index]);

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
                  Db.deleteFormFavourite(channels[index]);
                } else {
                  isFav = true;
                  Db.putToFavourite(channels[index]);
                }
              });
            },
          ),
          onTap: () {
            BlocProvider.of<VideoBloc>(context)
                .add(Click(channel: channels[index]));
            BlocProvider.of<PageBloc>(context)
                .add(ChangePage(page: 1, channel: channels[index]));
          },
          leading: CachedNetworkImage(
            imageUrl: channels[index].logo,
            imageBuilder: (context, imageProvider) => Container(
                child: CircleAvatar(
              backgroundImage: imageProvider,
              backgroundColor: AppThemeData.PrimaryColor,
            )),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => CircleAvatar(
              child: Icon(
                Icons.live_tv,
                color: AppThemeData.AppGray,
              ),
              backgroundColor: Colors.white,
            ),
          ),
          title: Text(
            channels[index].title,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          subtitle: Text(
            channels[index].enName,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        );
      },
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          style: TextStyle(color: Colors.white),
          controller: _filter,
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search, color: Colors.white),
            hintText: 'بحث...',
            hintStyle: TextStyle(color: AppThemeData.AppYellow),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppThemeData.AppYellow),
            ),
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search');
        filteredChannels = channels;
        _filter.clear();
      }
    });
  }

  void _getChannels() async {
    print("getting Channels");

    List<Channel> tempList = new List<Channel>();
    AlgoliaQuery query = algolia.instance.index('channels').search(_searchText);

    query = query.setHitsPerPage(10);
    AlgoliaQuerySnapshot snap = await query.getObjects();

    print('Hits count: ${snap.hits}');

    tempList =
        snap.hits.map<Channel>((doc) => Channel.fromAlgolia(doc)).toList();
    setState(() {
      channels = tempList;
      filteredChannels = channels;
    });
  }
}
