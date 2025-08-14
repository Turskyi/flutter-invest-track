// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'created_investment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatedInvestmentResponse _$CreatedInvestmentResponseFromJson(
  Map<String, dynamic> json,
) => CreatedInvestmentResponse(
  investment: InvestmentResponse.fromJson(
    json['investment'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$CreatedInvestmentResponseToJson(
  CreatedInvestmentResponse instance,
) => <String, dynamic>{'investment': instance.investment};
