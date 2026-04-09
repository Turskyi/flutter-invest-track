import 'package:flutter/material.dart';

class HorizontalOverflowIndicator extends StatefulWidget {
  const HorizontalOverflowIndicator({
    required this.controller,
    super.key,
  });

  final ScrollController controller;

  @override
  State<HorizontalOverflowIndicator> createState() =>
      _HorizontalOverflowIndicatorState();
}

class _HorizontalOverflowIndicatorState
    extends State<HorizontalOverflowIndicator> {
  static const ValueKey<String> trackKey = ValueKey<String>(
    'horizontal-overflow-indicator-track',
  );
  static const ValueKey<String> thumbKey = ValueKey<String>(
    'horizontal-overflow-indicator-thumb',
  );
  static const double _horizontalPadding = 16;
  static const double _minimumThumbWidth = 48;
  static const double _thumbHeight = 4;

  // Cached during build; read by gesture handlers.
  double _cachedThumbTravel = 0;
  double _cachedMaxScrollExtent = 0;

  // Drag state.
  double? _dragStartDx;
  double? _dragStartPixels;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChanged);
    _scheduleMetricsRefresh();
  }

  @override
  void didUpdateWidget(covariant HorizontalOverflowIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) {
      _scheduleMetricsRefresh();
    } else {
      oldWidget.controller.removeListener(_handleControllerChanged);
      widget.controller.addListener(_handleControllerChanged);
      _scheduleMetricsRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return SizedBox(
      height: 12,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (!widget.controller.hasClients) {
            return const SizedBox.shrink();
          } else {
            final ScrollPosition position = widget.controller.position;
            final double maxScrollExtent = position.maxScrollExtent;
            if (maxScrollExtent <= 0) {
              return const SizedBox.shrink();
            } else {
              final double availableWidth =
                  constraints.maxWidth - (_horizontalPadding * 2);
              if (availableWidth <= 0) {
                return const SizedBox.shrink();
              } else {
                final double contentWidth = availableWidth + maxScrollExtent;
                final double rawThumbWidth =
                    availableWidth * (availableWidth / contentWidth);
                final double thumbWidth = rawThumbWidth.clamp(
                  _minimumThumbWidth,
                  availableWidth,
                );
                final double thumbTravel = availableWidth - thumbWidth;
                final double normalizedOffset =
                    (position.pixels / maxScrollExtent).clamp(0.0, 1.0);
                final double thumbOffset = thumbTravel * normalizedOffset;

                // Cache for gesture handlers (no setState — purely a
                // side-effect cache updated each frame).
                _cachedThumbTravel = thumbTravel;
                _cachedMaxScrollExtent = maxScrollExtent;

                final Color trackColor =
                    themeData.colorScheme.onSurface.withOpacity(0.12);
                final Color thumbColor =
                    themeData.colorScheme.primary.withOpacity(0.55);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _horizontalPadding,
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: _thumbHeight,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.grab,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onHorizontalDragStart: _onDragStart,
                          onHorizontalDragUpdate: _onDragUpdate,
                          onHorizontalDragEnd: (_) => _clearDragState(),
                          onHorizontalDragCancel: _clearDragState,
                          child: Stack(
                            children: <Widget>[
                              DecoratedBox(
                                key: trackKey,
                                decoration: BoxDecoration(
                                  color: trackColor,
                                  borderRadius: BorderRadius.circular(
                                    _thumbHeight,
                                  ),
                                ),
                                child: const SizedBox.expand(),
                              ),
                              Positioned(
                                left: thumbOffset,
                                child: DecoratedBox(
                                  key: thumbKey,
                                  decoration: BoxDecoration(
                                    color: thumbColor,
                                    borderRadius: BorderRadius.circular(
                                      _thumbHeight,
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: thumbWidth,
                                    height: _thumbHeight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    _dragStartDx = details.localPosition.dx;
    _dragStartPixels =
        widget.controller.hasClients ? widget.controller.position.pixels : 0.0;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final double? startDx = _dragStartDx;
    final double? startPixels = _dragStartPixels;
    if (startDx == null || startPixels == null || _cachedThumbTravel <= 0) {
      return;
    }
    final double dragDelta = details.localPosition.dx - startDx;
    final double scrollRatio = _cachedMaxScrollExtent / _cachedThumbTravel;
    final double newPixels =
        (startPixels + dragDelta * scrollRatio)
            .clamp(0.0, _cachedMaxScrollExtent);
    widget.controller.jumpTo(newPixels);
  }

  void _clearDragState() {
    _dragStartDx = null;
    _dragStartPixels = null;
  }

  void _handleControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _scheduleMetricsRefresh() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }
}
