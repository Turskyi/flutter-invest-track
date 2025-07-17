import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:investtrack/application_services/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:investtrack/domain_services/exchange_rate_repository.dart';
import 'package:investtrack/domain_services/investments_repository.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:models/models.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

part 'investments_event.dart';
part 'investments_state.dart';

class InvestmentsBloc extends Bloc<InvestmentsEvent, InvestmentsState> {
  InvestmentsBloc(
    this._investmentsRepository,
    this._exchangeRateRepository,
    this._authenticationBloc,
  ) : super(const InvestmentsLoading()) {
    on<LoadInvestments>(_loadInvestments);
    on<LoadMoreInvestments>(_loadMoreInvestments);
    on<LoadInvestment>(_loadInvestment);
    on<DeleteInvestmentEvent>(_deleteInvestment);
    on<CreateInvestmentEvent>((
      CreateInvestmentEvent event,
      Emitter<InvestmentsState> emit,
    ) async {
      await _handleCreateOrUpdateInvestment(emitter: emit, event: event);
    });
    on<UpdateInvestmentEvent>((
      UpdateInvestmentEvent event,
      Emitter<InvestmentsState> emit,
    ) async {
      await _handleCreateOrUpdateInvestment(emitter: emit, event: event);
    });
  }

  final InvestmentsRepository _investmentsRepository;
  final ExchangeRateRepository _exchangeRateRepository;
  final AuthenticationBloc _authenticationBloc;

