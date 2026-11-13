// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $InvestmentsTableTable extends InvestmentsTable
    with TableInfo<$InvestmentsTableTable, InvestmentEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvestmentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tickerMeta = const VerificationMeta('ticker');
  @override
  late final GeneratedColumn<String> ticker = GeneratedColumn<String>(
    'ticker',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _companyNameMeta = const VerificationMeta(
    'companyName',
  );
  @override
  late final GeneratedColumn<String> companyName = GeneratedColumn<String>(
    'company_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stockExchangeMeta = const VerificationMeta(
    'stockExchange',
  );
  @override
  late final GeneratedColumn<String> stockExchange = GeneratedColumn<String>(
    'stock_exchange',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalValueOnPurchaseMeta =
      const VerificationMeta('totalValueOnPurchase');
  @override
  late final GeneratedColumn<double> totalValueOnPurchase =
      GeneratedColumn<double>(
        'total_value_on_purchase',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _companyLogoUrlMeta = const VerificationMeta(
    'companyLogoUrl',
  );
  @override
  late final GeneratedColumn<String> companyLogoUrl = GeneratedColumn<String>(
    'company_logo_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchaseDateMeta = const VerificationMeta(
    'purchaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
    'purchase_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPurchasedMeta = const VerificationMeta(
    'isPurchased',
  );
  @override
  late final GeneratedColumn<bool> isPurchased = GeneratedColumn<bool>(
    'is_purchased',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_purchased" IN (0, 1))',
    ),
    defaultValue: const Constant<bool>(true),
  );
  static const VerificationMeta _purchasePriceMeta = const VerificationMeta(
    'purchasePrice',
  );
  @override
  late final GeneratedColumn<double> purchasePrice = GeneratedColumn<double>(
    'purchase_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalCurrentValueMeta = const VerificationMeta(
    'totalCurrentValue',
  );
  @override
  late final GeneratedColumn<double> totalCurrentValue =
      GeneratedColumn<double>(
        'total_current_value',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _gainOrLossCadMeta = const VerificationMeta(
    'gainOrLossCad',
  );
  @override
  late final GeneratedColumn<double> gainOrLossCad = GeneratedColumn<double>(
    'gain_or_loss_cad',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gainOrLossUsdMeta = const VerificationMeta(
    'gainOrLossUsd',
  );
  @override
  late final GeneratedColumn<double> gainOrLossUsd = GeneratedColumn<double>(
    'gain_or_loss_usd',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentPriceMeta = const VerificationMeta(
    'currentPrice',
  );
  @override
  late final GeneratedColumn<double> currentPrice = GeneratedColumn<double>(
    'current_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    ticker,
    companyName,
    currency,
    type,
    stockExchange,
    description,
    quantity,
    totalValueOnPurchase,
    companyLogoUrl,
    purchaseDate,
    isPurchased,
    purchasePrice,
    totalCurrentValue,
    gainOrLossCad,
    gainOrLossUsd,
    createdAt,
    updatedAt,
    currentPrice,
    slug,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'investments_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<InvestmentEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('ticker')) {
      context.handle(
        _tickerMeta,
        ticker.isAcceptableOrUnknown(data['ticker']!, _tickerMeta),
      );
    } else if (isInserting) {
      context.missing(_tickerMeta);
    }
    if (data.containsKey('company_name')) {
      context.handle(
        _companyNameMeta,
        companyName.isAcceptableOrUnknown(
          data['company_name']!,
          _companyNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_companyNameMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('stock_exchange')) {
      context.handle(
        _stockExchangeMeta,
        stockExchange.isAcceptableOrUnknown(
          data['stock_exchange']!,
          _stockExchangeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_stockExchangeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('total_value_on_purchase')) {
      context.handle(
        _totalValueOnPurchaseMeta,
        totalValueOnPurchase.isAcceptableOrUnknown(
          data['total_value_on_purchase']!,
          _totalValueOnPurchaseMeta,
        ),
      );
    }
    if (data.containsKey('company_logo_url')) {
      context.handle(
        _companyLogoUrlMeta,
        companyLogoUrl.isAcceptableOrUnknown(
          data['company_logo_url']!,
          _companyLogoUrlMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_companyLogoUrlMeta);
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    }
    if (data.containsKey('is_purchased')) {
      context.handle(
        _isPurchasedMeta,
        isPurchased.isAcceptableOrUnknown(
          data['is_purchased']!,
          _isPurchasedMeta,
        ),
      );
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
        _purchasePriceMeta,
        purchasePrice.isAcceptableOrUnknown(
          data['purchase_price']!,
          _purchasePriceMeta,
        ),
      );
    }
    if (data.containsKey('total_current_value')) {
      context.handle(
        _totalCurrentValueMeta,
        totalCurrentValue.isAcceptableOrUnknown(
          data['total_current_value']!,
          _totalCurrentValueMeta,
        ),
      );
    }
    if (data.containsKey('gain_or_loss_cad')) {
      context.handle(
        _gainOrLossCadMeta,
        gainOrLossCad.isAcceptableOrUnknown(
          data['gain_or_loss_cad']!,
          _gainOrLossCadMeta,
        ),
      );
    }
    if (data.containsKey('gain_or_loss_usd')) {
      context.handle(
        _gainOrLossUsdMeta,
        gainOrLossUsd.isAcceptableOrUnknown(
          data['gain_or_loss_usd']!,
          _gainOrLossUsdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('current_price')) {
      context.handle(
        _currentPriceMeta,
        currentPrice.isAcceptableOrUnknown(
          data['current_price']!,
          _currentPriceMeta,
        ),
      );
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, userId};
  @override
  InvestmentEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvestmentEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      ticker: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ticker'],
      )!,
      companyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_name'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      stockExchange: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stock_exchange'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      totalValueOnPurchase: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_value_on_purchase'],
      ),
      companyLogoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_logo_url'],
      )!,
      purchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchase_date'],
      ),
      isPurchased: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_purchased'],
      )!,
      purchasePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}purchase_price'],
      ),
      totalCurrentValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_current_value'],
      ),
      gainOrLossCad: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gain_or_loss_cad'],
      ),
      gainOrLossUsd: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gain_or_loss_usd'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      currentPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_price'],
      ),
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      ),
    );
  }

  @override
  $InvestmentsTableTable createAlias(String alias) {
    return $InvestmentsTableTable(attachedDatabase, alias);
  }
}

