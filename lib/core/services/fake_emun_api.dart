import 'dart:math';

import 'package:flutter/material.dart';
import 'package:emun/core/constants/app_constants.dart';
import 'package:emun/core/theme/app_colors.dart';
import 'package:emun/features/admin/domain/entities/moderation_report.dart';
import 'package:emun/features/listings/domain/entities/category.dart';
import 'package:emun/features/listings/domain/entities/listing.dart';
import 'package:emun/features/listings/domain/entities/listing_draft.dart';
import 'package:emun/features/listings/domain/entities/search_query.dart';
import 'package:emun/features/messages/domain/entities/conversation.dart';
import 'package:emun/features/messages/domain/entities/message.dart';
import 'package:emun/features/profile/domain/entities/user_profile.dart';

class FakeEmunApi {
  FakeEmunApi({Duration? delay}) : _delay = delay ?? AppConstants.fakeApiDelay {
    assert(AppConstants.fakeBaseUrl.isNotEmpty);
  }

  final Duration _delay;
  final Random _random = Random(42);

  late final UserProfile _profile = const UserProfile(
    id: 'u1',
    name: 'Selam Dawit',
    avatarUrl:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=60',
    location: 'Addis Ababa',
    bio: 'Helping neighbors trade essentials and find great deals fast.',
    rating: 4.8,
    isVerified: true,
    listingsCount: 7,
    soldCount: 12,
  );

  late final Seller _sellerMira = const Seller(
    id: 'u2',
    name: 'Mira Bekele',
    avatarUrl:
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=400&q=60',
    rating: 4.6,
    isVerified: true,
    phone: '+251 911 000 112',
    whatsapp: '+251 911 000 112',
  );

  late final Seller _sellerSena = const Seller(
    id: 'u3',
    name: 'Sena Motors',
    avatarUrl:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=60',
    rating: 4.9,
    isVerified: true,
    phone: '+251 922 010 330',
    whatsapp: '+251 922 010 330',
  );

  late final Seller _sellerLiya = const Seller(
    id: 'u4',
    name: 'Liya Tech',
    avatarUrl:
        'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?auto=format&fit=crop&w=400&q=60',
    rating: 4.4,
    isVerified: false,
    phone: '+251 933 221 100',
    whatsapp: '+251 933 221 100',
  );

  late final List<Category> _categories = [
    Category(
      id: 'homes',
      name: 'Homes',
      icon: Icons.home_outlined,
      color: AppColors.primary,
      subcategories: const ['Apartments', 'Houses', 'Land'],
    ),
    Category(
      id: 'phones',
      name: 'Phones',
      icon: Icons.smartphone_outlined,
      color: const Color(0xFF5B7FFF),
      subcategories: const ['Android', 'iPhone', 'Accessories'],
    ),
    Category(
      id: 'computers',
      name: 'Computers',
      icon: Icons.laptop_outlined,
      color: const Color(0xFF5A6C59),
      subcategories: const ['Laptops', 'Desktops', 'Monitors'],
    ),
    Category(
      id: 'vehicles',
      name: 'Vehicles',
      icon: Icons.directions_car_outlined,
      color: const Color(0xFFEB7A3C),
      subcategories: const ['Cars', 'SUVs', 'Motorcycles'],
    ),
    Category(
      id: 'appliances',
      name: 'Appliances',
      icon: Icons.kitchen_outlined,
      color: const Color(0xFF8C6B4F),
      subcategories: const ['Refrigerators', 'Washers', 'Cookers'],
    ),
    Category(
      id: 'furniture',
      name: 'Furniture',
      icon: Icons.chair_outlined,
      color: const Color(0xFF9B7C5A),
      subcategories: const ['Sofas', 'Beds', 'Tables'],
    ),
    Category(
      id: 'goods',
      name: 'General Goods',
      icon: Icons.shopping_bag_outlined,
      color: const Color(0xFF4F8B8B),
      subcategories: const ['Bicycles', 'Watches', 'Sports'],
    ),
  ];

