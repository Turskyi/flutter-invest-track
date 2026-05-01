part of 'theme_bloc.dart';

final class ThemeState extends Equatable {
  const ThemeState(this.theme);

  final AppTheme theme;

  @override
  List<Object?> get props => <Object?>[theme];
}
