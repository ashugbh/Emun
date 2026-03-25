import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
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
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Listings',
                      value: profile.listingsCount.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Sold',
                      value: profile.soldCount.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Rating',
                      value: profile.rating.toStringAsFixed(1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => context.pushNamed(RouteName.admin),
                icon: const Icon(Icons.admin_panel_settings_outlined),
                label: const Text('Open Admin Dashboard'),
              ),
              const SizedBox(height: 24),
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

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardTint,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