  late final List<Listing> _listings = [
    Listing(
      id: 'l1',
      title: 'Modern 2-bedroom apartment near Bole',
      description:
          'Bright apartment with balcony, secured compound, and parking. Walking distance to cafes.',
      price: 12500,
      currency: AppConstants.currency,
      location: 'Bole, Addis Ababa',
      condition: 'New',
      categoryId: 'homes',
      categoryName: 'Homes',
      imageUrls: const [
        'https://images.unsplash.com/photo-1560185127-6ed189bf02f4?auto=format&fit=crop&w=800&q=60',
        'https://images.unsplash.com/photo-1502005229762-cf1b2da7c5d6?auto=format&fit=crop&w=800&q=60',
      ],
      seller: _sellerMira,
      postedAt: DateTime.now().subtract(const Duration(hours: 4)),
      isFeatured: true,
      attributes: const {
        'Bedrooms': '2',
        'Bathrooms': '2',
        'Size': '120 sqm',
      },
    ),
    Listing(
      id: 'l2',
      title: 'iPhone 14 Pro Max 256GB',
      description:
          'Like-new condition, includes charger and box. Battery health at 96 percent.',
      price: 62000,
      currency: AppConstants.currency,
      location: 'Kazanchis, Addis Ababa',
      condition: 'Used',
      categoryId: 'phones',
      categoryName: 'Phones',
      imageUrls: const [
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=60',
        'https://images.unsplash.com/photo-1495433324511-bf8e92934d90?auto=format&fit=crop&w=800&q=60',
      ],
      seller: _sellerLiya,
      postedAt: DateTime.now().subtract(const Duration(hours: 10)),
      isFeatured: true,
      attributes: const {
        'Storage': '256GB',
        'Color': 'Deep Purple',
        'Warranty': '3 months',
      },
    ),
    Listing(
      id: 'l3',
      title: 'Gaming laptop with RTX 3060',
      description:
          'High performance laptop for creators and gamers. Includes original packaging.',
      price: 88000,
      currency: AppConstants.currency,
      location: 'CMC, Addis Ababa',
      condition: 'Used',
      categoryId: 'computers',
      categoryName: 'Computers',
      imageUrls: const [
        'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=60',
        'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=800&q=60',
      ],
      seller: _sellerLiya,
      postedAt: DateTime.now().subtract(const Duration(days: 1)),
      isFeatured: false,
      attributes: const {
        'GPU': 'RTX 3060',
        'RAM': '16GB',
        'Storage': '1TB SSD',
      },
    ),
    Listing(
      id: 'l4',
      title: 'Toyota RAV4 2020 AWD',
      description:
          'Clean title, full service history, one owner. Perfect for city and weekend trips.',
      price: 3200000,
      currency: AppConstants.currency,
      location: 'Sarbet, Addis Ababa',
      condition: 'Used',
      categoryId: 'vehicles',
      categoryName: 'Vehicles',
      imageUrls: const [
        'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=800&q=60',
        'https://images.unsplash.com/photo-1503736334956-4c8f8e92946d?auto=format&fit=crop&w=800&q=60',
      ],
      seller: _sellerSena,
      postedAt: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
      isFeatured: true,
      attributes: const {
        'Year': '2020',
        'Mileage': '48,000 km',
        'Fuel': 'Petrol',
      },
    ),
    Listing(
      id: 'l5',
      title: 'Stainless steel fridge 400L',
      description:
          'Energy efficient, frost free, works perfectly. Delivery available within city.',
      price: 38000,
      currency: AppConstants.currency,
      location: 'Megenagna, Addis Ababa',
      condition: 'Used',
      categoryId: 'appliances',
      categoryName: 'Appliances',
      imageUrls: const [
        'https://images.unsplash.com/photo-1501045661006-fcebe0257c3f?auto=format&fit=crop&w=800&q=60',
        'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=800&q=60',
      ],
      seller: _sellerMira,
      postedAt: DateTime.now().subtract(const Duration(days: 2)),
      isFeatured: false,
      attributes: const {
        'Capacity': '400L',
        'Brand': 'Samsung',
        'Energy': 'A++',
      },
    ),
    Listing(
      id: 'l6',
      title: 'Solid wood dining set for 6',
      description:
          'Handcrafted set with six chairs. Perfect for modern dining rooms.',
      price: 54000,
      currency: AppConstants.currency,
      location: 'Piassa, Addis Ababa',
      condition: 'New',
      categoryId: 'furniture',
      categoryName: 'Furniture',
      imageUrls: const [
        'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=800&q=60',
        'https://images.unsplash.com/photo-1501045661006-fcebe0257c3f?auto=format&fit=crop&w=800&q=60',
      ],
      seller: _sellerMira,
      postedAt: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
      isFeatured: false,
      attributes: const {
        'Material': 'Oak wood',
        'Seats': '6',
        'Finish': 'Matte',
      },
    ),
    Listing(
      id: 'l7',
      title: 'City bike with basket',
      description:
          'Lightweight city bike, recently tuned. Great for short commutes.',
      price: 12500,
      currency: AppConstants.currency,
      location: 'Yeka, Addis Ababa',
      condition: 'Used',
      categoryId: 'goods',
      categoryName: 'General Goods',
      imageUrls: const [
        'https://images.unsplash.com/photo-1485965120184-e220f721d03e?auto=format&fit=crop&w=800&q=60',
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=800&q=60',
      ],
      seller: _sellerLiya,
      postedAt: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
      isFeatured: false,
      attributes: const {
        'Frame': 'Aluminum',
        'Size': 'Medium',
        'Gears': '7-speed',
      },
    ),
    Listing(
      id: 'l8',
      title: 'Cozy studio with city view',
      description:
          'Studio apartment with full kitchen, ready to move in. Ideal for professionals.',
      price: 8200,
      currency: AppConstants.currency,
      location: 'CMC, Addis Ababa',
      condition: 'New',
      categoryId: 'homes',
      categoryName: 'Homes',
      imageUrls: const [
        'https://images.unsplash.com/photo-1502005229762-cf1b2da7c5d6?auto=format&fit=crop&w=800&q=60',
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=60',
      ],
      seller: _sellerMira,
      postedAt: DateTime.now().subtract(const Duration(hours: 20)),
      isFeatured: true,
      attributes: const {
        'Bedrooms': 'Studio',
        'Bathrooms': '1',
        'Size': '55 sqm',
      },
    ),
    Listing(
      id: 'l9',
      title: 'Samsung Galaxy S23 Ultra',
      description: 'Top-tier camera setup, 12GB RAM, includes protective case.',
      price: 54000,
      currency: AppConstants.currency,
      location: 'Bole, Addis Ababa',
      condition: 'Used',
      categoryId: 'phones',
      categoryName: 'Phones',
      imageUrls: const [
        'https://images.unsplash.com/photo-1510552776732-03e61cf4b144?auto=format&fit=crop&w=800&q=60',
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=60',
      ],
      seller: _sellerLiya,
      postedAt: DateTime.now().subtract(const Duration(hours: 14)),
      isFeatured: false,
      attributes: const {
        'Storage': '512GB',
        'Color': 'Green',
        'Warranty': '6 months',
      },
    ),
    Listing(
      id: 'l10',
      title: 'Compact washing machine 8kg',
      description:
          'Quiet, efficient, and easy to install. Includes hoses and manual.',
      price: 28000,
      currency: AppConstants.currency,
      location: 'Gerji, Addis Ababa',
      condition: 'Used',
      categoryId: 'appliances',
      categoryName: 'Appliances',
      imageUrls: const [
        'https://images.unsplash.com/photo-1581579187071-2fbf332d3d0c?auto=format&fit=crop&w=800&q=60',
        'https://images.unsplash.com/photo-1519710164239-da123dc03ef4?auto=format&fit=crop&w=800&q=60',
      ],
      seller: _sellerMira,
      postedAt: DateTime.now().subtract(const Duration(days: 4)),
      isFeatured: false,
      attributes: const {
        'Capacity': '8kg',
        'Brand': 'LG',
        'Type': 'Front load',
      },
    ),
    Listing(
      id: 'l11',
      title: 'Executive office chair with lumbar support',
      description:
          'Ergonomic chair, adjustable arm rests, and breathable mesh back.',
      price: 9800,
      currency: AppConstants.currency,
      location: 'Lideta, Addis Ababa',
      condition: 'New',
      categoryId: 'furniture',
      categoryName: 'Furniture',
      imageUrls: const [
        'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=800&q=60',
        'https://images.unsplash.com/photo-1501045661006-fcebe0257c3f?auto=format&fit=crop&w=800&q=60',
      ],
      seller: _sellerLiya,
      postedAt: DateTime.now().subtract(const Duration(days: 5, hours: 2)),
      isFeatured: false,
      attributes: const {
        'Material': 'Mesh',
        'Color': 'Black',
        'Warranty': '1 year',
      },
    ),
    Listing(
      id: 'l12',
      title: 'Honda CR-V 2018',
      description:
          'Reliable SUV with upgraded sound system and fresh tires.',
      price: 2600000,
      currency: AppConstants.currency,
      location: 'Bole, Addis Ababa',
      condition: 'Used',
      categoryId: 'vehicles',
      categoryName: 'Vehicles',
      imageUrls: const [
        'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=800&q=60',
        'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=800&q=60',
      ],
      seller: _sellerSena,
      postedAt: DateTime.now().subtract(const Duration(days: 6)),
      isFeatured: false,
      attributes: const {
        'Year': '2018',
        'Mileage': '72,000 km',
        'Fuel': 'Petrol',
      },
    ),
  ];

