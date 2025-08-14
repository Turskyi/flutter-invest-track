import 'package:collection/collection.dart';
import 'package:investtrack/infrastructure/ws/models/responses/investment_response/investment_response.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'created_investment_response.g.dart';

@JsonSerializable()
class CreatedInvestmentResponse implements InvestmentResult {
  factory CreatedInvestmentResponse.fromJson(Map<String, dynamic> json) {
    return _$CreatedInvestmentResponseFromJson(json);
  }

  const CreatedInvestmentResponse({required this.investment});

  @override
  @JsonKey(name: 'investment')
  final InvestmentResponse investment;

  @override
  String toString() => 'InvestmentResult(investment: $investment)';

  Map<String, dynamic> toJson() => _$CreatedInvestmentResponseToJson(this);

  CreatedInvestmentResponse copyWith({InvestmentResponse? investment}) {
    return CreatedInvestmentResponse(investment: investment ?? this.investment);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! CreatedInvestmentResponse) return false;
    final bool Function(Object? e1, Object? e2) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => investment.hashCode;
}
