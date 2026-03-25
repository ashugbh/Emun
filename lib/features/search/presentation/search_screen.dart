import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/core/widgets/empty_state.dart';
import 'package:emun/features/listings/application/favorites_cubit.dart';
import 'package:emun/features/listings/domain/entities/search_query.dart';
import 'package:emun/features/listings/presentation/widgets/listing_card.dart';
import 'package:emun/features/search/application/search_cubit.dart';
import 'package:emun/core/router/route_name.dart';
import 'package:go_router/go_router.dart';

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
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final favorites = context.watch<FavoritesCubit>();
        _queryController.value = _queryController.value.copyWith(text: state.query);

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Search listings',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _queryController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search homes, phones, vehicles',
                ),
                onChanged: context.read<SearchCubit>().updateQuery,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String?>(
                      value: state.categoryId,
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
                      onChanged: context.read<SearchCubit>().updateCategory,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String?>(
                      value: state.condition,
                      decoration: const InputDecoration(labelText: 'Condition'),
                      items: const [
                        DropdownMenuItem<String?>(value: null, child: Text('Any')),
                        DropdownMenuItem<String?>(value: 'New', child: Text('New')),
                        DropdownMenuItem<String?>(value: 'Used', child: Text('Used')),
                        DropdownMenuItem<String?>(value: 'Refurbished', child: Text('Refurbished')),
                      ],
                      onChanged: context.read<SearchCubit>().updateCondition,
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
                value: state.sort,
                decoration: const InputDecoration(labelText: 'Sort by'),
                items: const [
                  DropdownMenuItem(value: ListingSort.newest, child: Text('Newest')),
                  DropdownMenuItem(value: ListingSort.priceLowToHigh, child: Text('Price: Low to High')),
                  DropdownMenuItem(value: ListingSort.priceHighToLow, child: Text('Price: High to Low')),
                  DropdownMenuItem(value: ListingSort.relevance, child: Text('Relevance')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    context.read<SearchCubit>().updateSort(value);
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  final minPrice = double.tryParse(_minPriceController.text.trim());
                  final maxPrice = double.tryParse(_maxPriceController.text.trim());
                  context.read<SearchCubit>().updatePriceRange(minPrice, maxPrice);
                  context.read<SearchCubit>().search();
                },
                icon: const Icon(Icons.tune),
                label: const Text('Apply filters'),
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
