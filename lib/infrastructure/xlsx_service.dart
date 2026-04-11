import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:investtrack/infrastructure/investment_import_data.dart';
import 'package:investtrack/res/constants/currency_list.dart' as currency_list;
import 'package:investtrack/res/constants/types.dart' as types;
import 'package:models/models.dart';

/// Parses XLSX files exported from a stock-tracking spreadsheet and converts
/// them into a list of [InvestmentImportData] objects ready for import.
///
/// Only portfolio sheets (sheets other than "List", "Multi" and
/// "Google Finance Data") are processed.  The watchlist sheets "List" and
/// "Multi" are skipped entirely.
///
/// **Investment type** is resolved from the background colour of cell A for
/// each data row.  The colour-to-type mapping is built from the colour legend
/// embedded in the "Google Finance Data" sheet (column E = colour swatch,
/// column F = type label).
///
/// **Portfolio snapshot date** is extracted from the section header in
/// column K, which contains text like "Total Value on Jun 2 2023 in $".
/// Each header row inside a sheet updates the date used for subsequent rows.
class XlsxService {
  /// Sheet names that are never treated as portfolio sources.
  static const Set<String> _skipSheets = <String>{
    'List',
    'Multi',
    'Google Finance Data',
  };

  static const String _legendSheet = 'Google Finance Data';

  /// ARGB hex values (upper-case) that represent "no fill" in the excel
  /// package.  0x00000000 is a fully-transparent black (effectively no fill),
  /// and 'NONE' is the sentinel used by the excel Dart package itself.
  static const Set<String> _noFillHex = <String>{'NONE', '00000000'};

  static const Map<String, int> _monthAbbr = <String, int>{
    'jan': 1,
    'feb': 2,
    'mar': 3,
    'apr': 4,
    'may': 5,
    'jun': 6,
    'jul': 7,
    'aug': 8,
    'sep': 9,
    'oct': 10,
    'nov': 11,
    'dec': 12,
  };

  /// Parses [bytes] as an XLSX file and returns the unique stock positions
  /// found across all portfolio sheets.
  ///
  /// Investment type and purchase date are derived from the spreadsheet data
  /// directly.  Tickers are deduplicated case-insensitively; the first
  /// occurrence wins.
  List<InvestmentImportData> parseBytes(Uint8List bytes) {
    final Excel excel = Excel.decodeBytes(bytes);

    // Step 1 – build the colour → type legend from "Google Finance Data".
    final Map<String, String> colorLegend = _buildColorLegend(excel);

    final Set<String> seenTickers = <String>{};
    final List<InvestmentImportData> results = <InvestmentImportData>[];

    // Step 2 – process portfolio sheets only.
    for (final String sheetName in excel.tables.keys) {
      if (_skipSheets.contains(sheetName)) continue;

      final Sheet? sheet = excel.tables[sheetName];
      if (sheet == null) continue;

      _parseSheet(sheet, seenTickers, results, colorLegend);
    }

    return results;
  }

  /// Reads the colour legend from the "Google Finance Data" sheet.
  ///
  /// Each legend entry occupies two adjacent rows:
  /// - Column E (index 4) of the first row carries the colour swatch fill.
  /// - Column F (index 5) of the same row carries the label text,
  ///   e.g. "- Aircraft industry".
  Map<String, String> _buildColorLegend(Excel excel) {
    final Map<String, String> legend = <String, String>{};
    final Sheet? sheet = excel.tables[_legendSheet];
    if (sheet == null) return legend;

    for (final List<Data?> row in sheet.rows) {
      if (row.length < 6) continue;
      final Data? swatchCell = row[4]; // column E
      final String? label = _getString(row, 5); // column F
      if (swatchCell == null || label == null || label.isEmpty) continue;

      final String? rawHex = swatchCell.cellStyle?.backgroundColor.colorHex;
      if (rawHex == null) continue;
      final String hex = rawHex.toUpperCase();
      if (_noFillHex.contains(hex)) continue;

      // Strip the leading "- " prefix from labels like "- Aircraft industry".
      final String typeName = label.replaceAll(RegExp(r'^[\s\-]+'), '').trim();
      if (typeName.isNotEmpty) {
        legend[hex] = typeName;
      }
    }

    return legend;
  }

