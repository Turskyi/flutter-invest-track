// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$InvestmentRequestToJson(InvestmentRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'id': instance.id,
      'slug': instance.slug,
      'ticker': instance.ticker,
      'type': instance.type,
      'stockExchange': instance.stockExchange,
      'currency': instance.currency,
      'description': instance.description,
      'companyName': instance.companyName,
      'quantity': instance.quantity,
      'totalValueOnPurchase': instance.totalValueOnPurchase,
      'companyLogoUrl': instance.companyLogoUrl,
      'purchaseDate': instance.purchaseDate?.toIso8601String(),
      'isPurchased': instance.isPurchased,
      'purchasePrice': instance.purchasePrice,
      'totalCurrentValue': instance.totalCurrentValue,
      'gainOrLossCad': instance.gainOrLossCad,
      'gainOrLossUsd': instance.gainOrLossUsd,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'currentPrice': instance.currentPrice,
    };
