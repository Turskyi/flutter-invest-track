import 'package:flutter/material.dart';

const List<String> investmentTypes = <String>[
  'Aircraft industry',
  'Army',
  'Banks sector',
  'Beverages',
  'Buildings',
  'Cars',
  'Chemical industry',
  "ETF's",
  'Games',
  'Mining',
  'Need to buy',
  'Pharmaceutical',
  'Software',
  'Solar Panel',
  'Technology',
  'Water',
];

const List<String> stockExchangeTypes = <String>[
  'NASDAQ',
  'TSE',
  'NYSE',
  'OTCMKTS',
  'CVE',
  'TSX',
  'LON',
  'FRA',
  'ETR',
  'BIT',
  'EPA',
  'STO',
  'TYO',
  'GMEXICOB',
  'HKG',
  'EBR',
  'AMS',
];

const List<Color> colorPalette = <Color>[
  Color(0xFF1F77B4), // Steel Blue
  Color(0xFFFF7F0E), // Dark Orange
  Color(0xFF2CA02C), // Forest Green
  Color(0xFFBCBD22), // Olive Green
  Color(0xFF880808), // Red
  Color(0xFF808080), // Gray
  Color(0xFF000000), // Black
  Color(0xFF7F7F7F), // Middle Gray
  Color(0xFFFFC0CB), // Pink
  Color(0xFF17BECF), // Bright Cyan
  Color(0xFF1F78B4), // Dodger Blue
  Color(0xFFFF9896), // Light Coral
  Color(0xFFC5B0D5), // Light Purple
  Color(0xFFE7969C), // Pale Red
  Color(0xFFBF40BF), // Purple
  Color(0xFFAEC7E8), // Light Blue
];

Map<String, Color> generateInvestmentTypeColors(List<String> types) {
  final Map<String, Color> typeColors = <String, Color>{};

  for (int i = 0; i < types.length; i++) {
    final String type = types[i];
    final Color color = colorPalette[i % colorPalette.length];
    typeColors[type] = color;
  }

  return typeColors;
}

final Map<String, Color> investmentTypeColors = generateInvestmentTypeColors(
  investmentTypes,
);
