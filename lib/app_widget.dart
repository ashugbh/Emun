import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/core/application/app/bloc/app_bloc.dart';
import 'package:emun/core/application/app/bloc/app_state.dart';
import 'package:emun/core/di/dependancy_manager.dart';
import 'package:emun/core/router/router.dart';
import 'package:emun/core/theme/app_theme.dart';
import 'package:emun/features/listings/application/bloc/favorites_bloc.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesBloc = getIt<FavoritesBloc>()..load();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppBloc()),
        BlocProvider.value(value: favoritesBloc),
      ],
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) => MaterialApp.router(
          title: 'Emun',
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
