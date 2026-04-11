import 'package:models/models.dart';

class DemoInvestments implements Investments {
  const DemoInvestments({required this.investments});

  @override
  final List<Investment> investments;

  @override
  int get totalPages => 1;

  @override
  int get currentPage => 1;
}
