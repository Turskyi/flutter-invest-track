import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:investtrack/application_services/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:investtrack/domain_services/investments_repository.dart';
import 'package:investtrack/domain_services/settings_repository.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:investtrack/services/home_widget_service.dart';
import 'package:models/models.dart';

part 'theme_event.dart';
part 'theme_state.dart';

@injectable
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(
    this._settingsRepository,
    this._homeWidgetService,
    this._investmentsRepository,
    this._authenticationBloc,
  ) : super(ThemeState(_settingsRepository.getAppTheme())) {
    on<ThemeChanged>(_onThemeChanged);
  }

  final SettingsRepository _settingsRepository;
  final HomeWidgetService _homeWidgetService;
  final InvestmentsRepository _investmentsRepository;
  final AuthenticationBloc _authenticationBloc;

  FutureOr<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    await _settingsRepository.saveAppTheme(event.theme);
    emit(ThemeState(event.theme));

    final String rawUserId = _authenticationBloc.state.userId;
    final String userId = rawUserId.isNotEmpty
        ? rawUserId
        : constants.demoUserId;

    await _homeWidgetService.updateHomeWidget(
      appDatabase: _investmentsRepository.appDatabase,
      userId: userId,
      appTheme: event.theme,
      settingsRepository: _settingsRepository,
    );
  }
}
