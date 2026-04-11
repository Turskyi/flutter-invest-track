import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:investtrack/infrastructure/investment_import_data.dart';
import 'package:investtrack/infrastructure/xlsx_service.dart';

/// Builds a minimal in-memory XLSX workbook for use in tests.
///
/// The workbook always contains:
/// - A portfolio sheet called "Jun 2 2023" with two data rows:
///   - "AAPL" / "Apple Inc" / NASDAQ / USD / qty 10 — cell A coloured with
///     the Technology legend colour (FF7E3794).
///   - "NVDA" / "NVIDIA Corporation" (stored as a [FormulaCellValue]) / NASDAQ /
///     USD / qty 30 — no background colour (type should be null).
///   - Column K header: "Total Value on Jun 2 2023 in $" (snapshot date).
/// - A "Google Finance Data" legend sheet mapping FF7E3794 → "Technology".
/// - Optionally a "List" watchlist sheet containing ticker "AC" which must
///   be skipped during import.
Uint8List _buildTestXlsx({bool includeListSheet = true}) {
  final Excel excel = Excel.createExcel();
  excel.delete('Sheet1');

  // ── Google Finance Data sheet (colour legend) ──────────────────────────
  final Sheet legendSheet = excel['Google Finance Data'];
  final Data swatchCell = legendSheet.cell(
    CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0),
  );
  swatchCell.value = TextCellValue('');
  swatchCell.cellStyle = CellStyle(
    backgroundColorHex: ExcelColor.fromHexString('FF7E3794'),
  );
  legendSheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0))
      .value = TextCellValue(
    '- Technology',
  );

  // ── Portfolio sheet ────────────────────────────────────────────────────
  final Sheet portfolioSheet = excel['Jun 2 2023'];

  // Header row (row 0).
  portfolioSheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
      .value = TextCellValue(
    'Company',
  );
  portfolioSheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
      .value = TextCellValue(
    'Ticker',
  );
  portfolioSheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0))
      .value = TextCellValue(
    'Stock Exchange',
  );
  portfolioSheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0))
      .value = TextCellValue(
    'Currency',
  );
  portfolioSheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0))
      .value = TextCellValue(
    'Quantity',
  );
  // Column K (index 10) contains the snapshot date.
  portfolioSheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: 0))
      .value = TextCellValue(
    r'Total Value on Jun 2 2023 in $',
  );

  // Data row 1 – AAPL, Technology colour.
  final Data aaplCell = portfolioSheet.cell(
    CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1),
  );
  aaplCell.value = TextCellValue('Apple Inc');
  aaplCell.cellStyle = CellStyle(
    backgroundColorHex: ExcelColor.fromHexString('FF7E3794'),
  );
  portfolioSheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1))
      .value = TextCellValue(
    'AAPL',
  );
  portfolioSheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 1))
      .value = TextCellValue(
    'NASDAQ',
  );
  portfolioSheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 1))
      .value = TextCellValue(
    'USD',
  );
  portfolioSheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 1))
      .value = const IntCellValue(
    10,
  );

  // Data row 2 - NVDA, company name stored as a FormulaCellValue (mirrors
  // real spreadsheets that use GOOGLEFINANCE formulas), no type colour.
  portfolioSheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 2))
      .value = const FormulaCellValue(
    'NVIDIA Corporation',
  );
  portfolioSheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 2))
      .value = TextCellValue(
    'NVDA',
  );
  portfolioSheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 2))
      .value = TextCellValue(
    'NASDAQ',
  );
  portfolioSheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 2))
      .value = TextCellValue(
    'USD',
  );
  portfolioSheet
      .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 2))
      .value = const IntCellValue(
    30,
  );

  // ── "List" watchlist sheet (must be skipped) ───────────────────────────
  if (includeListSheet) {
    final Sheet listSheet = excel['List'];
    listSheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
        .value = TextCellValue(
      'Company',
    );
    listSheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
        .value = TextCellValue(
      'Ticker',
    );
    listSheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1))
        .value = TextCellValue(
      'Air Canada',
    );
    listSheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1))
        .value = TextCellValue(
      'AC',
    );
  }

  return Uint8List.fromList(excel.save()!);
}

