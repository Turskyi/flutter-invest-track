import 'dart:async';
import 'dart:io';

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

/// Bloc responsible for managing all investment-related state.
///
/// ⚠️ Important usage notes:
/// - This bloc emits multiple intermediate states (`InvestmentsUpdated`)
///   while fetching investments (purchase price → current price → gain/loss).
///   That means UI will rebuild multiple times unless filtered.
/// - When reusing this bloc across multiple screens (e.g. list + details),
///   you **must** use `buildWhen` (or similar filtering) to ignore
///   intermediate states that do not belong to the current screen.
///   Example:
///   ```dart
///   BlocBuilder<InvestmentsBloc, InvestmentsState>(
///     buildWhen: (InvestmentsState _, InvestmentsState current) =>
///         current is! InvestmentsUpdated && current is! InvestmentsError,
///   )
///   ```
/// - Attempting to split this bloc into “list” and “details” blocs was
///   tried before, but led to more complexity (state duplication,
///   synchronization issues). Keeping one shared bloc and filtering
///   unwanted states is simpler and recommended.
///
/// TL;DR: Reuse one bloc across screens, but filter states where needed.
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
    on<CreateInvestmentEvent>(_createInvestment);
    on<UpdateInvestmentEvent>(_updateInvestment);
  }

  final InvestmentsRepository _investmentsRepository;
  final ExchangeRateRepository _exchangeRateRepository;
  final AuthenticationBloc _authenticationBloc;

  FutureOr<void> _updateInvestment(
    UpdateInvestmentEvent event,
    Emitter<InvestmentsState> emit,
  ) async {
    await _handleCreateOrUpdateInvestment(emitter: emit, event: event);
  }

  FutureOr<void> _loadInvestments(
    LoadInvestments event,
    Emitter<InvestmentsState> emit,
  ) async {
    emit(const InvestmentsLoading());

    final String userId = _authenticationBloc.state.userId;
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
      final Investments investments = await _investmentsRepository
          .getInvestments(userId: userId);

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

      // --- STEP 1: Ensure purchase prices are cached ---
      final List<Investment> updatedInvestmentsWithPurchasePrices =
          <Investment>[];
      for (final Investment investment in investmentBatch) {
        final bool hasNoPurchasePrice =
            investment.purchasePrice == null || investment.purchasePrice == 0;
        if (investment.isPurchased && hasNoPurchasePrice) {
          final String investmentTicker = investment.ticker;
          try {
            final YahooFinanceResponse response =
                await _retryWithBackoff<YahooFinanceResponse>(() {
                  return const YahooFinanceDailyReader().getDailyDTOs(
                    investmentTicker,
                    startDate: investment.purchaseDate,
                  );
                });

            final double purchasePrice =
                response.candlesData.firstOrNull?.close ?? 0;

            updatedInvestmentsWithPurchasePrices.add(
              investment.copyWith(purchasePrice: purchasePrice),
            );
          } catch (e, stackTrace) {
            debugPrint(
              'Error while fetching purchase price for ticker: '
              '$investmentTicker.\n'
              'Error: $e\n'
              'Stacktrace: $stackTrace.',
            );
            // Fallback to original.
            updatedInvestmentsWithPurchasePrices.add(investment);
          }
        } else {
          updatedInvestmentsWithPurchasePrices.add(investment);
        }
      }

      emit(
        InvestmentsUpdated(
          investments: updatedInvestmentsWithPurchasePrices,
          hasReachedMax: hasReachedMax,
        ),
      );

      // --- STEP 2: Throttle current price requests ---
      final List<Investment> updatedInvestmentsWithCurrentPrices =
          <Investment>[];
      for (int i = 0; i < updatedInvestmentsWithPurchasePrices.length; i++) {
        final Investment investment = updatedInvestmentsWithPurchasePrices[i];
        final String ticker = investment.ticker;
        try {
          final YahooFinanceResponse currentValueResponse =
              await _retryWithBackoff<YahooFinanceResponse>(() {
                return const YahooFinanceDailyReader().getDailyDTOs(ticker);
              });

          final double currentPrice =
              currentValueResponse.candlesData.lastOrNull?.close ?? 0;

          updatedInvestmentsWithCurrentPrices.add(
            investment.copyWith(currentPrice: currentPrice),
          );
        } catch (e, stackTrace) {
          debugPrint(
            'Error while fetching current price for ticker: '
            '$ticker.\n'
            'Error: $e\n'
            'Stacktrace: $stackTrace.',
          );
          // Fallback.
          updatedInvestmentsWithCurrentPrices.add(investment);
        }
      }

      // Emit updated investments with current prices.
      emit(
        InvestmentsUpdated(
          investments: updatedInvestmentsWithCurrentPrices,
          hasReachedMax: hasReachedMax,
        ),
      );

      // --- STEP 3: Calculate gain/loss ---
      final List<Investment> updatedInvestmentsWithGainOrLoss =
          updatedInvestmentsWithCurrentPrices.map((Investment investment) {
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
          }).toList();

      emit(
        InvestmentsUpdated(
          investments: updatedInvestmentsWithGainOrLoss,
          hasReachedMax: hasReachedMax,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Error $error. Stacktrace for an error in $runtimeType: $stackTrace.',
      );

      if (error is DioException) {
        final int? statusCode = error.response?.statusCode;
        if (statusCode == HttpStatus.tooManyRequests) {
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
    final InvestmentsState currentState = state;
    if (currentState is InvestmentsLoaded && currentState.canLoadMore) {
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
    final InvestmentsState currentState = state;

    if (currentState is InvestmentsLoaded) {
      emit(
        SelectedInvestmentState(
          selectedInvestment: investment,
          investments: currentState.investments,
          hasReachedMax: currentState.hasReachedMax,
        ),
      );

      final InvestmentsState selectedInvestmentsState = state;

      if (selectedInvestmentsState is SelectedInvestmentState) {
        emit(
          ValueLoadingState(
            selectedInvestment: investment,
            investments: selectedInvestmentsState.investments,
            hasReachedMax: selectedInvestmentsState.hasReachedMax,
          ),
        );
      }
    }

    final String ticker = investment.ticker;
    double currentPrice = investment.currentPrice ?? 0;
    try {
      if (currentPrice == 0) {
        final YahooFinanceResponse currentValue =
            await _retryWithBackoff<YahooFinanceResponse>(() {
              return const YahooFinanceDailyReader().getDailyDTOs(ticker);
            });

        currentPrice = currentValue.candlesData.lastOrNull?.close ?? 0;
      }

      final InvestmentsState investmentsState = state;

      if (currentPrice != 0 && investmentsState is InvestmentsLoaded) {
        emit(
          CurrentValueLoaded(
            currentPrice: currentPrice,
            selectedInvestment: investment,
            investments: investmentsState.investments,
            hasReachedMax: investmentsState.hasReachedMax,
          ),
        );
      }

      if (investment.isPurchased) {
        final double cadExchangeRate = await _exchangeRateRepository
            .getExchangeRate(
              fromCurrency: CurrencyCode.usd.value,
              toCurrency: CurrencyCode.cad.value,
            );
        final InvestmentsState investmentsState = state;

        if (investmentsState is InvestmentsLoaded) {
          emit(
            ExchangeRateLoaded(
              currentPrice: currentPrice,
              selectedInvestment: investment,
              investments: investmentsState.investments,
              exchangeRate: cadExchangeRate,
              hasReachedMax: investmentsState.hasReachedMax,
            ),
          );
        }

        double purchasePrice = investment.purchasePrice ?? 0;

        if (purchasePrice == 0) {
          final YahooFinanceResponse purchaseValue =
              await _retryWithBackoff<YahooFinanceResponse>(() {
                return const YahooFinanceDailyReader().getDailyDTOs(
                  ticker,
                  startDate: investment.purchaseDate,
                );
              });

          purchasePrice = purchaseValue.candlesData.firstOrNull?.close ?? 0;
        }

        final InvestmentsState investmentsState2 = state;

        if (purchasePrice != 0 &&
            currentPrice != 0 &&
            investmentsState2 is InvestmentsLoaded) {
          emit(
            InvestmentUpdated(
              purchasePrice: purchasePrice,
              selectedInvestment: investment,
              investments: investmentsState2.investments,
              currentPrice: currentPrice,
              exchangeRate: cadExchangeRate,
              hasReachedMax: investmentsState2.hasReachedMax,
            ),
          );
        }
      }

      final double priceChange = await _investmentsRepository.fetchPriceChange(
        ticker,
      );

      final InvestmentsState investmentsState3 = state;

      if (investmentsState3 is InvestmentUpdated) {
        emit(investmentsState3.copyWith(priceChange: priceChange));
      } else if (investmentsState3 is InvestmentsLoaded) {
        emit(
          InvestmentUpdated(
            selectedInvestment: investment,
            investments: investmentsState3.investments,
            currentPrice: currentPrice,
            hasReachedMax: investmentsState3.hasReachedMax,
            priceChange: priceChange,
          ),
        );
      }
    } catch (e, s) {
      debugPrint(
        'Error while fetching current price for ticker: '
        '$ticker.\n'
        'Error: $e\n'
        'Stacktrace: $s.',
      );
    }

    //TODO: handle error and emit InvestmentError state.
    final double changePercentage = await _investmentsRepository
        .fetchChangePercentage(ticker);
    final InvestmentsState investmentsState4 = state;

    if (investmentsState4 is InvestmentUpdated) {
      emit(investmentsState4.copyWith(changePercentage: changePercentage));
    } else if (investmentsState4 is InvestmentsLoaded) {
      emit(
        InvestmentUpdated(
          selectedInvestment: investment,
          investments: investmentsState4.investments,
          currentPrice: currentPrice,
          hasReachedMax: investmentsState4.hasReachedMax,
          priceChange: changePercentage,
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
      final InvestmentsState currentState = state;
      if (currentState is InvestmentsLoaded) {
        emitter(
          CreatingInvestment(
            investments: currentState.investments,
            hasReachedMax: currentState.hasReachedMax,
          ),
        );
      }

      // Get the user ID from the authentication bloc.
      final String userId = _authenticationBloc.state.user.id;
      final Investment createdInvestment = event.investment;

      final String ticker = createdInvestment.ticker;
      final DateTime? purchaseDate = createdInvestment.purchaseDate;

      final YahooFinanceResponse currentValue =
          await _retryWithBackoff<YahooFinanceResponse>(() {
            return const YahooFinanceDailyReader().getDailyDTOs(ticker);
          });

      final double currentPrice =
          currentValue.candlesData.lastOrNull?.close ?? 0;

      final int quantity = createdInvestment.quantity;
      final double totalValueCurrent = quantity * currentPrice;

      try {
        final YahooFinanceResponse dateValueResponse =
            await _retryWithBackoff<YahooFinanceResponse>(() {
              return const YahooFinanceDailyReader().getDailyDTOs(
                ticker,
                startDate: purchaseDate,
              );
            });

        // Check if the response contains valid data.
        if (dateValueResponse.candlesData.isEmpty ||
            dateValueResponse.candlesData.firstOrNull?.close == 0) {
          throw Exception(
            'No valid historical data for ticker: $ticker on $purchaseDate',
          );
        }

        final double purchasePrice =
            dateValueResponse.candlesData.firstOrNull?.close ?? 0;
        final double totalValuePurchase = quantity * purchasePrice;
        final double gainOrLoss = totalValueCurrent - totalValuePurchase;

        try {
          // Create the new `createdInvestment` using the repository.
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

          // Add the new `createdInvestment` to the existing list of
          // investments.
          investments.add(newInvestment);
          final InvestmentsState currentState = state;
          if (currentState is InvestmentsLoaded) {
            // Emit the new state with the updated list of investments.
            emitter(
              InvestmentSubmitted(
                investment: newInvestment,
                investments: investments,
                hasReachedMax: currentState.hasReachedMax,
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
      } catch (e) {
        final InvestmentsState currentState = state;
        if (currentState is InvestmentsLoaded && purchaseDate != null) {
          // Format the purchaseDate in a user-friendly format.
          final String formattedDate = DateFormat(
            'MMM dd, yyyy hh:mm a',
          ).format(purchaseDate);

          emitter(
            InvestmentError(
              errorMessage:
                  'Unable to fetch historical data for ticker: '
                  '"$ticker" on $formattedDate.',
              investment: createdInvestment,
              investments: investments,
              hasReachedMax: currentState.hasReachedMax,
            ),
          );
        }
      }
    } else if (event is UpdateInvestmentEvent) {
      final Investment investment = event.investment;
      final InvestmentsState currentState = state;
      if (currentState is InvestmentsLoaded) {
        emitter(
          UpdatingInvestment(
            investmentId: investment.id,
            investments: currentState.investments,
            hasReachedMax: currentState.hasReachedMax,
          ),
        );
      }

      try {
        final Investment updatedInvestment = await _investmentsRepository
            .update(investment);

        // Update the createdInvestment in the existing list of investments.
        final int index = investments.indexWhere((
          Investment existingInvestment,
        ) {
          return existingInvestment.id == updatedInvestment.id;
        });

        if (index != -1) {
          investments[index] = updatedInvestment;
        }

        final InvestmentsState currentState = state;
        if (currentState is InvestmentsLoaded) {
          // Emit the new state with the updated list of investments.
          emitter(
            InvestmentSubmitted(
              investment: updatedInvestment,
              investments: investments,
              hasReachedMax: currentState.hasReachedMax,
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
    final InvestmentsState currentState = state;
    if (currentState is InvestmentsLoaded) {
      emit(
        InvestmentDeleting(
          investmentId: investment.id,
          investments: currentState.investments,
          hasReachedMax: currentState.hasReachedMax,
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
    final List<Investment> updatedInvestments = List<Investment>.from(
      state.investments,
    )..remove(investment);

    final InvestmentsState investmentsState = state;
    if (investmentsState is InvestmentsLoaded) {
      // Emit the new state with the updated list of investments.
      emit(
        InvestmentDeleted(
          investment: investment,
          message: response.message,
          investments: updatedInvestments,
          hasReachedMax: investmentsState.hasReachedMax,
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
    final InvestmentsState currentState = state;
    if (currentState is InvestmentsLoaded) {
      emitter(
        InvestmentError(
          investments: investments,
          errorMessage: '$error',
          investment: investment,
          hasReachedMax: currentState.hasReachedMax,
        ),
      );
    }
  }

  FutureOr<void> _createInvestment(
    CreateInvestmentEvent event,
    Emitter<InvestmentsState> emit,
  ) async {
    await _handleCreateOrUpdateInvestment(emitter: emit, event: event);
  }

  Future<T> _retryWithBackoff<T>(
    Future<T> Function() request, {
    int maxRetries = 5,
    Duration initialDelay = const Duration(milliseconds: 200),
  }) async {
    Duration delay = initialDelay;
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        return await request();
      } on DioException catch (e) {
        if (e.response?.statusCode == HttpStatus.tooManyRequests) {
          await Future<void>.delayed(delay);
          // Exponential backoff.
          delay *= 2;
        } else {
          rethrow;
        }
      }
    }
    throw Exception('Max retries exceeded');
  }
}
