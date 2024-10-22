import 'package:flutter_bloc/flutter_bloc.dart';

class bnc extends Cubit<int> {
  bnc() : super(0); // Initial index

  void changeSelectedIndex(int index) {
    emit(index); // Update the state with the new index
  }
}
