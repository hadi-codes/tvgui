import 'package:cached_network_image/cached_network_image.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvgui/bloc/video/video_bloc.dart';
import 'package:tvgui/model/channel/channel.dart';

import '../model/theme.dart';

class TitleServers extends StatefulWidget {
  const TitleServers({Key key}) : super(key: key);

  @override
  _TitleServersState createState() => _TitleServersState();
}

class _TitleServersState extends State<TitleServers> {
  ScrollController _controller;
  Channel channel;
  @override
  Widget build(BuildContext context) {
    return new BlocBuilder<VideoBloc, VideoState>(
      builder: (context, state) {
        if (state is VideoInitial) {
          return Container(
            width: 0,
            height: 0,
          );
        }

        if (state is PlayVideo) {
          channel = state.channel;
          return titleServers(channel);
        }
        if (state is ChangeServers) {
          return titleServers(channel);
        } else {
          return Container(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  void initState() {
    _controller = new ScrollController(initialScrollOffset: 0.0);

    super.initState();
  }

  Widget titleServers(Channel channel) {
    return new Container(
      decoration: new BoxDecoration(
        color: AppThemeData.AppYellow,
      ),
      child: ExpansionTile(
        title: Row(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: channel.logo,
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
            SizedBox(
              width: 10,
            ),
            Text(channel.title),
          ],
        ),
        trailing: Flags.getMiniFlag(channel.countryCode.toUpperCase(), 20, 20),
        children: <Widget>[
          SingleChildScrollView(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: serversWidgets(channel.urls),
            ),
          )
        ],
      ),
    );
  }

  serversWidgets(List<Url> urls) {
    List<Widget> list = [];

    for (int i = 0; i < urls.length; i++) {
      list.add(SizedBox(
        width: 5,
      ));
      list.add(SizedBox(
        width: 90,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
          ),
          child: Text(
            'sever ${i + 1}',
          ),
          color: (urls[i].isOk) ? Colors.lightBlue : AppThemeData.Red,
          onPressed: () {
            BlocProvider.of<VideoBloc>(context)
                .add(ChangeServer(url: urls[i].url));
          },
        ),
      ));
      list.add(SizedBox(
        width: 5,
      ));
    }
    return list;
  }
}
