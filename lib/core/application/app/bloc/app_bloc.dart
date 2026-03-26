import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/core/application/app/bloc/app_state.dart';

class AppBloc extends Cubit<AppState> {
  AppBloc() : super(const AppState());

  void toggleTheme() {
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }

  void setDarkMode(bool value) {
    emit(state.copyWith(isDarkMode: value));
  }
}
