import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/application_services/blocs/investments/investments_bloc.dart';

/// Shown after the bulk import finishes.
///
/// Displays imported / failed counts and a "Done" button that pops the page.
class ImportCompletedView extends StatelessWidget {
  const ImportCompletedView({required this.state, super.key});

  final ImportCompleted state;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.check_circle_outline,
              size: 72,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            Text(
              translate('import.completed_title'),
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${translate('import.completed_imported')} '
              '${state.importedCount}\n'
              '${translate('import.completed_failed')} ${state.failedCount}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(translate('import.done_button')),
            ),
          ],
        ),
      ),
    );
  }
}
