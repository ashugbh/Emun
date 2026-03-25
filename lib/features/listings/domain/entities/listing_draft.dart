import 'package:equatable/equatable.dart';

class ListingDraft extends Equatable {
  final String title;
  final String description;
  final double price;
  final String location;
  final String condition;
  final String categoryId;
  final String categoryName;
  final List<String> imageUrls;
  final Map<String, String> attributes;

  const ListingDraft({
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.condition,
    required this.categoryId,
    required this.categoryName,
    this.imageUrls = const [],
    this.attributes = const {},
  });

  @override
  List<Object?> get props => [
        title,
        description,
        price,
        location,
        condition,
        categoryId,
        categoryName,
        imageUrls,
        attributes,
      ];
}