void main() {
  final XlsxService service = XlsxService();

  group('XlsxService.parseBytes', () {
    test('returns tickers from the portfolio sheet', () {
      final List<InvestmentImportData> results = service.parseBytes(
        _buildTestXlsx(),
      );

      final List<String> tickers = results
          .map((InvestmentImportData r) => r.ticker)
          .toList();
      expect(tickers, containsAll(<String>['AAPL', 'NVDA']));
    });

    test('skips watchlist sheets ("List", "Multi")', () {
      final List<InvestmentImportData> results = service.parseBytes(
        _buildTestXlsx(includeListSheet: true),
      );

      final List<String> tickers = results
          .map((InvestmentImportData r) => r.ticker)
          .toList();
      expect(tickers, isNot(contains('AC')));
    });

    test('parses quantity correctly for each row', () {
      final List<InvestmentImportData> results = service.parseBytes(
        _buildTestXlsx(),
      );

      final InvestmentImportData aapl = results.firstWhere(
        (InvestmentImportData r) => r.ticker == 'AAPL',
      );
      final InvestmentImportData nvda = results.firstWhere(
        (InvestmentImportData r) => r.ticker == 'NVDA',
      );

      expect(aapl.quantity, equals(10));
      expect(nvda.quantity, equals(30));
    });

    test('parses purchase date from the column K section header', () {
      final List<InvestmentImportData> results = service.parseBytes(
        _buildTestXlsx(),
      );

      for (final InvestmentImportData r in results) {
        expect(
          r.purchaseDate,
          equals(DateTime(2023, 6, 2)),
          reason: '${r.ticker} should carry the snapshot date Jun 2 2023',
        );
      }
    });

    test('resolves investment type from the colour legend', () {
      final List<InvestmentImportData> results = service.parseBytes(
        _buildTestXlsx(),
      );

      final InvestmentImportData aapl = results.firstWhere(
        (InvestmentImportData r) => r.ticker == 'AAPL',
      );
      expect(aapl.type, equals('Technology'));
    });

    test('rows without a legend colour have null type', () {
      final List<InvestmentImportData> results = service.parseBytes(
        _buildTestXlsx(),
      );

      final InvestmentImportData nvda = results.firstWhere(
        (InvestmentImportData r) => r.ticker == 'NVDA',
      );
      expect(nvda.type, isNull);
    });

    test('handles FormulaCellValue company names (GOOGLEFINANCE cells)', () {
      final List<InvestmentImportData> results = service.parseBytes(
        _buildTestXlsx(),
      );

      final InvestmentImportData nvda = results.firstWhere(
        (InvestmentImportData r) => r.ticker == 'NVDA',
      );
      expect(nvda.companyName, equals('NVIDIA Corporation'));
    });

    test('returns empty list when the workbook has no portfolio sheets', () {
      final Excel excel = Excel.createExcel();
      excel.delete('Sheet1');
      // Only a watchlist sheet — must be skipped.
      excel['List']
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
          .value = TextCellValue(
        'Company',
      );

      final Uint8List bytes = Uint8List.fromList(excel.save()!);
      expect(service.parseBytes(bytes), isEmpty);
    });

    test('deduplicates tickers across multiple sheets', () {
      final Excel excel = Excel.createExcel();
      excel.delete('Sheet1');

      for (final String sheetName in <String>['Jan 1 2023', 'Feb 1 2023']) {
        final Sheet sheet = excel[sheetName];
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
            .value = TextCellValue(
          'Company',
        );
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
            .value = TextCellValue(
          'Ticker',
        );
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1))
            .value = TextCellValue(
          'Apple Inc',
        );
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1))
            .value = TextCellValue(
          'AAPL',
        );
      }

      final List<InvestmentImportData> results = service.parseBytes(
        Uint8List.fromList(excel.save()!),
      );

      final List<String> tickers = results
          .map((InvestmentImportData r) => r.ticker)
          .toList();
      expect(
        tickers.where((String t) => t == 'AAPL'),
        hasLength(1),
        reason: 'AAPL should appear only once despite being in two sheets',
      );
    });
  });
}
