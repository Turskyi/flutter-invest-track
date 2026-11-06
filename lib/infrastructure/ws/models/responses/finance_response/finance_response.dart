import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'finance_response.g.dart';

@JsonSerializable()
class FinanceResponse implements FinanceResult {
  const FinanceResponse({required this.currentPrice});

  factory FinanceResponse.fromJson(Map<String, Object?> json) {
    return _$FinanceResponseFromJson(json);
  }

  @override
  @JsonKey(name: 'currentPrice')
  final double currentPrice;

  Map<String, Object?> toJson() => _$FinanceResponseToJson(this);
}
