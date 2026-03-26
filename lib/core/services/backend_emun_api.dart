import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:emun/core/constants/app_constants.dart';
import 'package:emun/features/admin/domain/entities/moderation_report.dart';
import 'package:emun/features/listings/domain/entities/category.dart';
import 'package:emun/features/listings/domain/entities/listing.dart';
import 'package:emun/features/listings/domain/entities/listing_draft.dart';
import 'package:emun/features/listings/domain/entities/search_query.dart';
import 'package:emun/features/messages/domain/entities/conversation.dart';
import 'package:emun/features/messages/domain/entities/message.dart';
import 'package:emun/features/profile/domain/entities/user_profile.dart';

class ApiRequestException implements Exception {
  const ApiRequestException(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  String toString() => message;
}

class BackendEmunApi {
  BackendEmunApi({http.Client? httpClient, String? baseUrl})
    : _httpClient = httpClient ?? http.Client(),
      _baseUrl = (baseUrl ?? AppConstants.apiBaseUrl).replaceAll(
        RegExp(r'/$'),
        '',
      );

  final http.Client _httpClient;
  final String _baseUrl;

  String? _accessToken;
  String? _refreshToken;
  String? _currentUserId;

  static const String _fallbackImage =
      'https://images.unsplash.com/photo-1489515217757-5fd1be406fef?auto=format&fit=crop&w=800&q=60';
  static const String _fallbackAvatar =
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=400&q=60';

  bool get isAuthenticated => _accessToken != null && _currentUserId != null;
  String? get currentUserId => _currentUserId;

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    final payload = await _requestMap(
      'POST',
      '/auth/login/',
      body: {'identifier': identifier.trim(), 'password': password},
    );
    _applyAuthPayload(payload);
  }

  Future<void> register({
    required String name,
    required String identifier,
    required String password,
  }) async {
    final cleanIdentifier = identifier.trim();
    final isEmail = cleanIdentifier.contains('@');
    final payload = await _requestMap(
      'POST',
      '/auth/register/',
      body: {
        'name': name.trim(),
        'password': password,
        'password_confirm': password,
        'role': 'buyer',
        if (isEmail) 'email': cleanIdentifier,
        if (!isEmail) 'phone_number': cleanIdentifier,
      },
    );
    _applyAuthPayload(payload);
  }

  Future<void> logout() async {
    try {
      if (_refreshToken != null) {
        await _request(
          'POST',
          '/auth/logout/',
          authenticated: true,
          body: {'refresh': _refreshToken},
        );
      }
    } catch (_) {
      // Ignore network errors during logout and clear local session anyway.
    } finally {
      _accessToken = null;
      _refreshToken = null;
      _currentUserId = null;
    }
  }

  Future<UserProfile> fetchProfile() async {
    final payload = await _requestMap('GET', '/auth/me/', authenticated: true);
    return _toUserProfile(payload);
  }

  Future<List<Category>> fetchCategories() async {
    final payload = await _requestList('GET', '/categories/');
    return payload.map(_toCategory).toList(growable: false);
  }

  Future<List<Listing>> fetchFeaturedListings() async {
    final payload = await _requestList('GET', '/listings/featured/');
    return payload.map(_toListing).toList(growable: false);
  }

  Future<List<Listing>> fetchLatestListings() async {
    final payload = await _requestList(
      'GET',
      '/listings/',
      queryParameters: const {'sort': 'newest'},
    );
    return payload.map(_toListing).toList(growable: false);
  }

  Future<List<Listing>> searchListings(ListingsSearchQuery query) async {
    final payload = await _requestList(
      'GET',
      '/listings/',
      queryParameters: {
        if (query.query.trim().isNotEmpty) 'query': query.query.trim(),
        if (query.categoryId != null && query.categoryId!.isNotEmpty)
          'categoryId': query.categoryId,
        if (query.condition != null && query.condition!.isNotEmpty)
          'condition': _conditionToApi(query.condition!),
        if (query.minPrice != null) 'minPrice': query.minPrice!.toString(),
        if (query.maxPrice != null) 'maxPrice': query.maxPrice!.toString(),
        'sort': _sortToApi(query.sort),
      },
    );
    return payload.map(_toListing).toList(growable: false);
  }

