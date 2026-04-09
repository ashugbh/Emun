import 'package:freezed_annotation/freezed_annotation.dart';

part 'listing_summary.freezed.dart';
part 'listing_summary.g.dart';

@freezed
class ListingSummary with _$ListingSummary {
  const factory ListingSummary({
    required String id,
    required String title,
    required String imageUrl,
    required double price,
  }) = _ListingSummary;

  factory ListingSummary.fromJson(Map<String, dynamic> json) =>
      _$ListingSummaryFromJson(json);
}
