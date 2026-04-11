import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:investtrack/ui/widgets/horizontal_overflow_indicator.dart';
import 'package:investtrack/utils/price_utils.dart';
import 'package:models/models.dart';

class DesktopTable extends StatefulWidget {
  const DesktopTable({
    this.investments = const <Investment>[],
    this.showLoader = false,
    this.canLoadMore = false,
    this.onLoadMore,
    this.onInvestmentTap,
    super.key,
  });

  final List<Investment> investments;
  final bool showLoader;
  final bool canLoadMore;
  final VoidCallback? onLoadMore;
  final ValueChanged<Investment>? onInvestmentTap;

  @override
  State<DesktopTable> createState() => _DesktopTableState();
}

class _DesktopTableState extends State<DesktopTable> {
  static const double _loadMoreThreshold = 120;

  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();
  int _lastLoadMoreRequestedAtCount = -1;

  String get _notAvailableLabel => translate('desktop_table.not_available');

  @override
  void initState() {
    super.initState();
    _verticalScrollController.addListener(_onVerticalScroll);
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      _requestMoreWhenNotScrollable();
    });
  }

  @override
  void didUpdateWidget(covariant DesktopTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.investments.length != widget.investments.length) {
      WidgetsBinding.instance.addPostFrameCallback((Duration _) {
        _requestMoreWhenNotScrollable();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    LocalizationProvider.of(context);
    final ThemeData themeData = Theme.of(context);
    final TextStyle headingTextStyle =
        (themeData.textTheme.titleSmall ?? const TextStyle()).copyWith(
          color: themeData.colorScheme.onPrimary,
        );
    return SingleChildScrollView(
      controller: _verticalScrollController,
      padding: const EdgeInsets.only(top: 80, bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    showCheckboxColumn: false,
                    columnSpacing: 24,
                    headingTextStyle: headingTextStyle,
                    columns: <DataColumn>[
                      const DataColumn(label: SizedBox.shrink()),
                      DataColumn(
                        label: Text(translate('desktop_table.company')),
                      ),
                      DataColumn(
                        label: Text(translate('desktop_table.stock_exchange')),
                      ),
                      DataColumn(
                        label: Text(translate('desktop_table.ticker')),
                      ),
                      DataColumn(
                        label: Text(translate('desktop_table.current_price')),
                      ),
                      DataColumn(
                        label: Text(translate('desktop_table.currency')),
                      ),
                      DataColumn(
                        label: Text(translate('desktop_table.price_change')),
                      ),
                      DataColumn(
                        label: Text(translate('desktop_table.percent_change')),
                      ),
                      DataColumn(
                        label: Text(translate('desktop_table.quantity')),
                      ),
                      DataColumn(
                        label: Text(
                          translate('desktop_table.total_current_value_usd'),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          translate('desktop_table.total_value_purchase_usd'),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          translate('desktop_table.price_on_purchase'),
                        ),
                      ),
                      DataColumn(
                        label: Text(translate('desktop_table.gain_loss_usd')),
                      ),
                      DataColumn(
                        label: Text(translate('desktop_table.gain_loss_cad')),
                      ),
                      DataColumn(
                        label: Text(translate('desktop_table.purchase_date')),
                      ),
                    ],
                    rows: widget.investments.map(_buildRow).toList(),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: HorizontalOverflowIndicator(
                  controller: _horizontalScrollController,
                ),
              ),
            ],
          ),
          if (widget.showLoader)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _verticalScrollController
      ..removeListener(_onVerticalScroll)
      ..dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _onVerticalScroll() {
    if (!_canRequestMoreData || !_verticalScrollController.hasClients) {
      return;
    } else {
      final ScrollPosition position = _verticalScrollController.position;
      final bool reachedBottom =
          position.pixels >= position.maxScrollExtent - _loadMoreThreshold;
      if (reachedBottom) {
        _requestMore();
      }
    }
  }

  void _requestMoreWhenNotScrollable() {
    if (!_canRequestMoreData || !_verticalScrollController.hasClients) {
      return;
    } else {
      final ScrollPosition position = _verticalScrollController.position;
      if (position.maxScrollExtent <= 0) {
        _requestMore();
      }
    }
  }

  bool get _canRequestMoreData {
    return widget.canLoadMore &&
        widget.onLoadMore != null &&
        _lastLoadMoreRequestedAtCount != widget.investments.length;
  }

  void _requestMore() {
    _lastLoadMoreRequestedAtCount = widget.investments.length;
    widget.onLoadMore?.call();
  }

  DataRow _buildRow(Investment investment) {
    final double? currentPrice = investment.currentPrice;
    final double? purchasePrice = investment.purchasePrice;
    final double? totalCurrentValue =
        investment.totalCurrentValue ??
        (currentPrice != null ? investment.quantity * currentPrice : null);
    final double? totalValueOnPurchase =
        investment.totalValueOnPurchase ??
        (purchasePrice != null && investment.quantity > 0
            ? investment.quantity * purchasePrice
            : null);

    final double? priceChange = currentPrice != null && purchasePrice != null
        ? currentPrice - purchasePrice
        : null;
    final double? percentChange =
        priceChange != null && purchasePrice != null && purchasePrice != 0
        ? (priceChange / purchasePrice) * 100
        : null;
    final double? gainOrLossUsd = investment.gainOrLossUsd;
    final double? gainOrLossCad = investment.gainOrLossCad;
    final DateTime? purchaseDate = investment.purchaseDate;

    return DataRow(
      onSelectChanged: widget.onInvestmentTap != null
          ? (bool? _) => widget.onInvestmentTap!(investment)
          : null,
      cells: <DataCell>[
        DataCell(
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: investment.companyLogoUrl.isNotEmpty
                ? NetworkImage(investment.companyLogoUrl)
                : const AssetImage(
                    '${constants.imagePath}company-logo-placeholder.jpeg',
                  ),
            radius: 16,
          ),
        ),
        DataCell(SelectableText(investment.companyName)),
        DataCell(Text(investment.stockExchange)),
        DataCell(SelectableText(investment.ticker)),
        DataCell(
          Text(
            formatPriceByCode(
              price: currentPrice,
              currencyCode: investment.currency,
            ),
          ),
        ),
        DataCell(Text(investment.currency)),
        DataCell(
          Text(
            _formatChange(priceChange),
            style: TextStyle(
              color: _changeColor(priceChange),
              fontWeight: priceChange != null ? FontWeight.bold : null,
            ),
          ),
        ),
        DataCell(
          Text(
            _formatPercentChange(percentChange),
            style: TextStyle(
              color: _changeColor(percentChange),
              fontWeight: percentChange != null ? FontWeight.bold : null,
            ),
          ),
        ),
        DataCell(Text(investment.quantity.toString())),
        DataCell(
          Text(
            totalCurrentValue != null
                ? '\$${totalCurrentValue.toStringAsFixed(2)}'
                : _notAvailableLabel,
          ),
        ),
        DataCell(
          Text(
            totalValueOnPurchase != null
                ? '\$${totalValueOnPurchase.toStringAsFixed(2)}'
                : _notAvailableLabel,
          ),
        ),
        DataCell(
          Text(
            _formatPurchasePrice(
              purchasePrice: purchasePrice,
              purchaseDate: purchaseDate,
              quantity: investment.quantity,
              currency: investment.currency,
            ),
          ),
        ),
        DataCell(
          Text(
            gainOrLossUsd != null
                ? '\$${gainOrLossUsd.toStringAsFixed(2)}'
                : _notAvailableLabel,
            style: TextStyle(
              color: _changeColor(gainOrLossUsd),
              fontWeight: gainOrLossUsd != null ? FontWeight.bold : null,
            ),
          ),
        ),
        DataCell(
          Text(
            gainOrLossCad != null
                ? 'CAD ${gainOrLossCad.toStringAsFixed(2)}'
                : _notAvailableLabel,
            style: TextStyle(
              color: _changeColor(gainOrLossCad),
              fontWeight: gainOrLossCad != null ? FontWeight.bold : null,
            ),
          ),
        ),
        DataCell(
          Text(
            purchaseDate != null && investment.quantity > 0
                ? purchaseDate.toLocal().toString().split(' ').first
                : _notAvailableLabel,
          ),
        ),
      ],
    );
  }

  String _formatChange(double? change) {
    if (change == null) {
      return _notAvailableLabel;
    } else {
      final String prefix = change >= 0 ? '+' : '';
      return '$prefix${change.toStringAsFixed(2)}';
    }
  }

  String _formatPercentChange(double? percent) {
    if (percent == null) {
      return _notAvailableLabel;
    } else {
      final String prefix = percent >= 0 ? '+' : '';
      return '$prefix${percent.toStringAsFixed(2)}%';
    }
  }

  String _formatPurchasePrice({
    required double? purchasePrice,
    required DateTime? purchaseDate,
    required num quantity,
    required String currency,
  }) {
    if (purchaseDate == null || quantity <= 0) {
      return _notAvailableLabel;
    } else {
      return formatPriceByCode(price: purchasePrice, currencyCode: currency);
    }
  }

  Color? _changeColor(double? value) {
    if (value == null) return null;
    return value >= 0 ? Colors.green : Colors.red;
  }
}
