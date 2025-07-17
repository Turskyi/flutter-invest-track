import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({required this.id, required this.email});

  final String id;
  final String email;

  @override
  List<Object> get props => <Object>[id];

  static const User anonymous = User(id: '', email: '');

  bool get isAnonymous => this == anonymous || id.isEmpty;

  bool get isNotAnonymous => this != anonymous && id.isNotEmpty;
}
