part of 'page_bloc.dart';

@immutable
abstract class PageState extends Equatable {
  const PageState();
  List<Object> get props => [];
}

class PageInitial extends PageState {}

class SetPage extends PageState {
  final int page;
  const SetPage({@required this.page}) : assert(page != null);

  @override
  List<Object> get props => [page];
}
