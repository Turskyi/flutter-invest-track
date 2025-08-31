import 'package:collection/collection.dart';
import 'package:investtrack/infrastructure/ws/models/responses/investment_response/investment_response.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'updated_investment_response.g.dart';

@JsonSerializable()
class UpdatedInvestmentResponse implements InvestmentResult {
  factory UpdatedInvestmentResponse.fromJson(Map<String, dynamic> json) {
    return _$UpdatedInvestmentResponseFromJson(json);
  }

  const UpdatedInvestmentResponse({required this.investment});

  @override
  @JsonKey(name: 'updatedInvestment')
  final InvestmentResponse investment;

  @override
  String toString() =>
      'UpdatedInvestmentResponse('
      'updatedInvestment: $investment,'
      ')';

  Map<String, dynamic> toJson() => _$UpdatedInvestmentResponseToJson(this);

  UpdatedInvestmentResponse copyWith({InvestmentResponse? investment}) {
    return UpdatedInvestmentResponse(investment: investment ?? this.investment);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! UpdatedInvestmentResponse) return false;
    final bool Function(Object? e1, Object? e2) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => investment.hashCode;
}
