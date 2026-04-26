import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:investtrack/domain_services/settings_repository.dart';
import 'package:models/models.dart';

part 'theme_event.dart';
part 'theme_state.dart';

@injectable
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(this._settingsRepository)
    : super(ThemeState(_settingsRepository.getAppTheme())) {
    on<ThemeChanged>(_onThemeChanged);
  }

  final SettingsRepository _settingsRepository;

  FutureOr<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    await _settingsRepository.saveAppTheme(event.theme);
    emit(ThemeState(event.theme));
  }
}
