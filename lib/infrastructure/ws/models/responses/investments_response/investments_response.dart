import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:investtrack/infrastructure/ws/models/responses/investment_response/investment_response.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'investments_response.g.dart';

@JsonSerializable()
class InvestmentsResponse implements Investments {
  const InvestmentsResponse({
    required this.investments,
    required this.totalPages,
  });

  factory InvestmentsResponse.fromJson(Map<String, dynamic> json) {
    return _$InvestmentsResponseFromJson(json);
  }

  @override
  @JsonKey(name: 'investments')
  final List<InvestmentResponse> investments;
  @JsonKey(name: 'totalPages')
  final int? totalPages;

  @override
  String toString() {
    if (kDebugMode) {
      return 'InvestmentsResponse('
          'investments: $investments, '
          'totalPages: $totalPages,'
          ')';
    } else {
      return super.toString();
    }
  }

  Map<String, dynamic> toJson() => _$InvestmentsResponseToJson(this);

  InvestmentsResponse copyWith({
    List<InvestmentResponse>? investments,
    int? totalPages,
  }) {
    return InvestmentsResponse(
      investments: investments ?? this.investments,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! InvestmentsResponse) return false;
    final bool Function(Object? e1, Object? e2) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => investments.hashCode;
}
