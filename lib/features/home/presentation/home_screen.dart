import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/core/design_system/emun_design_system.dart';
import 'package:emun/core/theme/app_colors.dart';
import 'package:emun/core/widgets/section_header.dart';
import 'package:emun/features/listings/application/favorites_cubit.dart';
import 'package:emun/features/listings/application/home_cubit.dart';
import 'package:emun/features/listings/presentation/widgets/category_chip.dart';
import 'package:emun/features/listings/presentation/widgets/listing_card.dart';
import 'package:emun/core/router/route_name.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onSearchTap});

  final VoidCallback onSearchTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.isLoading && state.categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final favorites = context.watch<FavoritesCubit>();

        return SafeArea(
          child: RefreshIndicator(
            onRefresh: () => context.read<HomeCubit>().load(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _HeroHeader(onSearchTap: onSearchTap),
                const SizedBox(height: 20),
                SectionHeader(
                  title: 'Categories',
                  actionLabel: 'Browse',
                  onAction: onSearchTap,
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: state.categories
                        .map((category) => Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: CategoryChip(
                                category: category,
                                onTap: onSearchTap,
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 20),
                SectionHeader(
                  title: 'Featured listings',
                  actionLabel: 'See all',
                  onAction: onSearchTap,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 300,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.featured.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final listing = state.featured[index];
                      return SizedBox(
                        width: 240,
                        child: ListingCard(
                          listing: listing,
                          compact: true,
                          isFavorite: favorites.isFavorite(listing.id),
                          onFavoriteToggle: () => favorites.toggle(listing.id),
                          onTap: () => context.pushNamed(
                            RouteName.listingDetail,
                            pathParameters: {'id': listing.id},
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SectionHeader(title: 'Newest on Emun'),
                const SizedBox(height: 12),
                ...state.latest.map(
                  (listing) => ListingCard(
                    listing: listing,
                    isFavorite: favorites.isFavorite(listing.id),
                    onFavoriteToggle: () => favorites.toggle(listing.id),
                    onTap: () => context.pushNamed(
                      RouteName.listingDetail,
                      pathParameters: {'id': listing.id},
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeroHeader extends StatefulWidget {
  final VoidCallback onSearchTap;

  const _HeroHeader({required this.onSearchTap});

  @override
  State<_HeroHeader> createState() => _HeroHeaderState();
}

class _HeroHeaderState extends State<_HeroHeader> {
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) {
        setState(() => _animate = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: EmunDesignSystem.animationSlow,
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: EmunDesignSystem.heroGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: AnimatedOpacity(
        duration: EmunDesignSystem.animationSlow,
        opacity: _animate ? 1 : 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Find it. List it. Connect.',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore homes, devices, and vehicles with trusted sellers in one place.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.85),
                  ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: widget.onSearchTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.muted),
                    const SizedBox(width: 8),
                    Text(
                      'Search listings, neighborhoods, or brands',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.muted,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
