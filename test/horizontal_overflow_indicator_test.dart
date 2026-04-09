import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:investtrack/ui/widgets/horizontal_overflow_indicator.dart';

void main() {
  const ValueKey<String> trackKey = ValueKey<String>(
    'horizontal-overflow-indicator-track',
  );
  const ValueKey<String> thumbKey = ValueKey<String>(
    'horizontal-overflow-indicator-thumb',
  );

  testWidgets('hides the indicator when content fits horizontally', (
    WidgetTester tester,
  ) async {
    final ScrollController controller = ScrollController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 240,
            height: 80,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SingleChildScrollView(
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    child: const SizedBox(width: 120, height: 40),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: IgnorePointer(
                    child: HorizontalOverflowIndicator(controller: controller),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(trackKey), findsNothing);
    expect(find.byKey(thumbKey), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows the indicator and updates the thumb position on scroll', (
    WidgetTester tester,
  ) async {
    final ScrollController controller = ScrollController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 240,
            height: 80,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SingleChildScrollView(
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    child: const SizedBox(width: 600, height: 40),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: IgnorePointer(
                    child: HorizontalOverflowIndicator(controller: controller),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(trackKey), findsOneWidget);
    expect(find.byKey(thumbKey), findsOneWidget);

    final double initialThumbDx = tester.getTopLeft(find.byKey(thumbKey)).dx;

    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(-120, 0),
    );
    await tester.pumpAndSettle();

    final double updatedThumbDx = tester.getTopLeft(find.byKey(thumbKey)).dx;

    expect(updatedThumbDx, greaterThan(initialThumbDx));
    expect(tester.takeException(), isNull);
  });
}