  late final List<Conversation> _conversations = [
    Conversation(
      id: 'c1',
      listing: ListingSummary(
        id: _listings[0].id,
        title: _listings[0].title,
        imageUrl: _listings[0].imageUrls.first,
        price: _listings[0].price,
      ),
      otherUserName: _sellerMira.name,
      otherUserAvatar: _sellerMira.avatarUrl,
      lastMessage: Message(
        id: 'm1',
        conversationId: 'c1',
        senderId: _sellerMira.id,
        text: 'Hello! Let me know if you want to schedule a visit.',
        sentAt: DateTime.now().subtract(const Duration(minutes: 40)),
        isMine: false,
      ),
      unreadCount: 1,
    ),
    Conversation(
      id: 'c2',
      listing: ListingSummary(
        id: _listings[3].id,
        title: _listings[3].title,
        imageUrl: _listings[3].imageUrls.first,
        price: _listings[3].price,
      ),
      otherUserName: _sellerSena.name,
      otherUserAvatar: _sellerSena.avatarUrl,
      lastMessage: Message(
        id: 'm2',
        conversationId: 'c2',
        senderId: _sellerSena.id,
        text: 'Car is available for inspection this weekend.',
        sentAt: DateTime.now().subtract(const Duration(hours: 3)),
        isMine: false,
      ),
      unreadCount: 0,
    ),
  ];

