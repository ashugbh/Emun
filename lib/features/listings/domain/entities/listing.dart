import 'package:equatable/equatable.dart';

class Seller extends Equatable {
  final String id;
  final String name;
  final String avatarUrl;
  final double rating;
  final bool isVerified;
  final String phone;
  final String whatsapp;

  const Seller({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.rating,
    required this.isVerified,
    required this.phone,
    required this.whatsapp,
  });

  @override
  List<Object?> get props => [id, name, avatarUrl, rating, isVerified, phone, whatsapp];
}

class Listing extends Equatable {
  final String id;
  final String title;
  final String description;
  final double price;
  final String currency;
  final String location;
  final String condition;
  final String categoryId;
  final String categoryName;
  final List<String> imageUrls;
  final Seller seller;
  final DateTime postedAt;
  final bool isFeatured;
  final Map<String, String> attributes;

  const Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    required this.location,
    required this.condition,
    required this.categoryId,
    required this.categoryName,
    required this.imageUrls,
    required this.seller,
    required this.postedAt,
    required this.isFeatured,
    this.attributes = const {},
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        price,
        currency,
        location,
        condition,
        categoryId,
        categoryName,
        imageUrls,
        seller,
        postedAt,
        isFeatured,
        attributes,
      ];
}
