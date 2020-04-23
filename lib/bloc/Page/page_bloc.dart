import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tvgui/model/channel/channel.dart';


part 'page_event.dart';
part 'page_state.dart';

class PageBloc extends Bloc<PageEvent, int> {
  @override
  int get initialState => 1;

  @override
  Stream<int> mapEventToState(PageEvent event) async* {
    if (event is ChangePage) {
      yield event.page;
    }
  }
}
