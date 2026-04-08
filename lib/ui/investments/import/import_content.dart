import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/application_services/blocs/investments/investments_bloc.dart';
import 'package:investtrack/infrastructure/investment_import_data.dart';
import 'package:investtrack/ui/investments/import/stock_subtitle.dart';

/// The main content shown while the user is picking and reviewing stocks.
///
/// Displays:
/// - Step 1: a file-picker button.
/// - Step 2: the list of detected stocks with checkboxes and an import button.
class ImportContent extends StatelessWidget {
  const ImportContent({
    required this.state,
    required this.isLoadingFile,
    required this.fileName,
    required this.parsed,
    required this.selected,
    required this.parseError,
    required this.onPickFile,
    required this.onToggle,
    required this.onImport,
    super.key,
  });

  final InvestmentsState state;
  final bool isLoadingFile;
  final String? fileName;
  final List<InvestmentImportData> parsed;
  final Map<String, bool> selected;
  final String? parseError;
  final VoidCallback onPickFile;
  final void Function(String ticker, bool? value) onToggle;
  final VoidCallback onImport;

  bool get _hasFile => fileName != null;

  bool get _hasSelection {
    return selected.values.any((bool v) => v) && _hasFile && parseError == null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 120, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // --- Step 1: pick file ---
          Text(
            translate('import.step1_pick_file'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: isLoadingFile ? null : onPickFile,
            icon: isLoadingFile
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.attach_file),
            label: Text(fileName ?? translate('import.pick_file_button')),
          ),
          if (parseError != null) ...<Widget>[
            const SizedBox(height: 8),
            SelectableText(
              parseError!,
              style: const TextStyle(color: Colors.red),
            ),
          ],

          // --- Step 2: review detected stocks ---
          if (_hasFile && parseError == null) ...<Widget>[
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  translate('import.step2_review'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${selected.values.where((bool v) => v).length} / '
                  '${parsed.length} ${translate('import.selected_suffix')}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...parsed.map(
              (InvestmentImportData item) => CheckboxListTile(
                dense: true,
                value: selected[item.ticker] ?? false,
                onChanged: (bool? value) => onToggle(item.ticker, value),
                title: Text(
                  '${item.ticker}  •  ${item.companyName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: StockSubtitle(item: item),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _hasSelection && state is! ImportingInvestments
                  ? onImport
                  : null,
              icon: const Icon(Icons.download),
              label: Text(translate('import.import_button')),
            ),
          ],
        ],
      ),
    );
  }
}
