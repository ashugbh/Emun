import 'package:get_it/get_it.dart';
import 'package:emun/core/constants/app_constants.dart';
import 'package:emun/core/services/backend_emun_api.dart';
import 'package:emun/core/services/fake_emun_api.dart';
import 'package:emun/features/admin/application/bloc/admin_bloc.dart';
import 'package:emun/features/admin/domain/repositories/admin_repository.dart';
import 'package:emun/features/admin/infrastructure/datasources/admin_remote_data_source.dart';
import 'package:emun/features/admin/infrastructure/repositories/admin_repository_impl.dart';
import 'package:emun/features/auth/application/bloc/auth_bloc.dart';
import 'package:emun/features/auth/domain/auth_repository.dart';
import 'package:emun/features/auth/infrastructure/datasources/auth_remote_data_source.dart';
import 'package:emun/features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:emun/features/listings/application/bloc/create_listing_bloc.dart';
import 'package:emun/features/listings/application/bloc/favorites_bloc.dart';
import 'package:emun/features/listings/application/bloc/home_bloc.dart';
import 'package:emun/features/listings/application/bloc/listing_detail_bloc.dart';
import 'package:emun/features/listings/domain/repositories/favorites_repository.dart';
import 'package:emun/features/listings/domain/repositories/listings_repository.dart';
import 'package:emun/features/listings/infrastructure/datasources/favorites_remote_data_source.dart';
import 'package:emun/features/listings/infrastructure/datasources/listings_remote_data_source.dart';
import 'package:emun/features/listings/infrastructure/repositories/favorites_repository_impl.dart';
import 'package:emun/features/listings/infrastructure/repositories/listings_repository_impl.dart';
import 'package:emun/features/messages/application/bloc/chat_bloc.dart';
import 'package:emun/features/messages/application/bloc/inbox_bloc.dart';
import 'package:emun/features/messages/domain/repositories/messages_repository.dart';
import 'package:emun/features/messages/infrastructure/datasources/messages_remote_data_source.dart';
import 'package:emun/features/messages/infrastructure/repositories/messages_repository_impl.dart';
import 'package:emun/features/profile/application/bloc/profile_bloc.dart';
import 'package:emun/features/profile/domain/repositories/profile_repository.dart';
import 'package:emun/features/profile/infrastructure/datasources/profile_remote_data_source.dart';
import 'package:emun/features/profile/infrastructure/repositories/profile_repository_impl.dart';
import 'package:emun/features/search/application/bloc/search_bloc.dart';

final GetIt getIt = GetIt.instance;

void configureDependencies() {
  if (getIt.isRegistered<AuthRepository>()) {
    return;
  }

  if (AppConstants.useFakeApi) {
    getIt.registerLazySingleton<FakeEmunApi>(() => FakeEmunApi());

    getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => FakeAuthRemoteDataSource(),
    );
    getIt.registerLazySingleton<ListingsRemoteDataSource>(
      () => FakeListingsRemoteDataSource(getIt<FakeEmunApi>()),
    );
    getIt.registerLazySingleton<FavoritesRemoteDataSource>(
      () => FakeFavoritesRemoteDataSource(),
    );
    getIt.registerLazySingleton<MessagesRemoteDataSource>(
      () => FakeMessagesRemoteDataSource(getIt<FakeEmunApi>()),
    );
    getIt.registerLazySingleton<ProfileRemoteDataSource>(
      () => FakeProfileRemoteDataSource(getIt<FakeEmunApi>()),
    );
    getIt.registerLazySingleton<AdminRemoteDataSource>(
      () => FakeAdminRemoteDataSource(getIt<FakeEmunApi>()),
    );
  } else {
    getIt.registerLazySingleton<BackendEmunApi>(() => BackendEmunApi());

    getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => ApiAuthRemoteDataSource(getIt<BackendEmunApi>()),
    );
    getIt.registerLazySingleton<ListingsRemoteDataSource>(
      () => ApiListingsRemoteDataSource(getIt<BackendEmunApi>()),
    );
    getIt.registerLazySingleton<FavoritesRemoteDataSource>(
      () => ApiFavoritesRemoteDataSource(getIt<BackendEmunApi>()),
    );
    getIt.registerLazySingleton<MessagesRemoteDataSource>(
      () => ApiMessagesRemoteDataSource(getIt<BackendEmunApi>()),
    );
    getIt.registerLazySingleton<ProfileRemoteDataSource>(
      () => ApiProfileRemoteDataSource(getIt<BackendEmunApi>()),
    );
    getIt.registerLazySingleton<AdminRemoteDataSource>(
      () => ApiAdminRemoteDataSource(getIt<BackendEmunApi>()),
    );
  }

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );
  getIt.registerLazySingleton<ListingsRepository>(
    () => ListingsRepositoryImpl(getIt<ListingsRemoteDataSource>()),
  );
  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(getIt<FavoritesRemoteDataSource>()),
  );
  getIt.registerLazySingleton<MessagesRepository>(
    () => MessagesRepositoryImpl(getIt<MessagesRemoteDataSource>()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<ProfileRemoteDataSource>()),
  );
  getIt.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(getIt<AdminRemoteDataSource>()),
  );

  getIt.registerFactory(() => AuthBloc(getIt<AuthRepository>()));
  getIt.registerFactory(() => HomeBloc(getIt<ListingsRepository>()));
  getIt.registerFactory(() => SearchBloc(getIt<ListingsRepository>()));
  getIt.registerFactoryParam<ListingDetailBloc, String, void>(
    (listingId, _) =>
        ListingDetailBloc(getIt<ListingsRepository>(), listingId),
  );
  getIt.registerFactory(() => CreateListingBloc(getIt<ListingsRepository>()));
  getIt.registerLazySingleton(
    () => FavoritesBloc(getIt<FavoritesRepository>()),
  );
  getIt.registerFactory(() => InboxBloc(getIt<MessagesRepository>()));
  getIt.registerFactoryParam<ChatBloc, String, void>(
    (conversationId, _) => ChatBloc(getIt<MessagesRepository>(), conversationId),
  );
  getIt.registerFactory(
    () => ProfileBloc(getIt<ProfileRepository>(), getIt<ListingsRepository>()),
  );
  getIt.registerFactory(() => AdminBloc(getIt<AdminRepository>()));
}
