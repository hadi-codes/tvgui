part of 'video_bloc.dart';

abstract class VideoState extends Equatable {
  const VideoState();
  List<Object> get props => [];
}

class VideoInitial extends VideoState {
  @override
  List<Object> get props => [];
}

class Loading extends VideoState {}

class InintialVideo extends VideoState {
  List<Object> get props => [];
}

class PlayVideo extends VideoState {
  final Channel channel;
  final BetterPlayerController betterPlayerController;
  const PlayVideo({@required this.channel, this.betterPlayerController})
      : assert(channel != null);

  @override
  List<Object> get props => [channel, betterPlayerController];
}

class ChangeServers extends VideoState {
  final BetterPlayerController betterPlayerController;

  const ChangeServers({@required this.betterPlayerController})
      : assert(betterPlayerController != null);

  @override
  List<Object> get props => [betterPlayerController];
}





class DisposeVideo extends VideoState {}


class NoVideo extends VideoState {}

class ThereIsVideo extends VideoState {}
