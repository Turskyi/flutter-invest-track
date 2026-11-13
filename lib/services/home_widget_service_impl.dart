import 'dart:convert' as convert;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:home_widget/home_widget.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:investtrack/domain_services/settings_repository.dart';
import 'package:investtrack/infrastructure/data_sources/local/database/app_database.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:investtrack/res/home_widget_keys.dart';
import 'package:investtrack/services/home_widget_service.dart';
import 'package:models/models.dart';

@LazySingleton(as: HomeWidgetService)
class HomeWidgetServiceImpl implements HomeWidgetService {
  const HomeWidgetServiceImpl();

  static const MethodChannel _widgetChannel = MethodChannel(
    constants.kHomeWidgetMethodChannel,
  );

  @override
  Future<void> setAppGroupId({required String appGroupId}) {
    if (_isWidgetUnsupported) {
      return Future<void>.value();
    } else if (Platform.isMacOS) {
      return _widgetChannel.invokeMethod<void>(
        constants.kSetAppGroupIdMethod,
        <String, String>{constants.kAppGroupIdArgKey: appGroupId},
      );
    } else {
      return HomeWidget.setAppGroupId(appGroupId);
    }
  }

  @override
  Future<bool?> saveWidgetData<T>({required String id, required T? data}) {
    if (_isWidgetUnsupported) {
      return Future<bool>.value(false);
    } else if (Platform.isMacOS) {
      return _widgetChannel.invokeMethod<bool>(
        constants.kSaveWidgetDataMethod,
        <String, Object?>{
          'key': id,
          'value': data,
          constants.kAppGroupIdArgKey: constants.kAppleAppGroupId,
        },
      );
    } else {
      return HomeWidget.saveWidgetData<T>(
        id,
        data,
        appGroupId: constants.kAppleAppGroupId,
      );
    }
  }

  @override
  Future<bool?> updateWidget({
    String? name,
    String? androidName,
    String? iOSName,
    String? qualifiedAndroidName,
  }) {
    if (_isWidgetUnsupported) {
      return Future<bool>.value(false);
    } else if (Platform.isMacOS) {
      return _widgetChannel.invokeMethod<bool>(constants.kUpdateWidgetMethod);
    } else {
      return HomeWidget.updateWidget(
        name: name,
        iOSName: iOSName,
        androidName: androidName,
        qualifiedAndroidName: qualifiedAndroidName,
      );
    }
  }

