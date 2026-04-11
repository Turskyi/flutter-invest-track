import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/application_services/blocs/investments/investments_bloc.dart';

/// Shown while the bulk import is in progress.
///
/// Displays a progress bar and a current / total counter.
class ImportProgress extends StatelessWidget {
  const ImportProgress({required this.state, super.key});

  final ImportingInvestments state;

  @override
  Widget build(BuildContext context) {
    final double fraction = state.total > 0
        ? (state.current / state.total)
        : 0.0;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              translate('import.progress_title'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            LinearProgressIndicator(value: fraction),
            const SizedBox(height: 12),
            Text(
              '${state.current} / ${state.total}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
