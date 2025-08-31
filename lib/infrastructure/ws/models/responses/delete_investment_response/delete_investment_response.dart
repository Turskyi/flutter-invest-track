import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'delete_investment_response.g.dart';

@JsonSerializable()
class DeleteInvestmentResponse implements MessageResponse {
  const DeleteInvestmentResponse({required this.message});

  factory DeleteInvestmentResponse.fromJson(Map<String, dynamic> json) {
    return _$DeleteInvestmentResponseFromJson(json);
  }

  @override
  @JsonKey(name: 'message')
  final String message;

  @override
  String toString() => 'DeleteInvestmentResponse(message: $message)';

  Map<String, dynamic> toJson() => _$DeleteInvestmentResponseToJson(this);

  DeleteInvestmentResponse copyWith({String? message}) =>
      DeleteInvestmentResponse(message: message ?? this.message);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! DeleteInvestmentResponse) return false;
    final bool Function(Object? e1, Object? e2) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => message.hashCode;
}
