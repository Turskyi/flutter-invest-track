import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'investment.g.dart';

@JsonSerializable()
class Investment {
  const Investment({
    required this.ticker,
    required this.userId,
    required this.currency,
    required this.type,
    required this.companyLogoUrl,
    required this.stockExchange,
    required this.description,
    required this.quantity,
    required this.purchaseDate,
    required this.companyName,
    this.slug,
    this.id = 0,
    this.totalValueOnPurchase,
    bool? isPurchased,
    this.purchasePrice,
    this.totalCurrentValue,
    this.gainOrLossCad,
    this.gainOrLossUsd,
    this.createdAt,
    this.updatedAt,
    this.currentPrice,
    // Initialize based on quantity.
  }) : isPurchased = isPurchased ?? quantity > 0;

  const Investment.base({
    required this.ticker,
    required this.companyName,
    required this.currency,
    required this.type,
    required this.stockExchange,
    required this.description,
    required this.quantity,
    required this.companyLogoUrl,
    required this.purchaseDate,
  })  : id = 0,
        slug = '',
        isPurchased = quantity > 0,
        totalValueOnPurchase = null,
        purchasePrice = null,
        totalCurrentValue = null,
        gainOrLossCad = null,
        gainOrLossUsd = null,
        createdAt = null,
        updatedAt = null,
        currentPrice = null,
        userId = '';

  const Investment.create({
    required this.ticker,
    required this.companyName,
    required this.currency,
    required this.type,
    required this.stockExchange,
    required this.description,
    required this.quantity,
    required this.companyLogoUrl,
    required this.purchaseDate,
    required this.userId,
    required this.currentPrice,
    required this.gainOrLossUsd,
    required this.totalValueOnPurchase,
    required this.totalCurrentValue,
    required this.purchasePrice,
    this.gainOrLossCad,
  })  : id = 0,
        slug = null,
        isPurchased = quantity > 0,
        createdAt = null,
        updatedAt = null;

  factory Investment.fromJson(Map<String, dynamic> json) =>
      _$InvestmentFromJson(json);

  @JsonKey(name: 'userId')
  final String userId;
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'slug')
  final String? slug;
  @JsonKey(name: 'ticker')
  final String ticker;
  @JsonKey(name: 'type')
  final String type;
  @JsonKey(name: 'stockExchange')
  final String stockExchange;
  @JsonKey(name: 'currency')
  final String currency;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'companyName')
  final String companyName;
  @JsonKey(name: 'quantity')
  final int quantity;
  @JsonKey(name: 'totalValueOnPurchase')
  final double? totalValueOnPurchase;
  @JsonKey(name: 'companyLogoUrl')
  final String companyLogoUrl;
  @JsonKey(name: 'purchaseDate')
  final DateTime? purchaseDate;
  @JsonKey(name: 'isPurchased')
  final bool isPurchased;

  /// The stock price at the time of purchase, in the investment's [currency].
  ///
  /// This value is **not** entered by the user. It is fetched automatically
  /// by the backend via a finance API (`fetchStockPrice(ticker, purchaseDate)`)
  /// using the [ticker] and [purchaseDate]. It may be `null` when the API
  /// returns no data for the given date (e.g. market was closed or the ticker
  /// was not yet listed).
  @JsonKey(name: 'purchasePrice')
  final double? purchasePrice;
  @JsonKey(name: 'totalCurrentValue')
  final double? totalCurrentValue;
  @JsonKey(name: 'gainOrLossCad')
  final double? gainOrLossCad;
  @JsonKey(name: 'gainOrLossUsd')
  final double? gainOrLossUsd;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;
  final double? currentPrice;

  Investment copyWith({
    String? userId,
    int? id,
    String? slug,
    String? ticker,
    String? type,
    String? stockExchange,
    String? currency,
    String? description,
    String? companyName,
    int? quantity,
    double? totalValueOnPurchase,
    String? companyLogoUrl,
    bool? isPurchased,
    DateTime? purchaseDate,
    double? purchasePrice,
    double? totalCurrentValue,
    double? gainOrLossCad,
    double? gainOrLossUsd,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? currentPrice,
  }) =>
      Investment(
        userId: userId ?? this.userId,
        id: id ?? this.id,
        slug: slug ?? this.slug,
        ticker: ticker ?? this.ticker,
        type: type ?? this.type,
        stockExchange: stockExchange ?? this.stockExchange,
        currency: currency ?? this.currency,
        description: description ?? this.description,
        companyName: companyName ?? this.companyName,
        quantity: quantity ?? this.quantity,
        totalValueOnPurchase: totalValueOnPurchase ?? this.totalValueOnPurchase,
        companyLogoUrl: companyLogoUrl ?? this.companyLogoUrl,
        isPurchased: isPurchased ?? this.isPurchased,
        purchaseDate: purchaseDate ?? this.purchaseDate,
        purchasePrice: purchasePrice ?? this.purchasePrice,
        totalCurrentValue: totalCurrentValue ?? this.totalCurrentValue,
        gainOrLossCad: gainOrLossCad ?? this.gainOrLossCad,
        gainOrLossUsd: gainOrLossUsd ?? this.gainOrLossUsd,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        currentPrice: currentPrice ?? this.currentPrice,
      );

  Map<String, dynamic> toJson() => _$InvestmentToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Investment) return false;
    final bool Function(Object? e1, Object? e2) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      userId.hashCode ^
      id.hashCode ^
      slug.hashCode ^
      ticker.hashCode ^
      type.hashCode ^
      stockExchange.hashCode ^
      currency.hashCode ^
      description.hashCode ^
      companyName.hashCode ^
      quantity.hashCode ^
      totalValueOnPurchase.hashCode ^
      companyLogoUrl.hashCode ^
      isPurchased.hashCode ^
      purchaseDate.hashCode ^
      purchasePrice.hashCode ^
      totalCurrentValue.hashCode ^
      gainOrLossCad.hashCode ^
      gainOrLossUsd.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() {
    return 'Investment{'
        'userId: $userId, '
        'id: $id, '
        'slug: $slug, '
        'ticker: $ticker, '
        'type: $type, '
        'stockExchange: $stockExchange, '
        'currency: $currency, '
        'description: $description, '
        'companyName: $companyName, '
        'quantity: $quantity, '
        'totalValueOnPurchase: $totalValueOnPurchase, '
        'companyLogoUrl: $companyLogoUrl, '
        'purchaseDate: $purchaseDate, '
        'isPurchased: $isPurchased, '
        'purchasePrice: $purchasePrice, '
        'totalCurrentValue: $totalCurrentValue, '
        'gainOrLossCad: $gainOrLossCad, '
        'gainOrLossUsd: $gainOrLossUsd, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt, '
        'currentPrice: $currentPrice,'
        '}';
  }
}
