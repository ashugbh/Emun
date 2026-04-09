import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:emun/core/di/dependancy_manager.dart';
import 'package:emun/core/router/route_name.dart';
import 'package:emun/core/theme/app_colors.dart';
import 'package:emun/core/utils/formatters.dart';
import 'package:emun/core/widgets/empty_state.dart';
import 'package:emun/features/listings/application/bloc/favorites_bloc.dart';
import 'package:emun/features/listings/application/bloc/listing_detail_bloc.dart';
import 'package:emun/features/listings/presentation/widgets/listing_card.dart';

class ListingDetailScreen extends StatelessWidget {
  final String listingId;

  const ListingDetailScreen({super.key, required this.listingId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ListingDetailBloc>(param1: listingId)..load(),
      child: const _ListingDetailView(),
    );
  }
}

class _ListingDetailView extends StatefulWidget {
  const _ListingDetailView();

  @override
  State<_ListingDetailView> createState() => _ListingDetailViewState();
}

class _ListingDetailViewState extends State<_ListingDetailView> {
  int _activeImage = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListingDetailBloc, ListingDetailState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final listing = state.listing;
        if (listing == null) {
          return const Scaffold(
            body: EmptyState(
              icon: Icons.search_off_outlined,
              title: 'Listing not found',
              subtitle: 'Try a different listing or refresh the home feed.',
            ),
          );
        }

        final favoritesBloc = context.watch<FavoritesBloc>();
        final isFavorite = favoritesBloc.isFavorite(listing.id);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Listing details'),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.accent : AppColors.ink,
                ),
                onPressed: () => favoritesBloc.toggle(listing.id),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                  aspectRatio: 1.4,
                  child: Stack(
                    children: [
                      PageView.builder(
                        itemCount: listing.imageUrls.length,
                        onPageChanged: (index) {
                          setState(() => _activeImage = index);
                        },
                        itemBuilder: (context, index) {
                          return Image.network(
                            listing.imageUrls[index],
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      Positioned(
                        left: 16,
                        bottom: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            formatPrice(listing.price, currency: listing.currency),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  listing.imageUrls.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 6,
                    width: _activeImage == index ? 20 : 6,
                    decoration: BoxDecoration(
                      color: _activeImage == index ? AppColors.primary : AppColors.border,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                listing.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.place_outlined, size: 18, color: AppColors.muted),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      listing.location,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.muted,
                          ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.cardTint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(listing.condition),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: listing.attributes.entries
                    .map((entry) => Chip(
                          label: Text('${entry.key}: ${entry.value}'),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              Text(
                'About this listing',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                listing.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(listing.seller.avatarUrl),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                listing.seller.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              if (listing.seller.isVerified) ...[
                                const SizedBox(width: 6),
                                const Icon(Icons.verified, size: 18, color: AppColors.primary),
                              ],
                            ],
                          ),
                          Text(
                            'Rating ${listing.seller.rating.toStringAsFixed(1)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.muted),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      formatRelativeTime(listing.postedAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Contact seller',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.pushNamed(
                          RouteName.chat,
                          pathParameters: {'id': 'new-${listing.id}'},
                          extra: listing.title,
                        );
                      },
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text('Chat'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showContactSheet(context, listing.seller.phone, listing.seller.whatsapp);
                      },
                      icon: const Icon(Icons.call_outlined),
                      label: const Text('Contact'),
                    ),
                  ),
                ],
              ),
              if (state.relatedListings.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  'Related listings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 275,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.relatedListings.length,
                    separatorBuilder: (_, index) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final related = state.relatedListings[index];
                      return SizedBox(
                        width: 240,
                        child: ListingCard(
                          listing: related,
                          compact: true,
                          isFavorite: favoritesBloc.isFavorite(related.id),
                          onFavoriteToggle: () => favoritesBloc.toggle(related.id),
                          onTap: () => context.pushReplacementNamed(
                            RouteName.listingDetail,
                            pathParameters: {'id': related.id},
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showContactSheet(BuildContext context, String phone, String whatsapp) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Contact options',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.call_outlined),
                title: const Text('Call seller'),
                subtitle: Text(phone),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.chat_outlined),
                title: const Text('WhatsApp'),
                subtitle: Text(whatsapp),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
