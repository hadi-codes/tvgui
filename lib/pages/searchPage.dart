import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tvgui/channelspls/channel.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:tvgui/model/theme.dart';
import 'package:tvgui/pages/videoPlayer.dart';

import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  SearchPage({
    Key key,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // final formKey = new GlobalKey<FormState>();
  // final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio(); // for http requests
  String _searchText = "";
  List<Channel> channels = new List<Channel>(); // names we get from API
  List<Channel> filteredChannels =
      new List<Channel>(); // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search');
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
    return new AppBar(
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
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VideoPlayer(
                        url: channels[index].urls[0].url,
                      )),
            );
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
                Icons.broken_image,
                color: AppThemeData.AppGray,
              ),
              backgroundColor: Colors.white,
            ),
          ),
          title: Text(
            channels[index].title,
            style: TextStyle(color: Colors.white),
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
            hintText: 'Search...',
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
    // final response = await dio
    //     .post('https://api.hadi.wtf/search', data: {"name": _searchText});
    List<Channel> tempList = new List<Channel>();

    tempList = await fetchChannels(http.Client(), _searchText);
    setState(() {
      channels = tempList;
      filteredChannels = channels;
    });
  }
}

Future<List<Channel>> fetchChannels(
    http.Client client, String searchText) async {
  final response = await client
      .post('https://api.hadi.wtf/search', body: {"name": searchText});

  return compute(parseChannels, response.body);
}

List<Channel> parseChannels(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Channel>((json) => Channel.fromJson(json)).toList();
}
