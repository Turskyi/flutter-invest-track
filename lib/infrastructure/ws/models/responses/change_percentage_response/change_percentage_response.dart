import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'change_percentage_response.g.dart';

@JsonSerializable()
class ChangePercentageResponse implements ChangePercentage {
  const ChangePercentageResponse({required this.changePercentage});

  factory ChangePercentageResponse.fromJson(Map<String, dynamic> json) {
    return _$ChangePercentageResponseFromJson(json);
  }

  @override
  final double changePercentage;

  @override
  String toString() {
    return 'ChangePercentageResponse(changePercentage: $changePercentage)';
  }

  Map<String, dynamic> toJson() => _$ChangePercentageResponseToJson(this);

  ChangePercentageResponse copyWith({double? changePercentage}) {
    return ChangePercentageResponse(
      changePercentage: changePercentage ?? this.changePercentage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ChangePercentageResponse) return false;
    final bool Function(Object? e1, Object? e2) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => changePercentage.hashCode;
}
