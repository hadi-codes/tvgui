part of 'channels_bloc.dart';

abstract class ChannelsEvent extends Equatable {
  const ChannelsEvent();
}

class FetchChannels extends ChannelsEvent {
  @override
  List<Object> get props => [];
}
