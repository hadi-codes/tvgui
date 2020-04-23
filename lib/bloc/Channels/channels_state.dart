part of 'channels_bloc.dart';

abstract class ChannelsState extends Equatable {
  const ChannelsState();
  List<Object> get props => [];
}

class ChannelsInitial extends ChannelsState {
  @override
  List<Object> get props => [];
}

class Fetching extends ChannelsState {}

class Maintenance extends ChannelsState {}

class ForceUpdate extends ChannelsState {}

class Success extends ChannelsState {
  final List<Channel> list;
  final List<Category> category;
  final List<SortedByCountry> sortedByCoutry;
  const Success({@required this.list, this.category, this.sortedByCoutry})
      : assert(list != null);
  List<Object> get props => [list, category, sortedByCoutry];
}

class Error extends ChannelsState {}
