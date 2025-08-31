// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investments_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvestmentsResponse _$InvestmentsResponseFromJson(Map<String, dynamic> json) =>
    InvestmentsResponse(
      investments: (json['investments'] as List<dynamic>)
          .map((e) => InvestmentResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: (json['totalPages'] as num).toInt(),
      currentPage: (json['currentPage'] as num).toInt(),
    );

Map<String, dynamic> _$InvestmentsResponseToJson(
  InvestmentsResponse instance,
) => <String, dynamic>{
  'investments': instance.investments,
  'totalPages': instance.totalPages,
  'currentPage': instance.currentPage,
};