  Future<Listing?> fetchListing(String id) async {
    try {
      final payload = await _requestMap('GET', '/listings/$id/');
      return _toListing(payload);
    } on ApiRequestException catch (error) {
      if (error.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  Future<List<Listing>> fetchListingsBySeller(String sellerId) async {
    final payload = await _requestList(
      'GET',
      '/listings/',
      queryParameters: {'sellerId': sellerId},
    );
    return payload.map(_toListing).toList(growable: false);
  }

  Future<List<Listing>> fetchRelatedListings({
    required String categoryId,
    required String excludeListingId,
  }) async {
    final payload = await _requestList(
      'GET',
      '/listings/$excludeListingId/related/',
    );
    return payload.map(_toListing).toList(growable: false);
  }

  Future<Listing> createListing(ListingDraft draft) async {
    final payload = await _requestMap(
      'POST',
      '/listings/',
      authenticated: true,
      body: {
        'title': draft.title.trim(),
        'description': draft.description.trim(),
        'price': draft.price,
        'currency': AppConstants.currency,
        'location': draft.location.trim(),
        'condition': _conditionToApi(draft.condition),
        'categoryId': draft.categoryId,
        'subcategory': draft.categoryName,
        'imageUrls': draft.imageUrls,
        'attributes': draft.attributes,
        'status': 'active',
      },
    );
    return _toListing(payload);
  }

  Future<Set<String>> fetchFavoriteIds() async {
    if (!isAuthenticated) {
      return <String>{};
    }
    final payload = await _requestMap(
      'GET',
      '/favorites/',
      authenticated: true,
    );
    final ids = _asList(
      payload['favorites'],
    ).map((item) => _asString(item)).whereType<String>();
    return ids.toSet();
  }

  Future<void> toggleFavorite(String listingId) async {
    if (!isAuthenticated) {
      return;
    }
    final parsedId = int.tryParse(listingId);
    if (parsedId == null) {
      return;
    }
    await _request(
      'POST',
      '/favorites/toggle/',
      authenticated: true,
      body: {'listingId': parsedId},
    );
  }

  Future<List<Conversation>> fetchConversations() async {
    if (!isAuthenticated) {
      return <Conversation>[];
    }
    final payload = await _requestList(
      'GET',
      '/conversations/',
      authenticated: true,
    );
    return payload.map(_toConversation).toList(growable: false);
  }

  Future<Conversation?> fetchConversation(String id) async {
    if (!isAuthenticated) {
      return null;
    }
    try {
      final payload = await _requestMap(
        'GET',
        '/conversations/$id/',
        authenticated: true,
      );
      return _toConversation(payload);
    } on ApiRequestException catch (error) {
      if (error.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  Future<List<Message>> fetchMessages(String conversationId) async {
    if (!isAuthenticated) {
      return <Message>[];
    }
    final payload = await _requestList(
      'GET',
      '/conversations/$conversationId/messages/',
      authenticated: true,
    );
    return payload
        .map((item) => _toMessage(item, fallbackConversationId: conversationId))
        .toList(growable: false);
  }

  Future<Message> sendMessage(String conversationId, String text) async {
    final payload = await _requestMap(
      'POST',
      '/conversations/$conversationId/send/',
      authenticated: true,
      body: {'text': text},
    );
    return _toMessage(payload, fallbackConversationId: conversationId);
  }

  Future<List<ModerationReport>> fetchReports() async {
    if (!isAuthenticated) {
      return <ModerationReport>[];
    }
    final payload = await _requestList('GET', '/reports/', authenticated: true);
    return payload.map(_toModerationReport).toList(growable: false);
  }

  Future<dynamic> _request(
    String method,
    String path, {
    bool authenticated = false,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool canRetry = true,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl$path',
    ).replace(queryParameters: _normalizeQueryParameters(queryParameters));
    final headers = <String, String>{
      'Accept': 'application/json',
      if (body != null) 'Content-Type': 'application/json',
      if (authenticated && _accessToken != null)
        'Authorization': 'Bearer $_accessToken',
    };

    final response = await _sendRequest(
      method,
      uri,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 401 && authenticated && canRetry) {
      final refreshed = await _refreshTokenIfPossible();
      if (refreshed) {
        return _request(
          method,
          path,
          authenticated: authenticated,
          body: body,
          queryParameters: queryParameters,
          canRetry: false,
        );
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.trim().isEmpty) {
        return null;
      }
      return jsonDecode(utf8.decode(response.bodyBytes));
    }

    throw ApiRequestException(
      _extractErrorMessage(response),
      response.statusCode,
    );
  }

  Future<List<Map<String, dynamic>>> _requestList(
    String method,
    String path, {
    bool authenticated = false,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool canRetry = true,
  }) async {
    final payload = await _request(
      method,
      path,
      authenticated: authenticated,
      body: body,
      queryParameters: queryParameters,
      canRetry: canRetry,
    );
    return _asList(payload).map(_asMap).toList(growable: false);
  }

  Future<Map<String, dynamic>> _requestMap(
    String method,
    String path, {
    bool authenticated = false,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool canRetry = true,
  }) async {
    final payload = await _request(
      method,
      path,
      authenticated: authenticated,
      body: body,
      queryParameters: queryParameters,
      canRetry: canRetry,
    );
    return _asMap(payload);
  }

  Future<http.Response> _sendRequest(
    String method,
    Uri uri, {
    required Map<String, String> headers,
    Map<String, dynamic>? body,
  }) {
    final encodedBody = body == null ? null : jsonEncode(body);

    switch (method.toUpperCase()) {
      case 'GET':
        return _httpClient.get(uri, headers: headers);
      case 'POST':
        return _httpClient.post(uri, headers: headers, body: encodedBody);
      case 'PATCH':
        return _httpClient.patch(uri, headers: headers, body: encodedBody);
      case 'PUT':
        return _httpClient.put(uri, headers: headers, body: encodedBody);
      case 'DELETE':
        return _httpClient.delete(uri, headers: headers, body: encodedBody);
      default:
        throw ArgumentError.value(method, 'method', 'Unsupported HTTP method');
    }
  }

  Future<bool> _refreshTokenIfPossible() async {
    if (_refreshToken == null) {
      return false;
    }
    try {
      final payload = await _requestMap(
        'POST',
        '/auth/token/refresh/',
        body: {'refresh': _refreshToken},
        canRetry: false,
      );
      final access = _asString(payload['access']);
      if (access == null || access.isEmpty) {
        return false;
      }
      _accessToken = access;
      if (payload['refresh'] != null) {
        _refreshToken = _asString(payload['refresh']);
      }
      return true;
    } catch (_) {
      _accessToken = null;
      _refreshToken = null;
      _currentUserId = null;
      return false;
    }
  }

  void _applyAuthPayload(Map<String, dynamic> payload) {
    final tokens = _asMap(payload['tokens']);
    final user = _asMap(payload['user']);
    _accessToken = _asString(tokens['access']);
    _refreshToken = _asString(tokens['refresh']);
    _currentUserId = _asString(user['id']);
  }

  Conversation _toConversation(Map<String, dynamic> payload) {
    final listingPayload = _asMap(payload['listing']);
    final conversationId = _asString(payload['id']) ?? '';
    final lastMessagePayload = _asMap(payload['lastMessage']);

    final lastMessage = lastMessagePayload.isEmpty
        ? Message(
            id: '${conversationId}_latest',
            conversationId: conversationId,
            senderId: '',
            text: '',
            sentAt: DateTime.now(),
            isMine: false,
          )
        : _toMessage(
            lastMessagePayload,
            fallbackConversationId: conversationId,
          );

    return Conversation(
      id: conversationId,
      listing: ListingSummary(
        id: _asString(listingPayload['id']) ?? '',
        title: _asString(listingPayload['title']) ?? '',
        imageUrl: _asString(listingPayload['imageUrl']) ?? _fallbackImage,
        price: _asDouble(listingPayload['price']),
      ),
      otherUserName: _asString(payload['otherUserName']) ?? 'Seller',
      otherUserAvatar: _asString(payload['otherUserAvatar']) ?? _fallbackAvatar,
      lastMessage: lastMessage,
      unreadCount: _asInt(payload['unreadCount']),
    );
  }

  Message _toMessage(
    Map<String, dynamic> payload, {
    String fallbackConversationId = '',
  }) {
    final senderId =
        _asString(payload['senderId']) ?? _asString(payload['sender_id']) ?? '';
    final isMine = payload['isMine'] is bool
        ? payload['isMine'] as bool
        : (_currentUserId != null && senderId == _currentUserId);

    return Message(
      id: _asString(payload['id']) ?? '',
      conversationId:
          _asString(payload['conversationId']) ?? fallbackConversationId,
      senderId: senderId,
      text: _asString(payload['text']) ?? '',
      sentAt: _asDateTime(payload['sentAt']) ?? DateTime.now(),
      isMine: isMine,
    );
  }

  Listing _toListing(Map<String, dynamic> payload) {
    final imageUrls = _asStringList(payload['imageUrls']);
    final sellerPayload = _asMap(payload['seller']);
    final categoryId = _asString(payload['categoryId']) ?? '';
    final categoryName = _asString(payload['categoryName']) ?? '';

    return Listing(
      id: _asString(payload['id']) ?? '',
      title: _asString(payload['title']) ?? '',
      description: _asString(payload['description']) ?? '',
      price: _asDouble(payload['price']),
      currency: _asString(payload['currency']) ?? AppConstants.currency,
      location: _asString(payload['location']) ?? '',
      condition: _conditionFromApi(_asString(payload['condition']) ?? ''),
      categoryId: categoryId,
      categoryName: categoryName,
      imageUrls: imageUrls.isEmpty ? const [_fallbackImage] : imageUrls,
      seller: _toSeller(sellerPayload),
      postedAt: _asDateTime(payload['postedAt']) ?? DateTime.now(),
      isFeatured: _asBool(payload['isFeatured']),
      attributes: _asStringMap(payload['attributes']),
    );
  }

  Seller _toSeller(Map<String, dynamic> payload) {
    return Seller(
      id: _asString(payload['id']) ?? '',
      name:
          _asString(payload['name']) ??
          _asString(payload['username']) ??
          'Seller',
      avatarUrl: _asString(payload['avatarUrl']) ?? _fallbackAvatar,
      rating: _asDouble(payload['rating']),
      isVerified: _asBool(payload['isVerified']),
      phone:
          _asString(payload['phone']) ??
          _asString(payload['phone_number']) ??
          '',
      whatsapp:
          _asString(payload['whatsapp']) ??
          _asString(payload['phone']) ??
          _asString(payload['phone_number']) ??
          '',
    );
  }

  Category _toCategory(Map<String, dynamic> payload) {
    return Category(
      id: _asString(payload['slug']) ?? _asString(payload['id']) ?? '',
      name: _asString(payload['name']) ?? '',
      icon: _iconFromName(_asString(payload['icon']) ?? ''),
      color: _parseColor(
        _asString(payload['color_hex']) ?? _asString(payload['colorHex']),
      ),
      subcategories: _asStringList(payload['subcategories']),
    );
  }

  UserProfile _toUserProfile(Map<String, dynamic> payload) {
    return UserProfile(
      id: _asString(payload['id']) ?? '',
      name: _asString(payload['name']) ?? '',
      avatarUrl: _asString(payload['avatar_url']) ?? _fallbackAvatar,
      location: _asString(payload['location']) ?? '',
      bio: _asString(payload['bio']) ?? '',
      rating: _asDouble(payload['rating']),
      isVerified: _asBool(payload['is_verified']),
      listingsCount: _asInt(payload['listings_count']),
      soldCount: _asInt(payload['sold_count']),
    );
  }

  ModerationReport _toModerationReport(Map<String, dynamic> payload) {
    return ModerationReport(
      id: _asString(payload['id']) ?? '',
      listingTitle: _asString(payload['listingTitle']) ?? 'Unknown listing',
      reason: _asString(payload['reason']) ?? '',
      reportedAt: _asDateTime(payload['reportedAt']) ?? DateTime.now(),
      status: _humanizeStatus(_asString(payload['status']) ?? ''),
    );
  }

  IconData _iconFromName(String iconName) {
    const iconMap = <String, IconData>{
      'home_outlined': Icons.home_outlined,
      'smartphone_outlined': Icons.smartphone_outlined,
      'laptop_outlined': Icons.laptop_outlined,
      'directions_car_outlined': Icons.directions_car_outlined,
      'kitchen_outlined': Icons.kitchen_outlined,
      'chair_outlined': Icons.chair_outlined,
      'shopping_bag_outlined': Icons.shopping_bag_outlined,
      'category_outlined': Icons.category_outlined,
    };
    return iconMap[iconName] ?? Icons.category_outlined;
  }

  Color _parseColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return const Color(0xFF136D6D);
    }
    final clean = hexColor.replaceFirst('#', '');
    final withAlpha = clean.length == 6 ? 'FF$clean' : clean;
    final value = int.tryParse(withAlpha, radix: 16);
    if (value == null) {
      return const Color(0xFF136D6D);
    }
    return Color(value);
  }

  String _sortToApi(ListingSort sort) {
    switch (sort) {
      case ListingSort.newest:
        return 'newest';
      case ListingSort.priceLowToHigh:
        return 'priceLowToHigh';
      case ListingSort.priceHighToLow:
        return 'priceHighToLow';
      case ListingSort.relevance:
        return 'relevance';
    }
  }

  String _conditionFromApi(String condition) {
    final value = condition.trim().toLowerCase();
    switch (value) {
      case 'new':
        return 'New';
      case 'used':
        return 'Used';
      case 'refurbished':
        return 'Refurbished';
      default:
        return condition;
    }
  }

  String _conditionToApi(String condition) {
    return condition.trim().toLowerCase();
  }

  String _humanizeStatus(String value) {
    return value
        .split('_')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  String _extractErrorMessage(http.Response response) {
    try {
      final payload = jsonDecode(utf8.decode(response.bodyBytes));
      if (payload is Map<String, dynamic>) {
        final detail = payload['detail'];
        if (detail is String && detail.isNotEmpty) {
          return detail;
        }

        final nonFieldErrors = payload['non_field_errors'];
        if (nonFieldErrors is List && nonFieldErrors.isNotEmpty) {
          return nonFieldErrors.first.toString();
        }

        for (final entry in payload.entries) {
          final value = entry.value;
          if (value is List && value.isNotEmpty) {
            return value.first.toString();
          }
          if (value is String && value.isNotEmpty) {
            return value;
          }
        }
      }
    } catch (_) {
      // Ignore parse failures and use fallback.
    }
    return 'Request failed (${response.statusCode}).';
  }

  Map<String, String>? _normalizeQueryParameters(Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) {
      return null;
    }

    final normalized = <String, String>{};
    for (final entry in params.entries) {
      final value = entry.value;
      if (value == null) {
        continue;
      }
      final text = value.toString();
      if (text.isEmpty) {
        continue;
      }
      normalized[entry.key] = text;
    }
    return normalized.isEmpty ? null : normalized;
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((key, dynamic item) => MapEntry(key.toString(), item));
    }
    return <String, dynamic>{};
  }

  List<dynamic> _asList(dynamic value) {
    if (value is List) {
      return value;
    }
    return <dynamic>[];
  }

  String? _asString(dynamic value) {
    if (value == null) {
      return null;
    }
    return value.toString();
  }

  int _asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  double _asDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  bool _asBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    final normalized = value?.toString().toLowerCase();
    return normalized == 'true' || normalized == '1';
  }

  DateTime? _asDateTime(dynamic value) {
    if (value is DateTime) {
      return value;
    }
    final text = value?.toString();
    if (text == null || text.isEmpty) {
      return null;
    }
    return DateTime.tryParse(text);
  }

  List<String> _asStringList(dynamic value) {
    return _asList(
      value,
    ).map((item) => item.toString()).where((item) => item.isNotEmpty).toList();
  }

  Map<String, String> _asStringMap(dynamic value) {
    final map = _asMap(value);
    return map.map(
      (key, dynamic mapValue) => MapEntry(key, mapValue.toString()),
    );
  }
}
