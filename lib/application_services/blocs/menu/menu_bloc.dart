import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/domain_services/settings_repository.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:models/models.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc(
    this._settingsRepository,
  ) : super(const LoadingMenuState()) {
    on<LoadingInitialMenuStateEvent>(
      (_, Emitter<MenuState> emit) {
        final Language savedLanguage = _settingsRepository.getLanguage();
        emit(MenuInitial(language: savedLanguage));
      },
    );
    on<BugReportPressedEvent>(_onFeedbackRequested);
    on<ClosingFeedbackEvent>(_onFeedbackDialogDismissed);
    on<SubmitFeedbackEvent>(_sendUserFeedback);
  }

  final SettingsRepository _settingsRepository;

  FutureOr<void> _onFeedbackRequested(
    BugReportPressedEvent _,
    Emitter<MenuState> emit,
  ) {
    emit(FeedbackState(language: state.language));
  }

  FutureOr<void> _onFeedbackDialogDismissed(
    ClosingFeedbackEvent _,
    Emitter<MenuState> emit,
  ) {
    emit(MenuInitial(language: state.language));
  }

  FutureOr<void> _sendUserFeedback(
    SubmitFeedbackEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(
      LoadingMenuState(language: state.language),
    );
    final UserFeedback feedback = event.feedback;
    try {
      final String screenshotFilePath = await _writeImageToStorage(
        feedback.screenshot,
      );

      final PackageInfo packageInfo = await PackageInfo.fromPlatform();

      final Map<String, dynamic>? extra = feedback.extra;
      final dynamic rating = extra?['rating'];
      final dynamic type = extra?['feedback_type'];

      // Construct the feedback text with details from `extra'.
      final StringBuffer feedbackBody = StringBuffer()
        ..writeln('${type is FeedbackType ? translate('feedback.type') : ''}:'
            ' ${type is FeedbackType ? type.value : ''}')
        ..writeln()
        ..writeln(feedback.text)
        ..writeln()
        ..writeln('${translate('appId')}: ${packageInfo.packageName}')
        ..writeln('${translate('appVersion')}: ${packageInfo.version}')
        ..writeln('${translate('buildNumber')}: ${packageInfo.buildNumber}')
        ..writeln()
        ..writeln(
            '${rating is FeedbackRating ? translate('feedback.rating') : ''}'
            '${rating is FeedbackRating ? ':' : ''}'
            ' ${rating is FeedbackRating ? rating.value : ''}');

      final Email email = Email(
        body: feedbackBody.toString(),
        subject: '${translate('feedback.appFeedback')}: '
            '${packageInfo.appName}',
        recipients: <String>[constants.supportEmail],
        attachmentPaths: <String>[screenshotFilePath],
      );
      try {
        await FlutterEmailSender.send(email);
      } catch (error, stackTrace) {
        debugPrint(
          'Error in $runtimeType in `onError`: $error.\n'
          'Stacktrace: $stackTrace',
        );
        add(ErrorEvent(translate('error.unexpectedError')));
      }
    } catch (error, stackTrace) {
      debugPrint(
        'Error in $runtimeType in `onError`: $error.\n'
        'Stacktrace: $stackTrace',
      );
      add(ErrorEvent(translate('error.unexpectedError')));
    }
    emit(
      MenuInitial(language: state.language),
    );
  }

  Future<String> _writeImageToStorage(Uint8List feedbackScreenshot) async {
    final Directory output = await getTemporaryDirectory();
    final String screenshotFilePath = '${output.path}/feedback.png';
    final File screenshotFile = File(screenshotFilePath);
    await screenshotFile.writeAsBytes(feedbackScreenshot);
    return screenshotFilePath;
  }
}
