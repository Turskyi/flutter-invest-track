import 'package:flutter/material.dart';
import 'package:models/models.dart';

//TODO: maybe use this eventually for desktop.
class DesktopTable extends StatelessWidget {
  const DesktopTable({this.investments = const <Investment>[], super.key});

  final List<Investment> investments;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16.0,
        80,
        16,
        80,
      ),
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(label: Text('Company')),
          DataColumn(label: Text('Stock Exchange')),
          DataColumn(label: Text('Ticker')),
          DataColumn(label: Text('Current Price')),
          DataColumn(label: Text('Currency')),
          DataColumn(label: Text('Price Change')),
          DataColumn(label: Text('% Change')),
          DataColumn(label: Text('Quantity')),
          DataColumn(label: Text('Total Current Value \$')),
          DataColumn(label: Text('Total Value Current CAD')),
          DataColumn(label: Text('Total Value on Purchase Date \$')),
          DataColumn(label: Text('Total Value on Purchase Date CAD')),
          DataColumn(label: Text('Price on Purchase Date')),
          DataColumn(label: Text('Gain or Loss for Stock \$')),
          DataColumn(label: Text('Gain or Loss for Stock in CAD')),
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