  void _parseSheet(
    Sheet sheet,
    Set<String> seenTickers,
    List<InvestmentImportData> results,
    Map<String, String> colorLegend,
  ) {
    int companyCol = -1;
    int exchangeCol = -1;
    int tickerCol = -1;
    int currencyCol = -1;
    int quantityCol = -1;
    DateTime? currentSectionDate;

    for (final List<Data?> row in sheet.rows) {
      if (row.isEmpty) continue;

      final String? cellA = _getString(row, 0);

      // Header detection – fires on every "Company" header row.
      if (cellA == 'Company') {
        companyCol = 0;
        exchangeCol = -1;
        tickerCol = -1;
        currencyCol = -1;
        quantityCol = -1;

        for (int col = 0; col < row.length; col++) {
          final String? raw = _getString(row, col);
          if (raw == null) continue;
          final String h = raw.toLowerCase().trim();

          if (h == 'ticker') {
            tickerCol = col;
          } else if (h == 'stock exhange' ||
              h == 'stock exchange' ||
              h == 'exchange') {
            exchangeCol = col;
          } else if (h == 'currency') {
            currencyCol = col;
          } else if (h == 'quantity') {
            quantityCol = col;
          } else if (h.startsWith('total value on')) {
            // "Total Value on Jun 2 2023 in $" – parse the snapshot date.
            currentSectionDate = _parseSectionDate(raw);
          }
        }
        continue;
      }

      if (tickerCol == -1 || companyCol == -1) continue;

      final String? rawTicker = _getString(row, tickerCol)?.trim();
      final String? rawCompany = _getString(row, companyCol)?.trim();

      if (rawTicker == null || rawTicker.isEmpty) continue;
      if (rawTicker.startsWith('#')) continue;
      if (rawCompany == null || rawCompany.isEmpty) continue;
      if (rawCompany.startsWith('#')) continue;

      final String lower = rawCompany.toLowerCase();
      if (lower.contains('total') ||
          lower.contains('schedule') ||
          lower.contains('gain or loss') ||
          lower.contains('portfolio') ||
          lower.contains('worth')) {
        continue;
      }

      final String tickerKey = rawTicker.toUpperCase();
      if (seenTickers.contains(tickerKey)) continue;
      seenTickers.add(tickerKey);

      final String rawExchange =
          (exchangeCol >= 0 ? _getString(row, exchangeCol)?.trim() : null) ??
          '';
      final String rawCurrency =
          (currencyCol >= 0 ? _getString(row, currencyCol)?.trim() : null) ??
          'USD';
      final int quantity =
          (quantityCol >= 0 ? _getDouble(row, quantityCol)?.toInt() : null) ??
          0;

      // Resolve investment type from background colour of cell A.
      final String? rawHex = row[0]?.cellStyle?.backgroundColor.colorHex
          .toUpperCase();
      final String? type = (rawHex != null && !_noFillHex.contains(rawHex))
          ? colorLegend[rawHex]
          : null;

      results.add(
        InvestmentImportData(
          ticker: rawTicker,
          companyName: rawCompany,
          stockExchange: _normaliseExchange(rawExchange),
          currency: _normaliseCurrency(rawCurrency),
          quantity: quantity,
          type: type,
          purchaseDate: currentSectionDate,
        ),
      );
    }
  }

  /// Parses a portfolio snapshot date from a section-header string such as
  /// "Total Value on Jun 2 2023 in $" → DateTime(2023, 6, 2).
  DateTime? _parseSectionDate(String headerText) {
    final RegExpMatch? match = RegExp(
      r'\bon\s+(\w{3,})\s+(\d{1,2})\s+(\d{4})\b',
      caseSensitive: false,
    ).firstMatch(headerText);
    if (match == null) return null;

    final String abbr = match.group(1)!.toLowerCase();
    final int? month =
        _monthAbbr[abbr.length >= 3 ? abbr.substring(0, 3) : abbr];
    final int? day = int.tryParse(match.group(2)!);
    final int? year = int.tryParse(match.group(3)!);
    if (month == null || day == null || year == null) return null;
    return DateTime(year, month, day);
  }

  /// Returns the string value of the cell at [col] in [row], or `null`.
  String? _getString(List<Data?> row, int col) {
    if (col < 0 || col >= row.length) return null;
    final Data? cell = row[col];
    if (cell == null) return null;
    final CellValue? value = cell.value;
    if (value == null) return null;

    if (value is TextCellValue) return _extractTextSpan(value.value);
    if (value is IntCellValue) return value.value.toString();
    if (value is DoubleCellValue) return value.value.toString();
    // Formula cells whose type is 'str' store the cached computed text in
    // .formula (e.g. company names driven by a GOOGLEFINANCE formula).
    if (value is FormulaCellValue) {
      return value.formula.isEmpty ? null : value.formula;
    }
    return null;
  }

  String? _extractTextSpan(TextSpan span) {
    final StringBuffer buffer = StringBuffer();
    _visitSpan(span, buffer);
    return buffer.isEmpty ? null : buffer.toString();
  }

  void _visitSpan(TextSpan span, StringBuffer buffer) {
    if (span.text != null) buffer.write(span.text);
    span.children?.forEach((TextSpan child) => _visitSpan(child, buffer));
  }

  /// Returns the numeric value of the cell at [col] in [row], or `null`.
  double? _getDouble(List<Data?> row, int col) {
    if (col < 0 || col >= row.length) return null;
    final Data? cell = row[col];
    if (cell == null) return null;
    final CellValue? value = cell.value;
    if (value is IntCellValue) return value.value.toDouble();
    if (value is DoubleCellValue) return value.value;
    if (value is TextCellValue) {
      final String? text = _extractTextSpan(value.value);
      return text != null ? double.tryParse(text) : null;
    }
    return null;
  }

  String _normaliseExchange(String raw) {
    if (raw.isEmpty) return '';
    final String upper = raw.toUpperCase();
    for (final String known in types.stockExchangeTypes) {
      if (known.toUpperCase() == upper) return known;
    }
    return raw;
  }

  String _normaliseCurrency(String raw) {
    final String upper = raw.toUpperCase();
    for (final Currency c in currency_list.currencies) {
      if (c.alphabeticCode.toUpperCase() == upper) return c.alphabeticCode;
    }
    return 'USD';
  }
}
