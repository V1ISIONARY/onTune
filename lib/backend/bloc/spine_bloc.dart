import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'spine_event.dart';
part 'spine_state.dart';

class SpineBloc extends Bloc<SpineEvent, SpineState> {
  SpineBloc() : super(SpineInitial()) {
    on<SpineEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
