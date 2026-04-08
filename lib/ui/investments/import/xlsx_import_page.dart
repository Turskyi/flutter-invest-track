import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/application_services/blocs/investments/investments_bloc.dart';
import 'package:investtrack/infrastructure/investment_import_data.dart';
import 'package:investtrack/infrastructure/xlsx_service.dart';
import 'package:investtrack/ui/investments/import/import_completed_view.dart';
import 'package:investtrack/ui/investments/import/import_content.dart';
import 'package:investtrack/ui/investments/import/import_progress.dart';
import 'package:investtrack/ui/widgets/blurred_app_bar.dart';
import 'package:investtrack/ui/widgets/gradient_background_scaffold.dart';

/// A page that lets the user pick an XLSX file with a list of stock positions
/// and batch-import them into the app.
///
/// Investment type and portfolio snapshot date are read directly from the
/// spreadsheet; the user only needs to pick the file, deselect unwanted rows,
/// and tap Import.
class XlsxImportPage extends StatefulWidget {
  const XlsxImportPage({super.key});

  @override
  State<XlsxImportPage> createState() => _XlsxImportPageState();
}

class _XlsxImportPageState extends State<XlsxImportPage> {
  bool _isLoadingFile = false;
  String? _fileName;
  List<InvestmentImportData> _parsed = <InvestmentImportData>[];
  String? _parseError;
  Map<String, bool> _selected = <String, bool>{};

  @override
  Widget build(BuildContext context) {
    return GradientBackgroundScaffold(
      appBar: BlurredAppBar(title: Text(translate('import.title'))),
      body: BlocConsumer<InvestmentsBloc, InvestmentsState>(
        listener: _handleState,
        builder: (BuildContext context, InvestmentsState state) {
          if (state is ImportingInvestments) {
            return ImportProgress(state: state);
          } else if (state is ImportCompleted) {
            return ImportCompletedView(state: state);
          } else {
            return ImportContent(
              state: state,
              isLoadingFile: _isLoadingFile,
              fileName: _fileName,
              parsed: _parsed,
              selected: _selected,
              parseError: _parseError,
              onPickFile: _pickFile,
              onToggle: (String ticker, bool? v) {
                setState(() => _selected[ticker] = v ?? false);
              },
              onImport: _startImport,
            );
          }
        },
      ),
    );
  }

  Future<void> _pickFile() async {
    setState(() {
      _isLoadingFile = true;
      _parseError = null;
    });

    try {
      final FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: <String>['xlsx'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        setState(() => _isLoadingFile = false);
        return;
      }

      final PlatformFile file = result.files.single;
      final Uint8List? bytes = file.bytes;

      if (bytes == null) {
        setState(() {
          _isLoadingFile = false;
          _parseError = translate('import.error_no_bytes');
        });
        return;
      }

      final List<InvestmentImportData> parsed = XlsxService().parseBytes(bytes);

      setState(() {
        _isLoadingFile = false;
        _fileName = file.name;
        _parsed = parsed;
        _selected = <String, bool>{
          for (final InvestmentImportData d in parsed) d.ticker: true,
        };
        _parseError = parsed.isEmpty
            ? translate('import.error_no_stocks')
            : null;
      });
    } catch (e) {
      setState(() {
        _isLoadingFile = false;
        _parseError = '${translate('import.error_parse_prefix')} $e';
      });
    }
  }

  void _startImport() {
    final List<InvestmentImportData> selected = _parsed
        .where((InvestmentImportData d) => _selected[d.ticker] == true)
        .toList();

    context.read<InvestmentsBloc>().add(
      BulkImportInvestmentsEvent(imports: selected),
    );
  }

  void _handleState(BuildContext context, InvestmentsState state) {
    if (state is UnauthenticatedInvestmentsAccessState) {
      Navigator.of(context).pop();
    }
  }
}
