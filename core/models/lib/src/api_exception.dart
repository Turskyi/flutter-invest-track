import 'package:equatable/equatable.dart';

import 'abstract/register_response.dart';

class ApiException extends Equatable implements Exception {
  const ApiException({required this.errorCode, required this.response});

  final int errorCode;
  final RegisterResponse response;

  @override
  List<Object?> get props => <Object?>[errorCode, response];

  @override
  String toString() => response.toString();
}
