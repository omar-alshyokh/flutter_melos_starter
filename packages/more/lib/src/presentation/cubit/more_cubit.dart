import 'package:flutter_bloc/flutter_bloc.dart';
import 'more_state.dart';

class MoreCubit extends Cubit<MoreState> {
  MoreCubit() : super(MoreState.initial());

  void toggleTheme() => emit(state.copyWith(isDarkMode: !state.isDarkMode));

  void setLanguage(String code) => emit(state.copyWith(languageCode: code));
}
