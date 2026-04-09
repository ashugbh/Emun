// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listing_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ListingSummary _$ListingSummaryFromJson(Map<String, dynamic> json) {
  return _ListingSummary.fromJson(json);
}

/// @nodoc
mixin _$ListingSummary {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;

  /// Serializes this ListingSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ListingSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ListingSummaryCopyWith<ListingSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListingSummaryCopyWith<$Res> {
  factory $ListingSummaryCopyWith(
    ListingSummary value,
    $Res Function(ListingSummary) then,
  ) = _$ListingSummaryCopyWithImpl<$Res, ListingSummary>;
  @useResult
  $Res call({String id, String title, String imageUrl, double price});
}

/// @nodoc
class _$ListingSummaryCopyWithImpl<$Res, $Val extends ListingSummary>
    implements $ListingSummaryCopyWith<$Res> {
  _$ListingSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ListingSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? imageUrl = null,
    Object? price = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ListingSummaryImplCopyWith<$Res>
    implements $ListingSummaryCopyWith<$Res> {
  factory _$$ListingSummaryImplCopyWith(
    _$ListingSummaryImpl value,
    $Res Function(_$ListingSummaryImpl) then,
  ) = __$$ListingSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String title, String imageUrl, double price});
}

/// @nodoc
class __$$ListingSummaryImplCopyWithImpl<$Res>
    extends _$ListingSummaryCopyWithImpl<$Res, _$ListingSummaryImpl>
    implements _$$ListingSummaryImplCopyWith<$Res> {
  __$$ListingSummaryImplCopyWithImpl(
    _$ListingSummaryImpl _value,
    $Res Function(_$ListingSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ListingSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? imageUrl = null,
    Object? price = null,
  }) {
    return _then(
      _$ListingSummaryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ListingSummaryImpl implements _ListingSummary {
  const _$ListingSummaryImpl({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
  });

  factory _$ListingSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListingSummaryImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String imageUrl;
  @override
  final double price;

  @override
  String toString() {
    return 'ListingSummary(id: $id, title: $title, imageUrl: $imageUrl, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListingSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, imageUrl, price);

  /// Create a copy of ListingSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ListingSummaryImplCopyWith<_$ListingSummaryImpl> get copyWith =>
      __$$ListingSummaryImplCopyWithImpl<_$ListingSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ListingSummaryImplToJson(this);
  }
}

abstract class _ListingSummary implements ListingSummary {
  const factory _ListingSummary({
    required final String id,
    required final String title,
    required final String imageUrl,
    required final double price,
  }) = _$ListingSummaryImpl;

  factory _ListingSummary.fromJson(Map<String, dynamic> json) =
      _$ListingSummaryImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get imageUrl;
  @override
  double get price;

  /// Create a copy of ListingSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ListingSummaryImplCopyWith<_$ListingSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
