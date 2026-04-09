import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:emun/core/presentation/widgets/panel_card.dart';
import 'package:emun/core/router/route_name.dart';
import 'package:emun/core/widgets/empty_state.dart';
import 'package:emun/features/listings/application/bloc/favorites_bloc.dart';
import 'package:emun/features/listings/domain/entities/search_query.dart';
import 'package:emun/features/listings/presentation/widgets/listing_card.dart';
import 'package:emun/features/search/application/bloc/search_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _queryController = TextEditingController();
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();

  @override
  void dispose() {
    _queryController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final favorites = context.watch<FavoritesBloc>();

        if (_queryController.text != state.query) {
          _queryController.text = state.query;
        }

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Search listings',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: context.read<SearchBloc>().saveCurrentSearch,
                    icon: const Icon(Icons.bookmark_border),
                    label: const Text('Save'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: state.savedPresets
                      .map(
                        (preset) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ActionChip(
                            avatar: const Icon(Icons.flash_on, size: 16),
                            label: Text(preset.title),
                            onPressed: () => context.read<SearchBloc>().applyPreset(preset),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 12),
              PanelCard(
                child: Column(
                  children: [
                    TextField(
                      controller: _queryController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search homes, phones, vehicles',
                      ),
                      onChanged: context.read<SearchBloc>().updateQuery,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String?>(
                            initialValue: state.categoryId,
                            decoration: const InputDecoration(labelText: 'Category'),
                            items: [
                              const DropdownMenuItem<String?>(value: null, child: Text('All')),
                              ...state.categories.map(
                                (category) => DropdownMenuItem<String?>(
                                  value: category.id,
                                  child: Text(category.name),
                                ),
                              ),
                            ],
                            onChanged: context.read<SearchBloc>().updateCategory,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String?>(
                            initialValue: state.condition,
                            decoration: const InputDecoration(labelText: 'Condition'),
                            items: const [
                              DropdownMenuItem<String?>(value: null, child: Text('Any')),
                              DropdownMenuItem<String?>(value: 'New', child: Text('New')),
                              DropdownMenuItem<String?>(value: 'Used', child: Text('Used')),
                              DropdownMenuItem<String?>(value: 'Refurbished', child: Text('Refurbished')),
                            ],
                            onChanged: context.read<SearchBloc>().updateCondition,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _minPriceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Min price'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _maxPriceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Max price'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<ListingSort>(
                      initialValue: state.sort,
                      decoration: const InputDecoration(labelText: 'Sort by'),
                      items: const [
                        DropdownMenuItem(value: ListingSort.newest, child: Text('Newest')),
                        DropdownMenuItem(value: ListingSort.priceLowToHigh, child: Text('Price: Low to High')),
                        DropdownMenuItem(value: ListingSort.priceHighToLow, child: Text('Price: High to Low')),
                        DropdownMenuItem(value: ListingSort.relevance, child: Text('Relevance')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          context.read<SearchBloc>().updateSort(value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final minPrice = double.tryParse(_minPriceController.text.trim());
                          final maxPrice = double.tryParse(_maxPriceController.text.trim());
                          context.read<SearchBloc>().updatePriceRange(minPrice, maxPrice);
                          context.read<SearchBloc>().search();
                        },
                        icon: const Icon(Icons.tune),
                        label: const Text('Apply filters'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (state.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (state.results.isEmpty)
                const EmptyState(
                  icon: Icons.search_off_outlined,
                  title: 'No listings yet',
                  subtitle: 'Try adjusting filters or search for another keyword.',
                )
              else
                Column(
                  children: state.results
                      .map(
                        (listing) => ListingCard(
                          listing: listing,
                          isFavorite: favorites.isFavorite(listing.id),
                          onFavoriteToggle: () => favorites.toggle(listing.id),
                          onTap: () => context.pushNamed(
                            RouteName.listingDetail,
                            pathParameters: {'id': listing.id},
                          ),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        );
      },
    );
  }
}