  FutureOr<void> _loadInvestments(
    LoadInvestments event,
    Emitter<InvestmentsState> emit,
  ) async {
    emit(const InvestmentsLoading());

    // Access the user ID from the AuthenticationBloc's state.
    final String userId = _authenticationBloc.state.user.id;

    if (userId.isEmpty) {
      emit(
        const UnauthenticatedInvestmentsAccessState(
          errorMessage: 'User ID not found.',
        ),
      );
      return;
    }

    try {
      // Fetch the first batch of investments using the user ID.
      final Investments investments =
          await _investmentsRepository.getInvestments(
        userId: userId,
      );

      final List<Investment> investmentBatch = investments.investments;
      final int currentPage = investments.currentPage;
      final int totalPages = investments.totalPages;
      final bool hasReachedMax = currentPage >= totalPages;

      emit(
        InvestmentsLoaded(
          investments: investmentBatch,
          hasReachedMax: hasReachedMax,
        ),
      );

      // Fetch purchase prices asynchronously.
      final List<Investment> updatedInvestmentsWithPurchasePrices =
          await Future.wait(
        investmentBatch.map((Investment investment) async {
          if (investment.isPurchased) {
            final YahooFinanceResponse response =
                await const YahooFinanceDailyReader().getDailyDTOs(
              investment.ticker,
              startDate: investment.purchaseDate,
            );
            final double purchasePrice =
                response.candlesData.firstOrNull?.close ?? 0;

            return investment.copyWith(purchasePrice: purchasePrice);
          } else {
            return investment;
          }
        }).toList(),
      );

      // Emit updated investments with current prices.
      emit(
        InvestmentsUpdated(
          investments: updatedInvestmentsWithPurchasePrices,
          hasReachedMax: hasReachedMax,
        ),
      );

      // Fetch current prices asynchronously.
      final List<Investment> updatedInvestmentsWithCurrentPrices =
          await Future.wait(
        updatedInvestmentsWithPurchasePrices.map((Investment investment) async {
          final YahooFinanceResponse response =
              await const YahooFinanceDailyReader().getDailyDTOs(
            investment.ticker,
          );
          final double currentPrice =
              response.candlesData.lastOrNull?.close ?? 0;

          return investment.copyWith(currentPrice: currentPrice);
        }).toList(),
      );

      // Emit updated investments with current prices.
      emit(
        InvestmentsUpdated(
          investments: updatedInvestmentsWithCurrentPrices,
          hasReachedMax: hasReachedMax,
        ),
      );

      // Fetch gain or loss asynchronously.
      final List<Investment> updatedInvestmentsWithGainOrLoss =
          await Future.wait(
        updatedInvestmentsWithCurrentPrices.map((Investment investment) async {
          final double? currentPrice = investment.currentPrice;
          final double? purchasePrice = investment.purchasePrice;
          if (investment.isPurchased &&
              currentPrice != null &&
              purchasePrice != null) {
            final int quantity = investment.quantity;
            final double totalValueCurrent = quantity * currentPrice;
            final double totalValuePurchase = quantity * purchasePrice;
            final double gainOrLoss = totalValueCurrent - totalValuePurchase;
            return investment.copyWith(gainOrLossUsd: gainOrLoss);
          } else {
            return investment;
          }
        }).toList(),
      );

      // Emit updated investments with current prices.
      emit(
        InvestmentsUpdated(
          investments: updatedInvestmentsWithGainOrLoss,
          hasReachedMax: hasReachedMax,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Stacktrace for an error in $runtimeType: $stackTrace.');

      if (error is DioException) {
        final int? statusCode = error.response?.statusCode;

        if (statusCode == 429) {
          emit(
            const InvestmentsError(
              errorMessage: 'Too many requests - please try again shortly.',
            ),
          );
          return;
        }

        emit(
          InvestmentsError(
            errorMessage: 'HTTP ${statusCode ?? 'Error'}: ${error.message}',
          ),
        );
      } else {
        emit(InvestmentsError(errorMessage: error.toString()));
      }
    }
  }

  Future<void> _loadMoreInvestments(
    LoadMoreInvestments event,
    Emitter<InvestmentsState> emit,
  ) async {
    if (state is InvestmentsLoaded) {
      final InvestmentsLoaded currentState = state as InvestmentsLoaded;
      if (currentState.isLoadingMore || currentState.hasReachedMax) return;
      // Access the user ID from the AuthenticationBloc's state.
      final String userId = _authenticationBloc.state.user.id;
      if (userId.isEmpty) {
        emit(
          const UnauthenticatedInvestmentsAccessState(
            errorMessage: 'User ID not found',
          ),
        );
        return;
      }
      emit(currentState.copyWith(isLoadingMore: true));

      try {
        final int nextPage =
            (currentState.investments.length ~/ constants.itemsPerPage) +
                constants.pageOffset;

        final Investments result = await _investmentsRepository.getInvestments(
          userId: userId,
          page: nextPage,
        );

        emit(
          InvestmentsLoaded(
            investments: <Investment>[
              ...currentState.investments,
              ...result.investments,
            ],
            hasReachedMax: result.currentPage >= result.totalPages,
          ),
        );
      } catch (error, stackTrace) {
        debugPrint(
          'Error while loading more.\n'
          'Stacktrace for an error in $runtimeType: $stackTrace.',
        );
        emit(InvestmentsError(errorMessage: error.toString()));
      }
    }
  }

  FutureOr<void> _loadInvestment(
    LoadInvestment event,
    Emitter<InvestmentsState> emit,
  ) async {
    final Investment investment = event.investment;
    if (state is InvestmentsLoaded) {
      emit(
        SelectedInvestmentState(
          selectedInvestment: investment,
          investments: state.investments,
          hasReachedMax: (state as InvestmentsLoaded).hasReachedMax,
        ),
      );

      emit(
        ValueLoadingState(
          selectedInvestment: investment,
          investments: state.investments,
          hasReachedMax: (state as InvestmentsLoaded).hasReachedMax,
        ),
      );
    }

    final String ticker = investment.ticker;

    final YahooFinanceResponse currentValue =
        await const YahooFinanceDailyReader().getDailyDTOs(
      ticker,
    );

    final double currentPrice = currentValue.candlesData.lastOrNull?.close ?? 0;

    if (currentPrice != 0 && state is InvestmentsLoaded) {
      emit(
        CurrentValueLoaded(
          currentPrice: currentPrice,
          selectedInvestment: investment,
          investments: state.investments,
          hasReachedMax: (state as InvestmentsLoaded).hasReachedMax,
        ),
      );
    }

    if (investment.isPurchased) {
      final double cadExchangeRate =
          await _exchangeRateRepository.getExchangeRate(
        fromCurrency: 'USD',
        toCurrency: 'CAD',
      );
      if (state is InvestmentsLoaded) {
        emit(
          ExchangeRateLoaded(
            currentPrice: currentPrice,
            selectedInvestment: investment,
            investments: state.investments,
            exchangeRate: cadExchangeRate,
            hasReachedMax: (state as InvestmentsLoaded).hasReachedMax,
          ),
        );
      }

      final YahooFinanceResponse purchaseValue =
          await const YahooFinanceDailyReader().getDailyDTOs(
        ticker,
        startDate: investment.purchaseDate,
      );
      final double purchasePrice =
          purchaseValue.candlesData.firstOrNull?.close ?? 0;

      if (purchasePrice != 0 &&
          currentPrice != 0 &&
          state is InvestmentsLoaded) {
        emit(
          InvestmentUpdated(
            purchasePrice: purchasePrice,
            selectedInvestment: investment,
            investments: state.investments,
            currentPrice: currentPrice,
            exchangeRate: cadExchangeRate,
            hasReachedMax: (state as InvestmentsLoaded).hasReachedMax,
          ),
        );
      }
    }

    final double priceChange = await _investmentsRepository.fetchPriceChange(
      ticker,
    );

    if (state is InvestmentUpdated) {
      emit(
        (state as InvestmentUpdated).copyWith(priceChange: priceChange),
      );
    } else if (state is InvestmentsLoaded) {
      emit(
        InvestmentUpdated(
          selectedInvestment: investment,
          investments: state.investments,
          currentPrice: currentPrice,
          hasReachedMax: (state as InvestmentsLoaded).hasReachedMax,
          priceChange: priceChange,
        ),
      );
    }
    final double changePercentage =
        await _investmentsRepository.fetchChangePercentage(
      ticker,
    );
    if (state is InvestmentUpdated) {
      emit(
        (state as InvestmentUpdated).copyWith(
          changePercentage: changePercentage,
        ),
      );
    }
  }

  Future<void> _handleCreateOrUpdateInvestment({
    required Emitter<InvestmentsState> emitter,
    required InvestmentsEvent event,
  }) async {
    final List<Investment> investments = List<Investment>.from(
      state.investments,
    );
    if (event is CreateInvestmentEvent) {
      if (state is InvestmentsLoaded) {
        emitter(
          CreatingInvestment(
            investments: state.investments,
            hasReachedMax: (state as InvestmentsLoaded).hasReachedMax,
          ),
        );
      }

      // Get the user ID from the authentication bloc.
      final String userId = _authenticationBloc.state.user.id;
      final Investment createdInvestment = event.investment;

      final String ticker = createdInvestment.ticker;
      final DateTime? purchaseDate = createdInvestment.purchaseDate;
      final YahooFinanceResponse currentValue =
          await const YahooFinanceDailyReader().getDailyDTOs(
        ticker,
      );

      final double currentPrice =
          currentValue.candlesData.lastOrNull?.close ?? 0;

      final int quantity = createdInvestment.quantity;
      final double totalValueCurrent = quantity * currentPrice;

      // Try to get the purchase value for the ticker.
      YahooFinanceResponse? dateValueResponse;

      try {
        dateValueResponse = await const YahooFinanceDailyReader().getDailyDTOs(
          ticker,
          startDate: purchaseDate,
        );

        // Check if the response contains valid data.
        if (dateValueResponse.candlesData.isEmpty ||
            dateValueResponse.candlesData.firstOrNull?.close == 0) {
          throw Exception(
            'No valid historical data for ticker: $ticker on $purchaseDate',
          );
        }
      } catch (e) {
        if (state is InvestmentsLoaded && purchaseDate != null) {
          // Format the purchaseDate in a user-friendly format.
          final String formattedDate =
              DateFormat('MMM dd, yyyy hh:mm a').format(
            purchaseDate,
          );
          emitter(
            InvestmentError(
              errorMessage: 'Unable to fetch historical data for ticker: '
                  '"$ticker" on $formattedDate.',
              investment: createdInvestment,
              investments: investments,
              hasReachedMax: (state as InvestmentsLoaded).hasReachedMax,
            ),
          );
        }

        // Stop further execution if the historical data fetch fails.
        return;
      }

      final double purchasePrice =
          dateValueResponse.candlesData.firstOrNull?.close ?? 0;
      final double totalValuePurchase = quantity * purchasePrice;
      final double gainOrLoss = totalValueCurrent - totalValuePurchase;

      try {
        // Create the new createdInvestment using the repository.
        final Investment newInvestment = await _investmentsRepository.create(
          Investment.create(
            ticker: ticker,
            type: createdInvestment.type,
            companyName: createdInvestment.companyName,
            stockExchange: createdInvestment.stockExchange,
            currency: createdInvestment.currency,
            description: createdInvestment.description,
            quantity: quantity,
            companyLogoUrl: createdInvestment.companyLogoUrl,
            purchaseDate: purchaseDate,
            userId: userId,
            currentPrice: currentPrice,
            gainOrLossUsd: gainOrLoss,
            totalValueOnPurchase: totalValuePurchase,
            totalCurrentValue: totalValueCurrent,
            purchasePrice: purchasePrice,
          ),
        );

        // Add the new createdInvestment to the existing list of investments.
        investments.add(newInvestment);

        if (state is InvestmentsLoaded) {
          // Emit the new state with the updated list of investments.
          emitter(
            InvestmentSubmitted(
              investment: newInvestment,
              investments: investments,
              hasReachedMax: (state as InvestmentsLoaded).hasReachedMax,
            ),
          );
        }
      } on InvestTrackException catch (error, stackTrace) {
        _handleError(
          investment: createdInvestment,
          error: error,
          stackTrace: stackTrace,
          emitter: emitter,
          investments: investments,
        );
      } catch (error, stackTrace) {
        _handleError(
          investment: createdInvestment,
          error: error,
          stackTrace: stackTrace,
          emitter: emitter,
          investments: investments,
        );
      }
    } else if (event is UpdateInvestmentEvent) {
      final Investment investment = event.investment;
      if (state is InvestmentsLoaded) {
        emitter(
          UpdatingInvestment(
            investmentId: investment.id,
            investments: state.investments,
            hasReachedMax: (state as InvestmentsLoaded).hasReachedMax,
          ),
        );
      }

      try {
        final Investment updatedInvestment =
            await _investmentsRepository.update(
          investment,
        );

        // Update the createdInvestment in the existing list of investments.
        final int index = investments.indexWhere(
          (Investment existingInvestment) =>
              existingInvestment.id == updatedInvestment.id,
        );
        if (index != -1) {
          investments[index] = updatedInvestment;
        }
        if (state is InvestmentsLoaded) {
          // Emit the new state with the updated list of investments.
          emitter(
            InvestmentSubmitted(
              investment: updatedInvestment,
              investments: investments,
              hasReachedMax: (state as InvestmentsLoaded).hasReachedMax,
            ),
          );
        }
      } on InvestTrackException catch (error, stackTrace) {
        _handleError(
          investment: investment,
          error: error,
          stackTrace: stackTrace,
          emitter: emitter,
          investments: investments,
        );
      } catch (error, stackTrace) {
        _handleError(
          investment: investment,
          error: error,
          stackTrace: stackTrace,
          emitter: emitter,
          investments: investments,
        );
      }
    }
  }

  FutureOr<void> _deleteInvestment(
    DeleteInvestmentEvent event,
    Emitter<InvestmentsState> emit,
  ) async {
    final Investment investment = event.investment;

    if (state is InvestmentsLoaded) {
      emit(
        InvestmentDeleting(
          investmentId: investment.id,
          investments: state.investments,
          hasReachedMax: (state as InvestmentsLoaded).hasReachedMax,
        ),
      );
    }

    // Get the user ID from the authentication bloc.
    final String userId = _authenticationBloc.state.user.id;

    if (userId.isEmpty) {
      emit(
        const UnauthenticatedInvestmentsAccessState(
          errorMessage: 'User ID not found.',
        ),
      );
      return;
    }

    final MessageResponse response = await _investmentsRepository.delete(
      investment.copyWith(userId: userId),
    );
    // Remove the investment from the existing list of investments.
    final List<Investment> updatedInvestments =
        List<Investment>.from(state.investments)..remove(investment);

    if (state is InvestmentsLoaded) {
      // Emit the new state with the updated list of investments.
      emit(
        InvestmentDeleted(
          investment: investment,
          message: response.message,
          investments: updatedInvestments,
          hasReachedMax: (state as InvestmentsLoaded).hasReachedMax,
        ),
      );
    }
  }

  void _handleError({
    required Investment investment,
    required Object error,
    required StackTrace stackTrace,
    required Emitter<InvestmentsState> emitter,
    required List<Investment> investments,
  }) {
    debugPrint(
      'Error while creating investment: '
      '${error.runtimeType}, $error,\n'
      'stack trace: $stackTrace',
    );
    if (state is InvestmentsLoaded) {
      emitter(
        InvestmentError(
          investments: investments,
          errorMessage: '$error',
          investment: investment,
          hasReachedMax: (state as InvestmentsLoaded).hasReachedMax,
        ),
      );
    }
  }
}
