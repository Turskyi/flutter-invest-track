import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:investtrack/infrastructure/investment_import_data.dart';

/// A subtitle widget for a single stock row in the import review list.
///
/// Displays exchange, currency, quantity (or watchlist label), investment type,
/// and portfolio snapshot date in a single line.
class StockSubtitle extends StatelessWidget {
  const StockSubtitle({required this.item, super.key});

  final InvestmentImportData item;

  @override
  Widget build(BuildContext context) {
    final String exchange = item.stockExchange.isNotEmpty
        ? item.stockExchange
        : '—';
    final String quantity = item.quantity > 0
        ? '${item.quantity} ${translate('import.shares_suffix')}'
        : translate('import.watchlist_label');
    final String type = item.type ?? '—';
    final String date = item.purchaseDate != null
        ? DateFormat('MMM d, y').format(item.purchaseDate!)
        : '—';
    return Text(
      '$exchange  |  ${item.currency}  |  $quantity  |  $type  |  $date',
    );
  }
}
