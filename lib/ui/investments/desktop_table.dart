import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:models/models.dart';

//TODO: maybe use this eventually for desktop.
class DesktopTable extends StatelessWidget {
  const DesktopTable({this.investments = const <Investment>[], super.key});

  final List<Investment> investments;

  @override
  Widget build(BuildContext context) {
    LocalizationProvider.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 80, 16, 80),
      child: DataTable(
        columns: <DataColumn>[
          DataColumn(label: Text(translate('desktop_table.company'))),
          DataColumn(label: Text(translate('desktop_table.stock_exchange'))),
          DataColumn(label: Text(translate('desktop_table.ticker'))),
          DataColumn(label: Text(translate('desktop_table.current_price'))),
          DataColumn(label: Text(translate('desktop_table.currency'))),
          DataColumn(label: Text(translate('desktop_table.price_change'))),
          DataColumn(label: Text(translate('desktop_table.percent_change'))),
          DataColumn(label: Text(translate('desktop_table.quantity'))),
          DataColumn(
            label: Text(translate('desktop_table.total_current_value_usd')),
          ),
          DataColumn(
            label: Text(translate('desktop_table.total_value_current_cad')),
          ),
          DataColumn(
            label: Text(translate('desktop_table.total_value_purchase_usd')),
          ),
          DataColumn(
            label: Text(translate('desktop_table.total_value_purchase_cad')),
          ),
          DataColumn(label: Text(translate('desktop_table.price_on_purchase'))),
          DataColumn(label: Text(translate('desktop_table.gain_loss_usd'))),
          DataColumn(label: Text(translate('desktop_table.gain_loss_cad'))),
        ],
        rows: investments.map((Investment investment) {
          return DataRow(
            cells: <DataCell>[
              DataCell(Text(investment.companyName)),
              DataCell(Text(investment.stockExchange)),
              DataCell(Text(investment.ticker)),
              const DataCell(
                Text('TODO: dynamically calculate the "currentPrice"'),
              ),
              DataCell(Text(investment.currency)),
              const DataCell(
                Text('TODO: dynamically calculate the "priceChange"'),
              ),
              const DataCell(
                Text('TODO: dynamically calculate the "percentChange"'),
              ),
              DataCell(Text(investment.quantity.toString())),
              DataCell(Text(investment.totalCurrentValue?.toString() ?? 'N/A')),
              const DataCell(
                Text('TODO: dynamically calculate the "totalValueCurrentCAD"'),
              ),
              DataCell(
                Text(investment.totalValueOnPurchase?.toString() ?? 'N/A'),
              ),
              const DataCell(
                Text(
                  'TODO: dynamically calculate the "totalValueOnPurchaseCAD"',
                ),
              ),
              DataCell(Text(investment.purchasePrice?.toString() ?? 'N/A')),
              DataCell(Text(investment.gainOrLossUsd?.toString() ?? 'N/A')),
              DataCell(Text(investment.gainOrLossCad?.toString() ?? 'N/A')),
            ],
          );
        }).toList(),
      ),
    );
  }
}
