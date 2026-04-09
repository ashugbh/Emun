// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ListingSummaryImpl _$$ListingSummaryImplFromJson(Map<String, dynamic> json) =>
    _$ListingSummaryImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$$ListingSummaryImplToJson(
  _$ListingSummaryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'imageUrl': instance.imageUrl,
  'price': instance.price,
};