  late final Map<String, List<Message>> _messages = {
    'c1': [
      Message(
        id: 'm1',
        conversationId: 'c1',
        senderId: _sellerMira.id,
        text: 'Hello! Let me know if you want to schedule a visit.',
        sentAt: DateTime.now().subtract(const Duration(minutes: 40)),
        isMine: false,
      ),
      Message(
        id: 'm3',
        conversationId: 'c1',
        senderId: _profile.id,
        text: 'Thanks! Is the apartment still available next week?',
        sentAt: DateTime.now().subtract(const Duration(minutes: 32)),
        isMine: true,
      ),
    ],
    'c2': [
      Message(
        id: 'm2',
        conversationId: 'c2',
        senderId: _sellerSena.id,
        text: 'Car is available for inspection this weekend.',
        sentAt: DateTime.now().subtract(const Duration(hours: 3)),
        isMine: false,
      ),
      Message(
        id: 'm4',
        conversationId: 'c2',
        senderId: _profile.id,
        text: 'Can we meet Saturday morning?',
        sentAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 20)),
        isMine: true,
      ),
    ],
  };

  late final List<ModerationReport> _reports = [
    ModerationReport(
      id: 'r1',
      listingTitle: _listings[7].title,
      reason: 'Potential duplicate listing',
      reportedAt: DateTime.now().subtract(const Duration(hours: 6)),
      status: 'Open',
    ),
    ModerationReport(
      id: 'r2',
      listingTitle: _listings[4].title,
      reason: 'Suspected price manipulation',
      reportedAt: DateTime.now().subtract(const Duration(days: 1)),
      status: 'Under review',
    ),
    ModerationReport(
      id: 'r3',
      listingTitle: _listings[2].title,
      reason: 'Missing ownership documents',
      reportedAt: DateTime.now().subtract(const Duration(days: 2)),
      status: 'Resolved',
    ),
  ];

  Future<List<Category>> fetchCategories() async {
    await Future.delayed(_delay);
    return List<Category>.from(_categories);
  }

  Future<List<Listing>> fetchFeaturedListings() async {
    await Future.delayed(_delay);
    return _listings.where((listing) => listing.isFeatured).toList();
  }

  Future<List<Listing>> fetchLatestListings() async {
    await Future.delayed(_delay);
    final sorted = List<Listing>.from(_listings)
      ..sort((a, b) => b.postedAt.compareTo(a.postedAt));
    return sorted;
  }

  Future<List<Listing>> searchListings(ListingsSearchQuery query) async {
    await Future.delayed(_delay);
    Iterable<Listing> results = _listings;
    if (query.query.isNotEmpty) {
      final q = query.query.toLowerCase();
      results = results.where((listing) {
        return listing.title.toLowerCase().contains(q) ||
            listing.description.toLowerCase().contains(q) ||
            listing.categoryName.toLowerCase().contains(q);
      });
    }
    if (query.categoryId != null && query.categoryId!.isNotEmpty) {
      results = results.where((listing) => listing.categoryId == query.categoryId);
    }
    if (query.condition != null && query.condition!.isNotEmpty) {
      results = results.where((listing) => listing.condition == query.condition);
    }
    if (query.minPrice != null) {
      results = results.where((listing) => listing.price >= query.minPrice!);
    }
    if (query.maxPrice != null) {
      results = results.where((listing) => listing.price <= query.maxPrice!);
    }

    final list = results.toList();
    switch (query.sort) {
      case ListingSort.priceLowToHigh:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ListingSort.priceHighToLow:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ListingSort.newest:
        list.sort((a, b) => b.postedAt.compareTo(a.postedAt));
        break;
      case ListingSort.relevance:
        break;
    }

    return list;
  }

  Future<Listing?> fetchListing(String id) async {
    await Future.delayed(_delay);
    try {
      return _listings.firstWhere((listing) => listing.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<Listing>> fetchListingsBySeller(String sellerId) async {
    await Future.delayed(_delay);
    return _listings.where((listing) => listing.seller.id == sellerId).toList();
  }

  Future<Listing> createListing(ListingDraft draft) async {
    await Future.delayed(_delay);
    final category = _categories.firstWhere(
      (item) => item.id == draft.categoryId,
      orElse: () => _categories.first,
    );
    final listing = Listing(
      id: 'l${_listings.length + 1}',
      title: draft.title,
      description: draft.description,
      price: draft.price,
      currency: AppConstants.currency,
      location: draft.location,
      condition: draft.condition,
      categoryId: category.id,
      categoryName: category.name,
      imageUrls: draft.imageUrls.isEmpty
          ? const [
              'https://images.unsplash.com/photo-1489515217757-5fd1be406fef?auto=format&fit=crop&w=800&q=60',
            ]
          : draft.imageUrls,
      seller: Seller(
        id: _profile.id,
        name: _profile.name,
        avatarUrl: _profile.avatarUrl,
        rating: _profile.rating,
        isVerified: _profile.isVerified,
        phone: '+251 900 100 200',
        whatsapp: '+251 900 100 200',
      ),
      postedAt: DateTime.now(),
      isFeatured: false,
      attributes: draft.attributes,
    );
    _listings.insert(0, listing);
    return listing;
  }

  Future<UserProfile> fetchProfile() async {
    await Future.delayed(_delay);
    return _profile;
  }

  Future<List<Conversation>> fetchConversations() async {
    await Future.delayed(_delay);
    return List<Conversation>.from(_conversations);
  }

  Future<Conversation?> fetchConversation(String id) async {
    await Future.delayed(_delay);
    try {
      return _conversations.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<Message>> fetchMessages(String conversationId) async {
    await Future.delayed(_delay);
    return List<Message>.from(_messages[conversationId] ?? []);
  }

  Future<Message> sendMessage(String conversationId, String text) async {
    await Future.delayed(_delay);
    final message = Message(
      id: 'm${_random.nextInt(9999)}',
      conversationId: conversationId,
      senderId: _profile.id,
      text: text,
      sentAt: DateTime.now(),
      isMine: true,
    );
    final list = _messages.putIfAbsent(conversationId, () => []);
    list.add(message);

    final index = _conversations.indexWhere((item) => item.id == conversationId);
    if (index != -1) {
      _conversations[index] = _conversations[index].copyWith(
        lastMessage: message,
        unreadCount: 0,
      );
    }
    return message;
  }

  Future<List<ModerationReport>> fetchReports() async {
    await Future.delayed(_delay);
    return List<ModerationReport>.from(_reports);
  }
}
