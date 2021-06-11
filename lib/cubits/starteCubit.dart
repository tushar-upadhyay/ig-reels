import 'package:flutter_bloc/flutter_bloc.dart';

class StateCubit extends Cubit<dynamic> {
  StateCubit() : super(false);
  void updateState(state) => emit(state);
}
