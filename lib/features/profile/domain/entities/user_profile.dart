import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String avatarUrl;
  final String location;
  final String bio;
  final double rating;
  final bool isVerified;
  final int listingsCount;
  final int soldCount;

  const UserProfile({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.location,
    required this.bio,
    required this.rating,
    required this.isVerified,
    required this.listingsCount,
    required this.soldCount,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        avatarUrl,
        location,
        bio,
        rating,
        isVerified,
        listingsCount,
        soldCount,
      ];
}
