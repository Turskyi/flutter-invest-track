part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => <Object?>[];
}

final class ThemeChanged extends ThemeEvent {
  const ThemeChanged(this.theme);

  final AppTheme theme;

  @override
  List<Object?> get props => <Object?>[theme];
}
