import 'package:get_it/get_it.dart';
import 'package:emun/core/constants/app_constants.dart';
import 'package:emun/core/services/backend_emun_api.dart';
import 'package:emun/core/services/fake_emun_api.dart';
import 'package:emun/features/admin/application/admin_cubit.dart';
import 'package:emun/features/admin/domain/repositories/admin_repository.dart';
import 'package:emun/features/admin/infrastructure/api_admin_repository.dart';
import 'package:emun/features/admin/infrastructure/fake_admin_repository.dart';
import 'package:emun/features/auth/application/auth_cubit.dart';
import 'package:emun/features/auth/domain/auth_repository.dart';
import 'package:emun/features/auth/infrastructure/api_auth_repository.dart';
import 'package:emun/features/auth/infrastructure/fake_auth_repository.dart';
import 'package:emun/features/listings/application/create_listing_cubit.dart';
import 'package:emun/features/listings/application/favorites_cubit.dart';
import 'package:emun/features/listings/application/home_cubit.dart';
import 'package:emun/features/listings/application/listing_detail_cubit.dart';
import 'package:emun/features/listings/domain/repositories/favorites_repository.dart';
import 'package:emun/features/listings/domain/repositories/listings_repository.dart';
import 'package:emun/features/listings/infrastructure/api_favorites_repository.dart';
import 'package:emun/features/listings/infrastructure/api_listings_repository.dart';
import 'package:emun/features/listings/infrastructure/fake_favorites_repository.dart';
import 'package:emun/features/listings/infrastructure/fake_listings_repository.dart';
import 'package:emun/features/messages/application/chat_cubit.dart';
import 'package:emun/features/messages/application/inbox_cubit.dart';
import 'package:emun/features/messages/domain/repositories/messages_repository.dart';
import 'package:emun/features/messages/infrastructure/api_messages_repository.dart';
import 'package:emun/features/messages/infrastructure/fake_messages_repository.dart';
import 'package:emun/features/profile/application/profile_cubit.dart';
import 'package:emun/features/profile/domain/repositories/profile_repository.dart';
import 'package:emun/features/profile/infrastructure/api_profile_repository.dart';
import 'package:emun/features/profile/infrastructure/fake_profile_repository.dart';
import 'package:emun/features/search/application/search_cubit.dart';

final GetIt getIt = GetIt.instance;

void configureDependencies() {
  if (getIt.isRegistered<AuthRepository>()) {
    return;
  }

  if (AppConstants.useFakeApi) {
    getIt.registerLazySingleton<FakeEmunApi>(() => FakeEmunApi());

    getIt.registerLazySingleton<AuthRepository>(() => FakeAuthRepository());
    getIt.registerLazySingleton<ListingsRepository>(
      () => FakeListingsRepository(getIt<FakeEmunApi>()),
    );
    getIt.registerLazySingleton<FavoritesRepository>(
      () => FakeFavoritesRepository(),
    );
    getIt.registerLazySingleton<MessagesRepository>(
      () => FakeMessagesRepository(getIt<FakeEmunApi>()),
    );
    getIt.registerLazySingleton<ProfileRepository>(
      () => FakeProfileRepository(getIt<FakeEmunApi>()),
    );
    getIt.registerLazySingleton<AdminRepository>(
      () => FakeAdminRepository(getIt<FakeEmunApi>()),
    );
  } else {
    getIt.registerLazySingleton<BackendEmunApi>(() => BackendEmunApi());

    getIt.registerLazySingleton<AuthRepository>(
      () => ApiAuthRepository(getIt<BackendEmunApi>()),
    );
    getIt.registerLazySingleton<ListingsRepository>(
      () => ApiListingsRepository(getIt<BackendEmunApi>()),
    );
    getIt.registerLazySingleton<FavoritesRepository>(
      () => ApiFavoritesRepository(getIt<BackendEmunApi>()),
    );
    getIt.registerLazySingleton<MessagesRepository>(
      () => ApiMessagesRepository(getIt<BackendEmunApi>()),
    );
    getIt.registerLazySingleton<ProfileRepository>(
      () => ApiProfileRepository(getIt<BackendEmunApi>()),
    );
    getIt.registerLazySingleton<AdminRepository>(
      () => ApiAdminRepository(getIt<BackendEmunApi>()),
    );
  }

  getIt.registerFactory(() => AuthCubit(getIt<AuthRepository>()));
  getIt.registerFactory(() => HomeCubit(getIt<ListingsRepository>()));
  getIt.registerFactory(() => SearchCubit(getIt<ListingsRepository>()));
  getIt.registerFactoryParam<ListingDetailCubit, String, void>(
    (listingId, _) =>
        ListingDetailCubit(getIt<ListingsRepository>(), listingId),
  );
  getIt.registerFactory(() => CreateListingCubit(getIt<ListingsRepository>()));
  getIt.registerLazySingleton(
    () => FavoritesCubit(getIt<FavoritesRepository>()),
  );
  getIt.registerFactory(() => InboxCubit(getIt<MessagesRepository>()));
  getIt.registerFactoryParam<ChatCubit, String, void>(
    (conversationId, _) =>
        ChatCubit(getIt<MessagesRepository>(), conversationId),
  );
  getIt.registerFactory(
    () => ProfileCubit(getIt<ProfileRepository>(), getIt<ListingsRepository>()),
  );
  getIt.registerFactory(() => AdminCubit(getIt<AdminRepository>()));
}
