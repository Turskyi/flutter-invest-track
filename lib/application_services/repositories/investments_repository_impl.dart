import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:injectable/injectable.dart';
import 'package:investtrack/domain_services/investments_repository.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable(as: InvestmentsRepository)
class InvestmentsRepositoryImpl implements InvestmentsRepository {
  const InvestmentsRepositoryImpl(this._restClient, this._preferences);

  final RestClient _restClient;
  final SharedPreferences _preferences;

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

      return response.investment;
    } catch (error) {
      if (error is DioError) {
        // Try to parse the error message from the response body.
        final Object? responseData = error.response?.data;

        if (responseData is String) {
          // If the response is a raw JSON string, parse it
          final Map<String, dynamic> parsedData = json.decode(responseData);
          throw Exception(parsedData['error'] ?? 'Unknown error occurred');
        } else if (responseData is Map<String, dynamic>) {
          // Try to convert the responseData to InvestTrackError using fromJson.
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
  Future<MessageResponse> delete(Investment investment) {
    final String userId = _preferences.getString(StorageKeys.userId.key) ?? '';
    if (userId.isNotEmpty || userId == investment.userId) {
      return _restClient.deleteInvestment(userId, investment.id);
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
      return response.investment;
    } catch (error) {
      if (error is DioError) {
        // Try to parse the error message from the response body.
        final Object? responseData = error.response?.data;

        if (responseData is String) {
          // If the response is a raw JSON string, parse it
          final Map<String, dynamic> parsedData = json.decode(responseData);
          throw Exception(parsedData['error'] ?? 'Unknown error occurred');
        } else if (responseData is Map<String, dynamic>) {
          // Try to convert the responseData to InvestTrackError using fromJson.
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
}