class InvestmentEntity extends DataClass
    implements Insertable<InvestmentEntity> {
  final int id;
  final String userId;
  final String ticker;
  final String companyName;
  final String currency;
  final String type;
  final String stockExchange;
  final String description;
  final int quantity;
  final double? totalValueOnPurchase;
  final String companyLogoUrl;
  final DateTime? purchaseDate;
  final bool isPurchased;
  final double? purchasePrice;
  final double? totalCurrentValue;
  final double? gainOrLossCad;
  final double? gainOrLossUsd;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double? currentPrice;
  final String? slug;
  const InvestmentEntity({
    required this.id,
    required this.userId,
    required this.ticker,
    required this.companyName,
    required this.currency,
    required this.type,
    required this.stockExchange,
    required this.description,
    required this.quantity,
    this.totalValueOnPurchase,
    required this.companyLogoUrl,
    this.purchaseDate,
    required this.isPurchased,
    this.purchasePrice,
    this.totalCurrentValue,
    this.gainOrLossCad,
    this.gainOrLossUsd,
    this.createdAt,
    this.updatedAt,
    this.currentPrice,
    this.slug,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['ticker'] = Variable<String>(ticker);
    map['company_name'] = Variable<String>(companyName);
    map['currency'] = Variable<String>(currency);
    map['type'] = Variable<String>(type);
    map['stock_exchange'] = Variable<String>(stockExchange);
    map['description'] = Variable<String>(description);
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || totalValueOnPurchase != null) {
      map['total_value_on_purchase'] = Variable<double>(totalValueOnPurchase);
    }
    map['company_logo_url'] = Variable<String>(companyLogoUrl);
    if (!nullToAbsent || purchaseDate != null) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate);
    }
    map['is_purchased'] = Variable<bool>(isPurchased);
    if (!nullToAbsent || purchasePrice != null) {
      map['purchase_price'] = Variable<double>(purchasePrice);
    }
    if (!nullToAbsent || totalCurrentValue != null) {
      map['total_current_value'] = Variable<double>(totalCurrentValue);
    }
    if (!nullToAbsent || gainOrLossCad != null) {
      map['gain_or_loss_cad'] = Variable<double>(gainOrLossCad);
    }
    if (!nullToAbsent || gainOrLossUsd != null) {
      map['gain_or_loss_usd'] = Variable<double>(gainOrLossUsd);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || currentPrice != null) {
      map['current_price'] = Variable<double>(currentPrice);
    }
    if (!nullToAbsent || slug != null) {
      map['slug'] = Variable<String>(slug);
    }
    return map;
  }

  InvestmentsTableCompanion toCompanion(bool nullToAbsent) {
    return InvestmentsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      ticker: Value(ticker),
      companyName: Value(companyName),
      currency: Value(currency),
      type: Value(type),
      stockExchange: Value(stockExchange),
      description: Value(description),
      quantity: Value(quantity),
      totalValueOnPurchase: totalValueOnPurchase == null && nullToAbsent
          ? const Value.absent()
          : Value(totalValueOnPurchase),
      companyLogoUrl: Value(companyLogoUrl),
      purchaseDate: purchaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseDate),
      isPurchased: Value(isPurchased),
      purchasePrice: purchasePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(purchasePrice),
      totalCurrentValue: totalCurrentValue == null && nullToAbsent
          ? const Value.absent()
          : Value(totalCurrentValue),
      gainOrLossCad: gainOrLossCad == null && nullToAbsent
          ? const Value.absent()
          : Value(gainOrLossCad),
      gainOrLossUsd: gainOrLossUsd == null && nullToAbsent
          ? const Value.absent()
          : Value(gainOrLossUsd),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      currentPrice: currentPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(currentPrice),
      slug: slug == null && nullToAbsent ? const Value.absent() : Value(slug),
    );
  }

  factory InvestmentEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvestmentEntity(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      ticker: serializer.fromJson<String>(json['ticker']),
      companyName: serializer.fromJson<String>(json['companyName']),
      currency: serializer.fromJson<String>(json['currency']),
      type: serializer.fromJson<String>(json['type']),
      stockExchange: serializer.fromJson<String>(json['stockExchange']),
      description: serializer.fromJson<String>(json['description']),
      quantity: serializer.fromJson<int>(json['quantity']),
      totalValueOnPurchase: serializer.fromJson<double?>(
        json['totalValueOnPurchase'],
      ),
      companyLogoUrl: serializer.fromJson<String>(json['companyLogoUrl']),
      purchaseDate: serializer.fromJson<DateTime?>(json['purchaseDate']),
      isPurchased: serializer.fromJson<bool>(json['isPurchased']),
      purchasePrice: serializer.fromJson<double?>(json['purchasePrice']),
      totalCurrentValue: serializer.fromJson<double?>(
        json['totalCurrentValue'],
      ),
      gainOrLossCad: serializer.fromJson<double?>(json['gainOrLossCad']),
      gainOrLossUsd: serializer.fromJson<double?>(json['gainOrLossUsd']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      currentPrice: serializer.fromJson<double?>(json['currentPrice']),
      slug: serializer.fromJson<String?>(json['slug']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'ticker': serializer.toJson<String>(ticker),
      'companyName': serializer.toJson<String>(companyName),
      'currency': serializer.toJson<String>(currency),
      'type': serializer.toJson<String>(type),
      'stockExchange': serializer.toJson<String>(stockExchange),
      'description': serializer.toJson<String>(description),
      'quantity': serializer.toJson<int>(quantity),
      'totalValueOnPurchase': serializer.toJson<double?>(totalValueOnPurchase),
      'companyLogoUrl': serializer.toJson<String>(companyLogoUrl),
      'purchaseDate': serializer.toJson<DateTime?>(purchaseDate),
      'isPurchased': serializer.toJson<bool>(isPurchased),
      'purchasePrice': serializer.toJson<double?>(purchasePrice),
      'totalCurrentValue': serializer.toJson<double?>(totalCurrentValue),
      'gainOrLossCad': serializer.toJson<double?>(gainOrLossCad),
      'gainOrLossUsd': serializer.toJson<double?>(gainOrLossUsd),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'currentPrice': serializer.toJson<double?>(currentPrice),
      'slug': serializer.toJson<String?>(slug),
    };
  }

  InvestmentEntity copyWith({
    int? id,
    String? userId,
    String? ticker,
    String? companyName,
    String? currency,
    String? type,
    String? stockExchange,
    String? description,
    int? quantity,
    Value<double?> totalValueOnPurchase = const Value.absent(),
    String? companyLogoUrl,
    Value<DateTime?> purchaseDate = const Value.absent(),
    bool? isPurchased,
    Value<double?> purchasePrice = const Value.absent(),
    Value<double?> totalCurrentValue = const Value.absent(),
    Value<double?> gainOrLossCad = const Value.absent(),
    Value<double?> gainOrLossUsd = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<double?> currentPrice = const Value.absent(),
    Value<String?> slug = const Value.absent(),
  }) => InvestmentEntity(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    ticker: ticker ?? this.ticker,
    companyName: companyName ?? this.companyName,
    currency: currency ?? this.currency,
    type: type ?? this.type,
    stockExchange: stockExchange ?? this.stockExchange,
    description: description ?? this.description,
    quantity: quantity ?? this.quantity,
    totalValueOnPurchase: totalValueOnPurchase.present
        ? totalValueOnPurchase.value
        : this.totalValueOnPurchase,
    companyLogoUrl: companyLogoUrl ?? this.companyLogoUrl,
    purchaseDate: purchaseDate.present ? purchaseDate.value : this.purchaseDate,
    isPurchased: isPurchased ?? this.isPurchased,
    purchasePrice: purchasePrice.present
        ? purchasePrice.value
        : this.purchasePrice,
    totalCurrentValue: totalCurrentValue.present
        ? totalCurrentValue.value
        : this.totalCurrentValue,
    gainOrLossCad: gainOrLossCad.present
        ? gainOrLossCad.value
        : this.gainOrLossCad,
    gainOrLossUsd: gainOrLossUsd.present
        ? gainOrLossUsd.value
        : this.gainOrLossUsd,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    currentPrice: currentPrice.present ? currentPrice.value : this.currentPrice,
    slug: slug.present ? slug.value : this.slug,
  );
  InvestmentEntity copyWithCompanion(InvestmentsTableCompanion data) {
    return InvestmentEntity(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      ticker: data.ticker.present ? data.ticker.value : this.ticker,
      companyName: data.companyName.present
          ? data.companyName.value
          : this.companyName,
      currency: data.currency.present ? data.currency.value : this.currency,
      type: data.type.present ? data.type.value : this.type,
      stockExchange: data.stockExchange.present
          ? data.stockExchange.value
          : this.stockExchange,
      description: data.description.present
          ? data.description.value
          : this.description,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      totalValueOnPurchase: data.totalValueOnPurchase.present
          ? data.totalValueOnPurchase.value
          : this.totalValueOnPurchase,
      companyLogoUrl: data.companyLogoUrl.present
          ? data.companyLogoUrl.value
          : this.companyLogoUrl,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      isPurchased: data.isPurchased.present
          ? data.isPurchased.value
          : this.isPurchased,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      totalCurrentValue: data.totalCurrentValue.present
          ? data.totalCurrentValue.value
          : this.totalCurrentValue,
      gainOrLossCad: data.gainOrLossCad.present
          ? data.gainOrLossCad.value
          : this.gainOrLossCad,
      gainOrLossUsd: data.gainOrLossUsd.present
          ? data.gainOrLossUsd.value
          : this.gainOrLossUsd,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      currentPrice: data.currentPrice.present
          ? data.currentPrice.value
          : this.currentPrice,
      slug: data.slug.present ? data.slug.value : this.slug,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvestmentEntity(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('ticker: $ticker, ')
          ..write('companyName: $companyName, ')
          ..write('currency: $currency, ')
          ..write('type: $type, ')
          ..write('stockExchange: $stockExchange, ')
          ..write('description: $description, ')
          ..write('quantity: $quantity, ')
          ..write('totalValueOnPurchase: $totalValueOnPurchase, ')
          ..write('companyLogoUrl: $companyLogoUrl, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('isPurchased: $isPurchased, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('totalCurrentValue: $totalCurrentValue, ')
          ..write('gainOrLossCad: $gainOrLossCad, ')
          ..write('gainOrLossUsd: $gainOrLossUsd, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('currentPrice: $currentPrice, ')
          ..write('slug: $slug')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    userId,
    ticker,
    companyName,
    currency,
    type,
    stockExchange,
    description,
    quantity,
    totalValueOnPurchase,
    companyLogoUrl,
    purchaseDate,
    isPurchased,
    purchasePrice,
    totalCurrentValue,
    gainOrLossCad,
    gainOrLossUsd,
    createdAt,
    updatedAt,
    currentPrice,
    slug,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvestmentEntity &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.ticker == this.ticker &&
          other.companyName == this.companyName &&
          other.currency == this.currency &&
          other.type == this.type &&
          other.stockExchange == this.stockExchange &&
          other.description == this.description &&
          other.quantity == this.quantity &&
          other.totalValueOnPurchase == this.totalValueOnPurchase &&
          other.companyLogoUrl == this.companyLogoUrl &&
          other.purchaseDate == this.purchaseDate &&
          other.isPurchased == this.isPurchased &&
          other.purchasePrice == this.purchasePrice &&
          other.totalCurrentValue == this.totalCurrentValue &&
          other.gainOrLossCad == this.gainOrLossCad &&
          other.gainOrLossUsd == this.gainOrLossUsd &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.currentPrice == this.currentPrice &&
          other.slug == this.slug);
}

class InvestmentsTableCompanion extends UpdateCompanion<InvestmentEntity> {
  final Value<int> id;
  final Value<String> userId;
  final Value<String> ticker;
  final Value<String> companyName;
  final Value<String> currency;
  final Value<String> type;
  final Value<String> stockExchange;
  final Value<String> description;
  final Value<int> quantity;
  final Value<double?> totalValueOnPurchase;
  final Value<String> companyLogoUrl;
  final Value<DateTime?> purchaseDate;
  final Value<bool> isPurchased;
  final Value<double?> purchasePrice;
  final Value<double?> totalCurrentValue;
  final Value<double?> gainOrLossCad;
  final Value<double?> gainOrLossUsd;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<double?> currentPrice;
  final Value<String?> slug;
  final Value<int> rowid;
  const InvestmentsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.ticker = const Value.absent(),
    this.companyName = const Value.absent(),
    this.currency = const Value.absent(),
    this.type = const Value.absent(),
    this.stockExchange = const Value.absent(),
    this.description = const Value.absent(),
    this.quantity = const Value.absent(),
    this.totalValueOnPurchase = const Value.absent(),
    this.companyLogoUrl = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.isPurchased = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.totalCurrentValue = const Value.absent(),
    this.gainOrLossCad = const Value.absent(),
    this.gainOrLossUsd = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.currentPrice = const Value.absent(),
    this.slug = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvestmentsTableCompanion.insert({
    required int id,
    required String userId,
    required String ticker,
    required String companyName,
    required String currency,
    required String type,
    required String stockExchange,
    required String description,
    required int quantity,
    this.totalValueOnPurchase = const Value.absent(),
    required String companyLogoUrl,
    this.purchaseDate = const Value.absent(),
    this.isPurchased = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.totalCurrentValue = const Value.absent(),
    this.gainOrLossCad = const Value.absent(),
    this.gainOrLossUsd = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.currentPrice = const Value.absent(),
    this.slug = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       ticker = Value(ticker),
       companyName = Value(companyName),
       currency = Value(currency),
       type = Value(type),
       stockExchange = Value(stockExchange),
       description = Value(description),
       quantity = Value(quantity),
       companyLogoUrl = Value(companyLogoUrl);
  static Insertable<InvestmentEntity> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? ticker,
    Expression<String>? companyName,
    Expression<String>? currency,
    Expression<String>? type,
    Expression<String>? stockExchange,
    Expression<String>? description,
    Expression<int>? quantity,
    Expression<double>? totalValueOnPurchase,
    Expression<String>? companyLogoUrl,
    Expression<DateTime>? purchaseDate,
    Expression<bool>? isPurchased,
    Expression<double>? purchasePrice,
    Expression<double>? totalCurrentValue,
    Expression<double>? gainOrLossCad,
    Expression<double>? gainOrLossUsd,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<double>? currentPrice,
    Expression<String>? slug,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (ticker != null) 'ticker': ticker,
      if (companyName != null) 'company_name': companyName,
      if (currency != null) 'currency': currency,
      if (type != null) 'type': type,
      if (stockExchange != null) 'stock_exchange': stockExchange,
      if (description != null) 'description': description,
      if (quantity != null) 'quantity': quantity,
      if (totalValueOnPurchase != null)
        'total_value_on_purchase': totalValueOnPurchase,
      if (companyLogoUrl != null) 'company_logo_url': companyLogoUrl,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (isPurchased != null) 'is_purchased': isPurchased,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (totalCurrentValue != null) 'total_current_value': totalCurrentValue,
      if (gainOrLossCad != null) 'gain_or_loss_cad': gainOrLossCad,
      if (gainOrLossUsd != null) 'gain_or_loss_usd': gainOrLossUsd,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (currentPrice != null) 'current_price': currentPrice,
      if (slug != null) 'slug': slug,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvestmentsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<String>? ticker,
    Value<String>? companyName,
    Value<String>? currency,
    Value<String>? type,
    Value<String>? stockExchange,
    Value<String>? description,
    Value<int>? quantity,
    Value<double?>? totalValueOnPurchase,
    Value<String>? companyLogoUrl,
    Value<DateTime?>? purchaseDate,
    Value<bool>? isPurchased,
    Value<double?>? purchasePrice,
    Value<double?>? totalCurrentValue,
    Value<double?>? gainOrLossCad,
    Value<double?>? gainOrLossUsd,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<double?>? currentPrice,
    Value<String?>? slug,
    Value<int>? rowid,
  }) {
    return InvestmentsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      ticker: ticker ?? this.ticker,
      companyName: companyName ?? this.companyName,
      currency: currency ?? this.currency,
      type: type ?? this.type,
      stockExchange: stockExchange ?? this.stockExchange,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      totalValueOnPurchase: totalValueOnPurchase ?? this.totalValueOnPurchase,
      companyLogoUrl: companyLogoUrl ?? this.companyLogoUrl,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      isPurchased: isPurchased ?? this.isPurchased,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      totalCurrentValue: totalCurrentValue ?? this.totalCurrentValue,
      gainOrLossCad: gainOrLossCad ?? this.gainOrLossCad,
      gainOrLossUsd: gainOrLossUsd ?? this.gainOrLossUsd,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      currentPrice: currentPrice ?? this.currentPrice,
      slug: slug ?? this.slug,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (ticker.present) {
      map['ticker'] = Variable<String>(ticker.value);
    }
    if (companyName.present) {
      map['company_name'] = Variable<String>(companyName.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (stockExchange.present) {
      map['stock_exchange'] = Variable<String>(stockExchange.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (totalValueOnPurchase.present) {
      map['total_value_on_purchase'] = Variable<double>(
        totalValueOnPurchase.value,
      );
    }
    if (companyLogoUrl.present) {
      map['company_logo_url'] = Variable<String>(companyLogoUrl.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (isPurchased.present) {
      map['is_purchased'] = Variable<bool>(isPurchased.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<double>(purchasePrice.value);
    }
    if (totalCurrentValue.present) {
      map['total_current_value'] = Variable<double>(totalCurrentValue.value);
    }
    if (gainOrLossCad.present) {
      map['gain_or_loss_cad'] = Variable<double>(gainOrLossCad.value);
    }
    if (gainOrLossUsd.present) {
      map['gain_or_loss_usd'] = Variable<double>(gainOrLossUsd.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (currentPrice.present) {
      map['current_price'] = Variable<double>(currentPrice.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvestmentsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('ticker: $ticker, ')
          ..write('companyName: $companyName, ')
          ..write('currency: $currency, ')
          ..write('type: $type, ')
          ..write('stockExchange: $stockExchange, ')
          ..write('description: $description, ')
          ..write('quantity: $quantity, ')
          ..write('totalValueOnPurchase: $totalValueOnPurchase, ')
          ..write('companyLogoUrl: $companyLogoUrl, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('isPurchased: $isPurchased, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('totalCurrentValue: $totalCurrentValue, ')
          ..write('gainOrLossCad: $gainOrLossCad, ')
          ..write('gainOrLossUsd: $gainOrLossUsd, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('currentPrice: $currentPrice, ')
          ..write('slug: $slug, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MetadataTableTable extends MetadataTable
    with TableInfo<$MetadataTableTable, MetadataEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetadataTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'metadata_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MetadataEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  MetadataEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetadataEntity(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $MetadataTableTable createAlias(String alias) {
    return $MetadataTableTable(attachedDatabase, alias);
  }
}

class MetadataEntity extends DataClass implements Insertable<MetadataEntity> {
  final String key;
  final String value;
  const MetadataEntity({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  MetadataTableCompanion toCompanion(bool nullToAbsent) {
    return MetadataTableCompanion(key: Value(key), value: Value(value));
  }

  factory MetadataEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetadataEntity(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  MetadataEntity copyWith({String? key, String? value}) =>
      MetadataEntity(key: key ?? this.key, value: value ?? this.value);
  MetadataEntity copyWithCompanion(MetadataTableCompanion data) {
    return MetadataEntity(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetadataEntity(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetadataEntity &&
          other.key == this.key &&
          other.value == this.value);
}

class MetadataTableCompanion extends UpdateCompanion<MetadataEntity> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const MetadataTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MetadataTableCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<MetadataEntity> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MetadataTableCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return MetadataTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetadataTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $InvestmentsTableTable investmentsTable = $InvestmentsTableTable(
    this,
  );
  late final $MetadataTableTable metadataTable = $MetadataTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    investmentsTable,
    metadataTable,
  ];
}

typedef $$InvestmentsTableTableCreateCompanionBuilder =
    InvestmentsTableCompanion Function({
      required int id,
      required String userId,
      required String ticker,
      required String companyName,
      required String currency,
      required String type,
      required String stockExchange,
      required String description,
      required int quantity,
      Value<double?> totalValueOnPurchase,
      required String companyLogoUrl,
      Value<DateTime?> purchaseDate,
      Value<bool> isPurchased,
      Value<double?> purchasePrice,
      Value<double?> totalCurrentValue,
      Value<double?> gainOrLossCad,
      Value<double?> gainOrLossUsd,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<double?> currentPrice,
      Value<String?> slug,
      Value<int> rowid,
    });
typedef $$InvestmentsTableTableUpdateCompanionBuilder =
    InvestmentsTableCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<String> ticker,
      Value<String> companyName,
      Value<String> currency,
      Value<String> type,
      Value<String> stockExchange,
      Value<String> description,
      Value<int> quantity,
      Value<double?> totalValueOnPurchase,
      Value<String> companyLogoUrl,
      Value<DateTime?> purchaseDate,
      Value<bool> isPurchased,
      Value<double?> purchasePrice,
      Value<double?> totalCurrentValue,
      Value<double?> gainOrLossCad,
      Value<double?> gainOrLossUsd,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<double?> currentPrice,
      Value<String?> slug,
      Value<int> rowid,
    });

class $$InvestmentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $InvestmentsTableTable> {
  $$InvestmentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ticker => $composableBuilder(
    column: $table.ticker,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stockExchange => $composableBuilder(
    column: $table.stockExchange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalValueOnPurchase => $composableBuilder(
    column: $table.totalValueOnPurchase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyLogoUrl => $composableBuilder(
    column: $table.companyLogoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPurchased => $composableBuilder(
    column: $table.isPurchased,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCurrentValue => $composableBuilder(
    column: $table.totalCurrentValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gainOrLossCad => $composableBuilder(
    column: $table.gainOrLossCad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gainOrLossUsd => $composableBuilder(
    column: $table.gainOrLossUsd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentPrice => $composableBuilder(
    column: $table.currentPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InvestmentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $InvestmentsTableTable> {
  $$InvestmentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ticker => $composableBuilder(
    column: $table.ticker,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stockExchange => $composableBuilder(
    column: $table.stockExchange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalValueOnPurchase => $composableBuilder(
    column: $table.totalValueOnPurchase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyLogoUrl => $composableBuilder(
    column: $table.companyLogoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPurchased => $composableBuilder(
    column: $table.isPurchased,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCurrentValue => $composableBuilder(
    column: $table.totalCurrentValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gainOrLossCad => $composableBuilder(
    column: $table.gainOrLossCad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gainOrLossUsd => $composableBuilder(
    column: $table.gainOrLossUsd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentPrice => $composableBuilder(
    column: $table.currentPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InvestmentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvestmentsTableTable> {
  $$InvestmentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get ticker =>
      $composableBuilder(column: $table.ticker, builder: (column) => column);

  GeneratedColumn<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get stockExchange => $composableBuilder(
    column: $table.stockExchange,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get totalValueOnPurchase => $composableBuilder(
    column: $table.totalValueOnPurchase,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companyLogoUrl => $composableBuilder(
    column: $table.companyLogoUrl,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPurchased => $composableBuilder(
    column: $table.isPurchased,
    builder: (column) => column,
  );

  GeneratedColumn<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalCurrentValue => $composableBuilder(
    column: $table.totalCurrentValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get gainOrLossCad => $composableBuilder(
    column: $table.gainOrLossCad,
    builder: (column) => column,
  );

  GeneratedColumn<double> get gainOrLossUsd => $composableBuilder(
    column: $table.gainOrLossUsd,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<double> get currentPrice => $composableBuilder(
    column: $table.currentPrice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);
}

class $$InvestmentsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvestmentsTableTable,
          InvestmentEntity,
          $$InvestmentsTableTableFilterComposer,
          $$InvestmentsTableTableOrderingComposer,
          $$InvestmentsTableTableAnnotationComposer,
          $$InvestmentsTableTableCreateCompanionBuilder,
          $$InvestmentsTableTableUpdateCompanionBuilder,
          (
            InvestmentEntity,
            BaseReferences<
              _$AppDatabase,
              $InvestmentsTableTable,
              InvestmentEntity
            >,
          ),
          InvestmentEntity,
          PrefetchHooks Function()
        > {
  $$InvestmentsTableTableTableManager(
    _$AppDatabase db,
    $InvestmentsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvestmentsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvestmentsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvestmentsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> ticker = const Value.absent(),
                Value<String> companyName = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> stockExchange = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double?> totalValueOnPurchase = const Value.absent(),
                Value<String> companyLogoUrl = const Value.absent(),
                Value<DateTime?> purchaseDate = const Value.absent(),
                Value<bool> isPurchased = const Value.absent(),
                Value<double?> purchasePrice = const Value.absent(),
                Value<double?> totalCurrentValue = const Value.absent(),
                Value<double?> gainOrLossCad = const Value.absent(),
                Value<double?> gainOrLossUsd = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<double?> currentPrice = const Value.absent(),
                Value<String?> slug = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvestmentsTableCompanion(
                id: id,
                userId: userId,
                ticker: ticker,
                companyName: companyName,
                currency: currency,
                type: type,
                stockExchange: stockExchange,
                description: description,
                quantity: quantity,
                totalValueOnPurchase: totalValueOnPurchase,
                companyLogoUrl: companyLogoUrl,
                purchaseDate: purchaseDate,
                isPurchased: isPurchased,
                purchasePrice: purchasePrice,
                totalCurrentValue: totalCurrentValue,
                gainOrLossCad: gainOrLossCad,
                gainOrLossUsd: gainOrLossUsd,
                createdAt: createdAt,
                updatedAt: updatedAt,
                currentPrice: currentPrice,
                slug: slug,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int id,
                required String userId,
                required String ticker,
                required String companyName,
                required String currency,
                required String type,
                required String stockExchange,
                required String description,
                required int quantity,
                Value<double?> totalValueOnPurchase = const Value.absent(),
                required String companyLogoUrl,
                Value<DateTime?> purchaseDate = const Value.absent(),
                Value<bool> isPurchased = const Value.absent(),
                Value<double?> purchasePrice = const Value.absent(),
                Value<double?> totalCurrentValue = const Value.absent(),
                Value<double?> gainOrLossCad = const Value.absent(),
                Value<double?> gainOrLossUsd = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<double?> currentPrice = const Value.absent(),
                Value<String?> slug = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvestmentsTableCompanion.insert(
                id: id,
                userId: userId,
                ticker: ticker,
                companyName: companyName,
                currency: currency,
                type: type,
                stockExchange: stockExchange,
                description: description,
                quantity: quantity,
                totalValueOnPurchase: totalValueOnPurchase,
                companyLogoUrl: companyLogoUrl,
                purchaseDate: purchaseDate,
                isPurchased: isPurchased,
                purchasePrice: purchasePrice,
                totalCurrentValue: totalCurrentValue,
                gainOrLossCad: gainOrLossCad,
                gainOrLossUsd: gainOrLossUsd,
                createdAt: createdAt,
                updatedAt: updatedAt,
                currentPrice: currentPrice,
                slug: slug,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InvestmentsTableTable, InvestmentEntity>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $InvestmentsTableTable,
                    InvestmentEntity
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InvestmentsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvestmentsTableTable,
      InvestmentEntity,
      $$InvestmentsTableTableFilterComposer,
      $$InvestmentsTableTableOrderingComposer,
      $$InvestmentsTableTableAnnotationComposer,
      $$InvestmentsTableTableCreateCompanionBuilder,
      $$InvestmentsTableTableUpdateCompanionBuilder,
      (
        InvestmentEntity,
        BaseReferences<_$AppDatabase, $InvestmentsTableTable, InvestmentEntity>,
      ),
      InvestmentEntity,
      PrefetchHooks Function()
    >;
typedef $$MetadataTableTableCreateCompanionBuilder =
    MetadataTableCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$MetadataTableTableUpdateCompanionBuilder =
    MetadataTableCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$MetadataTableTableFilterComposer
    extends Composer<_$AppDatabase, $MetadataTableTable> {
  $$MetadataTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MetadataTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MetadataTableTable> {
  $$MetadataTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MetadataTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MetadataTableTable> {
  $$MetadataTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$MetadataTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MetadataTableTable,
          MetadataEntity,
          $$MetadataTableTableFilterComposer,
          $$MetadataTableTableOrderingComposer,
          $$MetadataTableTableAnnotationComposer,
          $$MetadataTableTableCreateCompanionBuilder,
          $$MetadataTableTableUpdateCompanionBuilder,
          (
            MetadataEntity,
            BaseReferences<_$AppDatabase, $MetadataTableTable, MetadataEntity>,
          ),
          MetadataEntity,
          PrefetchHooks Function()
        > {
  $$MetadataTableTableTableManager(_$AppDatabase db, $MetadataTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MetadataTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MetadataTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetadataTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) =>
                  MetadataTableCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => MetadataTableCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MetadataTableTable, MetadataEntity>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $MetadataTableTable,
                    MetadataEntity
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MetadataTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MetadataTableTable,
      MetadataEntity,
      $$MetadataTableTableFilterComposer,
      $$MetadataTableTableOrderingComposer,
      $$MetadataTableTableAnnotationComposer,
      $$MetadataTableTableCreateCompanionBuilder,
      $$MetadataTableTableUpdateCompanionBuilder,
      (
        MetadataEntity,
        BaseReferences<_$AppDatabase, $MetadataTableTable, MetadataEntity>,
      ),
      MetadataEntity,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$InvestmentsTableTableTableManager get investmentsTable =>
      $$InvestmentsTableTableTableManager(_db, _db.investmentsTable);
  $$MetadataTableTableTableManager get metadataTable =>
      $$MetadataTableTableTableManager(_db, _db.metadataTable);
}
