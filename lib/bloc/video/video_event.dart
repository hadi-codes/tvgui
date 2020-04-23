part of 'video_bloc.dart';

abstract class VideoEvent extends Equatable {
  const VideoEvent();
}

class Click extends VideoEvent {
  final Channel channel;

  @override
  const Click({@required this.channel}) : assert(channel != null);

  @override
  List<Object> get props => [channel];
}

class ChangeServer extends VideoEvent {
  final String url;
  @override
  const ChangeServer({@required this.url}) : assert(url != null);

  @override
  List<Object> get props => [url];
}
