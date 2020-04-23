part of 'page_bloc.dart';

abstract class PageEvent extends Equatable {
  const PageEvent();
}

class ChangePage extends PageEvent {
  final int page;
  final Channel channel;
  @override
  const ChangePage({@required this.page, this.channel}) : assert(page != null);

  @override
  List<Object> get props => [page, channel];
}
