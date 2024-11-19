// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rate_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeRateResponse _$ExchangeRateResponseFromJson(
        Map<String, dynamic> json) =>
    ExchangeRateResponse(
      provider: json['provider'] as String?,
      warningUpgradeToV6: json['WARNING_UPGRADE_TO_V6'] as String?,
      terms: json['terms'] as String?,
      base: json['base'] as String?,
      date: json['date'] as String?,
      timeLastUpdated: (json['time_last_updated'] as num?)?.toInt(),
      rates: json['rates'] == null
          ? null
          : RatesResponse.fromJson(json['rates'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExchangeRateResponseToJson(
        ExchangeRateResponse instance) =>
    <String, dynamic>{
      'provider': instance.provider,
      'WARNING_UPGRADE_TO_V6': instance.warningUpgradeToV6,
      'terms': instance.terms,
      'base': instance.base,
      'date': instance.date,
      'time_last_updated': instance.timeLastUpdated,
      'rates': instance.rates,
    };