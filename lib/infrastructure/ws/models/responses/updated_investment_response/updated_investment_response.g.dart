// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updated_investment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatedInvestmentResponse _$UpdatedInvestmentResponseFromJson(
  Map<String, dynamic> json,
) => UpdatedInvestmentResponse(
  investment: InvestmentResponse.fromJson(
    json['updatedInvestment'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$UpdatedInvestmentResponseToJson(
  UpdatedInvestmentResponse instance,
) => <String, dynamic>{'updatedInvestment': instance.investment};
