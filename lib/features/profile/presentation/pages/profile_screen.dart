import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:emun/core/application/app/bloc/app_bloc.dart';
import 'package:emun/core/presentation/widgets/metric_tile.dart';
import 'package:emun/core/presentation/widgets/panel_card.dart';
import 'package:emun/core/router/route_name.dart';
import 'package:emun/core/theme/app_colors.dart';
import 'package:emun/features/listings/application/favorites_cubit.dart';
import 'package:emun/features/listings/presentation/widgets/listing_card.dart';
import 'package:emun/features/profile/application/profile_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = state.profile;
        if (profile == null) {
          return const Center(child: Text('Profile unavailable'));
        }

        final favorites = context.watch<FavoritesCubit>();

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              PanelCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundImage: NetworkImage(profile.avatarUrl),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                profile.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              if (profile.isVerified) ...[
                                const SizedBox(width: 6),
                                const Icon(Icons.verified, size: 18, color: AppColors.primary),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile.location,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.muted),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            profile.bio,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              MetricTile(
                label: 'Listings',
                value: profile.listingsCount.toString(),
                icon: Icons.view_list_outlined,
              ),
              const SizedBox(height: 8),
              MetricTile(
                label: 'Sold',
                value: profile.soldCount.toString(),
                icon: Icons.check_circle_outline,
              ),
              const SizedBox(height: 8),
              MetricTile(
                label: 'Rating',
                value: profile.rating.toStringAsFixed(1),
                icon: Icons.star_border,
              ),
              const SizedBox(height: 16),
              PanelCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seller tools',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    const _ProfileActionTile(
                      icon: Icons.shield_outlined,
                      title: 'Trust center',
                      subtitle: 'Identity checks, reporting, and moderation logs',
                    ),
                    const SizedBox(height: 8),
                    const _ProfileActionTile(
                      icon: Icons.notifications_active_outlined,
                      title: 'Listing alerts',
                      subtitle: 'Get notified when buyers contact you',
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => context.pushNamed(RouteName.admin),
                            icon: const Icon(Icons.admin_panel_settings_outlined),
                            label: const Text('Admin'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => context.read<AppBloc>().toggleTheme(),
                            icon: const Icon(Icons.contrast_outlined),
                            label: const Text('Theme'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'My listings',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              if (state.listings.isEmpty)
                const Text('No listings yet. Create one from the Sell tab.')
              else
                ...state.listings.map(
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
        );
      },
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.muted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
