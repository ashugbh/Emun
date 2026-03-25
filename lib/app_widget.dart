import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/core/di/dependancy_manager.dart';
import 'package:emun/core/router/router.dart';
import 'package:emun/core/theme/app_theme.dart';
import 'package:emun/features/listings/application/favorites_cubit.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesCubit = getIt<FavoritesCubit>()..load();
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: favoritesCubit),
      ],
      child: MaterialApp.router(
        title: 'Emun',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.light,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
