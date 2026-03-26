import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/core/di/dependancy_manager.dart';
import 'package:emun/features/home/presentation/pages/home_screen.dart';
import 'package:emun/features/listings/application/home_cubit.dart';
import 'package:emun/features/listings/presentation/pages/create/create_listing_screen.dart';
import 'package:emun/features/messages/application/inbox_cubit.dart';
import 'package:emun/features/messages/presentation/pages/inbox/inbox_screen.dart';
import 'package:emun/features/profile/application/profile_cubit.dart';
import 'package:emun/features/profile/presentation/pages/profile_screen.dart';
import 'package:emun/features/search/application/search_cubit.dart';
import 'package:emun/features/search/presentation/pages/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  void setTab(int index) {
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<HomeCubit>()..load()),
        BlocProvider(create: (_) => getIt<SearchCubit>()..load()),
        BlocProvider(create: (_) => getIt<InboxCubit>()..load()),
        BlocProvider(create: (_) => getIt<ProfileCubit>()..load()),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: [
            HomeScreen(onSearchTap: () => setTab(1)),
            const SearchScreen(),
            const CreateListingScreen(),
            const InboxScreen(),
            const ProfileScreen(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: setTab,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.search_outlined), label: 'Search'),
            NavigationDestination(icon: Icon(Icons.add_circle_outline), label: 'Sell'),
            NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Messages'),
            NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