  @override
  Future<void> updateHomeWidget({
    required AppDatabase appDatabase,
    required String userId,
    required AppTheme appTheme,
    required SettingsRepository settingsRepository,
  }) async {
    final Language language = settingsRepository.getLanguage();
    final String languageCode = language.isoLanguageCode;

    final List<Investment> investments = await appDatabase.getInvestments(
      userId,
    );

    if (investments.isEmpty) {
      debugPrint(
        'HomeWidgetService warning: no local investments found for '
        'userId="$userId". Aborting widget update to prevent incorrect data.',
      );
      return;
    }

    double totalCurrentValue = 0.0;
    double totalInvested = 0.0;
    double totalGainOrLoss = 0.0;

    for (final Investment investment in investments) {
      final double? currentValue =
          investment.totalCurrentValue ??
          (investment.currentPrice != null
              ? investment.quantity * investment.currentPrice!
              : null);

      if (currentValue != null) {
        totalCurrentValue += currentValue;

        final double purchaseValue =
            investment.totalValueOnPurchase ??
            (investment.purchasePrice != null
                ? investment.quantity * investment.purchasePrice!
                : currentValue);

        totalInvested += purchaseValue;

        final double gainOrLossUsd =
            investment.gainOrLossUsd ??
            (investment.purchasePrice != null
                ? currentValue -
                      (investment.quantity * investment.purchasePrice!)
                : 0.0);

        totalGainOrLoss += gainOrLossUsd;
      }
    }

    final double returnPercentage = totalInvested > 0
        ? (totalGainOrLoss / totalInvested) * 100
        : 0.0;
    final bool isPositive = totalGainOrLoss >= 0;

    final NumberFormat currencyFormat = NumberFormat.currency(
      symbol: r'$',
      decimalDigits: 2,
    );
    final String formattedPortfolioValue = currencyFormat.format(
      totalCurrentValue,
    );
    final String formattedGainOrLossSign = isPositive ? '+' : '';
    final String formattedGainOrLoss =
        '$formattedGainOrLossSign${currencyFormat.format(totalGainOrLoss)}';
    final String formattedReturnPercentage =
        '$formattedGainOrLossSign${returnPercentage.toStringAsFixed(2)}%';
    final String formattedInvested = currencyFormat.format(totalInvested);
    final String formattedLastUpdated = DateFormat(
      'MMM d, HH:mm',
    ).format(DateTime.now());

    final String localizedPortfolioLabel = translate(
      'widget.total_portfolio_value',
    );
    final String localizedInvestedLabel = translate('widget.invested');
    final String localizedTopHoldingsLabel = translate('widget.top_holdings');

    // Sort top 5 holdings by totalCurrentValue descending.
    final List<Investment> sortedInvestments =
        List<Investment>.from(investments)..sort((Investment a, Investment b) {
          final double aVal = a.totalCurrentValue ?? 0.0;
          final double bVal = b.totalCurrentValue ?? 0.0;
          return bVal.compareTo(aVal);
        });

    final List<Map<String, dynamic>> topHoldingsList = sortedInvestments
        .take(5)
        .map((Investment item) {
          final double currentVal =
              item.totalCurrentValue ??
              (item.currentPrice != null
                  ? item.quantity * item.currentPrice!
                  : 0.0);
          final double gainLossUsd = item.gainOrLossUsd ?? 0.0;
          return <String, dynamic>{
            'ticker': item.ticker,
            'companyName': item.companyName,
            'quantity': item.quantity,
            'currentPrice': item.currentPrice ?? 0.0,
            'totalCurrentValue': currentVal,
            'gainOrLoss': gainLossUsd,
            'formattedValue': currencyFormat.format(currentVal),
          };
        })
        .toList();

    final String topHoldingsJson = convert.jsonEncode(topHoldingsList);

    await setAppGroupId(appGroupId: constants.kAppleAppGroupId);

    await saveWidgetData<String>(
      id: HomeWidgetKey.totalPortfolioValue.stringValue,
      data: formattedPortfolioValue,
    );
    await saveWidgetData<String>(
      id: HomeWidgetKey.totalGainOrLoss.stringValue,
      data: formattedGainOrLoss,
    );
    await saveWidgetData<String>(
      id: HomeWidgetKey.totalGainOrLossPercentage.stringValue,
      data: formattedReturnPercentage,
    );
    await saveWidgetData<bool>(
      id: HomeWidgetKey.isPositive.stringValue,
      data: isPositive,
    );
    await saveWidgetData<String>(
      id: HomeWidgetKey.totalInvested.stringValue,
      data: formattedInvested,
    );
    await saveWidgetData<int>(
      id: HomeWidgetKey.totalHoldingsCount.stringValue,
      data: investments.length,
    );
    await saveWidgetData<String>(
      id: HomeWidgetKey.lastUpdated.stringValue,
      data: formattedLastUpdated,
    );
    await saveWidgetData<String>(
      id: HomeWidgetKey.currency.stringValue,
      data: 'USD',
    );
    await saveWidgetData<String>(
      id: HomeWidgetKey.topHoldingsJson.stringValue,
      data: topHoldingsJson,
    );
    await saveWidgetData<String>(
      id: HomeWidgetKey.appTheme.stringValue,
      data: appTheme.name,
    );
    await saveWidgetData<String>(
      id: HomeWidgetKey.selectedLanguage.stringValue,
      data: languageCode,
    );
    await saveWidgetData<String>(
      id: HomeWidgetKey.totalPortfolioValueLabel.stringValue,
      data: localizedPortfolioLabel,
    );
    await saveWidgetData<String>(
      id: HomeWidgetKey.investedLabel.stringValue,
      data: localizedInvestedLabel,
    );
    await saveWidgetData<String>(
      id: HomeWidgetKey.topHoldingsLabel.stringValue,
      data: localizedTopHoldingsLabel,
    );
  }

  @override
  Future<void> requestPinWidget({
    String? name,
    String? androidName,
    String? qualifiedAndroidName,
  }) {
    if (!kIsWeb && Platform.isAndroid) {
      return HomeWidget.requestPinWidget(
        name: name,
        androidName: androidName,
        qualifiedAndroidName: qualifiedAndroidName,
      );
    } else {
      return Future<void>.value();
    }
  }

  bool get _isWidgetUnsupported => kIsWeb;
}
