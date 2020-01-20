import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class VideoPlayer extends StatefulWidget {
  @override
  VideoPlayer({this.url});

  final String url;
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  IjkMediaController controller = IjkMediaController();
  final key = GlobalKey<DefaultIJKControllerWidgetState>();

  @override
  void initState() {
    super.initState();
    setDataSource();
  }

  void setDataSource() async {
    await controller.setNetworkDataSource(
      widget.url,
      autoPlay: true,
    );
    key.currentState.fullScreen();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AspectRatio(
        aspectRatio: 1280 / 720,
        child: IjkPlayer(
          mediaController: controller,
          controllerWidgetBuilder: (ctl) => DefaultIJKControllerWidget(
            controller: ctl,
            key: key,
            horizontalGesture: false,
            verticalGesture: false,
            hideSystemBarOnFullScreen: true,
            doubleTapPlay: true,
          ),
        ),
      ),
    );
  }
}
