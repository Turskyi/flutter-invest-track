import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerDesktopTable extends StatelessWidget {
  const ShimmerDesktopTable({super.key});

  /// Approximate widths (px) for each column matching the real DataTable:
  /// logo | company | exchange | ticker | current price | currency |
  /// price change | % change | quantity | total current | total purchase |
  /// price on purchase | gain/loss USD | gain/loss CAD
  static const List<double> _columnWidths = <double>[
    32,
    160,
    120,
    60,
    100,
    70,
    90,
    80,
    70,
    160,
    170,
    130,
    120,
    120,
  ];

  static const int _dataRowCount = 6;
  static const double _columnGap = 24;
  static const double _horizontalCellPadding = 16;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 80, bottom: 80),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[700]!,
          highlightColor: Colors.grey[500]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const _ShimmerRow(isHeader: true),
              const Divider(height: 1, thickness: 1),
              for (int i = 0; i < _dataRowCount; i++) ...<Widget>[
                const _ShimmerRow(isHeader: false),
                const Divider(height: 1, thickness: 0.5),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerRow extends StatelessWidget {
  const _ShimmerRow({required this.isHeader});

  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: List<Widget>.generate(
          ShimmerDesktopTable._columnWidths.length,
          (int i) {
            final double colWidth = ShimmerDesktopTable._columnWidths[i];
            final bool isLogoColumn = i == 0;
            // Logo column: circle for data rows, nothing for header
            if (isLogoColumn) {
              if (isHeader) {
                return SizedBox(
                  width:
                      colWidth +
                      ShimmerDesktopTable._columnGap +
                      ShimmerDesktopTable._horizontalCellPadding,
                );
              } else {
                return Container(
                  width: colWidth,
                  height: colWidth,
                  margin: const EdgeInsets.only(
                    left: ShimmerDesktopTable._horizontalCellPadding,
                    right: ShimmerDesktopTable._columnGap,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                );
              }
            }
            // Regular text columns
            final double pillWidth = isHeader ? colWidth * 0.6 : colWidth;
            return Container(
              width: pillWidth,
              height: isHeader ? 12 : 16,
              margin: EdgeInsets.only(
                right: i == ShimmerDesktopTable._columnWidths.length - 1
                    ? ShimmerDesktopTable._horizontalCellPadding
                    : ShimmerDesktopTable._columnGap,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          },
        ),
      ),
    );
  }
}
