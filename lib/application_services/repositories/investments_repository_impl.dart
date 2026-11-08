import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:injectable/injectable.dart';
import 'package:investtrack/domain_services/investments_repository.dart';
import 'package:investtrack/infrastructure/data_sources/local/database/app_database.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable(as: InvestmentsRepository)
class InvestmentsRepositoryImpl implements InvestmentsRepository {
  const InvestmentsRepositoryImpl(
    this._restClient,
    this._preferences,
    this._appDatabase,
  );

  final RestClient _restClient;
  final SharedPreferences _preferences;
  final AppDatabase _appDatabase;

  @override
  Future<Investments> getInvestments({
    required String userId,
    int page = constants.pageOffset,
    int investmentsPerPage = constants.itemsPerPage,
  }) {
    return _restClient.getInvestments(userId, page, investmentsPerPage);
  }

  @override
  Future<Investment> create(Investment investment) async {
    try {
      final InvestmentResult response = await _restClient.createInvestment(
        investment,
      );
      final Investment created = response.investment;
      await _appDatabase.saveInvestment(created);
      return created;
    } catch (error) {
      if (error is DioException) {
        final Object? responseData = error.response?.data;

        if (responseData is String) {
          // If the response is a raw JSON string, parse it
          final Map<String, Object?> parsedData = json.decode(responseData);
          throw Exception(parsedData['error'] ?? 'Unknown error occurred');
        } else if (responseData is Map<String, Object?>) {
          try {
            final InvestTrackError investTrackError = InvestTrackError.fromJson(
              responseData,
            );
            throw InvestTrackException(investTrackError.error);
          } catch (e) {
            // Handle the case where the parsing fails.
            debugPrint('Error parsing InvestTrackError: $e');
          }

          // If the response is already a parsed JSON object
          throw Exception(responseData['error'] ?? 'Unknown error occurred');
        }
      }
      // Re-throw the original error if it's not a DioError or has no response
      // data.
      rethrow;
    }
  }

  @override
  Future<MessageResponse> delete(Investment investment) async {
    final String userId = _preferences.getString(StorageKeys.userId.key) ?? '';
    if (userId.isNotEmpty || userId == investment.userId) {
      final MessageResponse response = await _restClient.deleteInvestment(
        userId,
        investment.id,
      );
      await _appDatabase.deleteInvestment(
        id: investment.id,
        userId: investment.userId,
      );
      return response;
    } else {
      throw const InvestTrackException(
        'You do not have permission to delete this investment.',
      );
    }
  }

  @override
  Future<Investment> update(Investment investment) async {
    try {
      final InvestmentResult response = await _restClient.updateInvestment(
        investment,
      );
      final Investment updated = response.investment;
      await _appDatabase.saveInvestment(updated);
      return updated;
    } catch (error) {
      if (error is DioException) {
        // Try to parse the error message from the response body.
        final Object? responseData = error.response?.data;

        if (responseData is String) {
          // If the response is a raw JSON string, parse it
          final Map<String, Object?> parsedData = json.decode(responseData);
          throw Exception(parsedData['error'] ?? 'Unknown error occurred');
        } else if (responseData is Map<String, Object?>) {
          // Try to convert the responseData to `InvestTrackError` using
          // `fromJson`.
          try {
            final InvestTrackError investTrackError = InvestTrackError.fromJson(
              responseData,
            );
            throw InvestTrackException(investTrackError.error);
          } catch (e) {
            // Handle the case where the parsing fails
            debugPrint('Error parsing InvestTrackError: $e');
          }

          // If the response is already a parsed JSON object
          throw Exception(responseData['error'] ?? 'Unknown error occurred');
        }
      }
      // Re-throw the original error if it's not a DioError or has no response
      // data.
      rethrow;
    }
  }

  @override
  Future<double> fetchPriceChange(String ticker) {
    return _restClient
        .fetchPriceChange(ticker)
        .then((PriceChange response) => response.priceChange);
  }

  @override
  Future<double> fetchChangePercentage(String ticker) {
    return _restClient
        .fetchChangePercentage(ticker)
        .then((ChangePercentage response) => response.changePercentage);
  }

  @override
  Future<double> fetchFinance({required String ticker, String? date}) {
    return _restClient
        .fetchFinance(ticker: ticker, date: date)
        .then((FinanceResult response) => response.currentPrice);
  }

  @override
  Stream<List<Investment>> watchLocalInvestments(String userId) {
    return _appDatabase.watchInvestments(userId);
  }

  @override
  Future<List<Investment>> getLocalInvestments(String userId) {
    return _appDatabase.getInvestments(userId);
  }

  @override
  Future<void> saveLocalInvestments({
    required String userId,
    required List<Investment> investments,
  }) {
    return _appDatabase.saveInvestments(
      userId: userId,
      investments: investments,
    );
  }

  @override
  Future<void> saveLocalInvestment(Investment investment) {
    return _appDatabase.saveInvestment(investment);
  }

  @override
  Future<void> deleteLocalInvestment({
    required int id,
    required String userId,
  }) {
    return _appDatabase.deleteInvestment(id: id, userId: userId);
  }

  @override
  Future<DateTime?> getLastFetchedAt(String userId) {
    return _appDatabase.getLastFetchedAt(userId);
  }

  @override
  Future<void> setLastFetchedAt({
    required String userId,
    required DateTime time,
  }) {
    return _appDatabase.setLastFetchedAt(userId: userId, time: time);
  }
}
