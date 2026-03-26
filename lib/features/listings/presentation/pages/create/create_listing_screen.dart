import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/core/di/dependancy_manager.dart';
import 'package:emun/core/theme/app_colors.dart';
import 'package:emun/core/widgets/primary_button.dart';
import 'package:emun/features/listings/application/create_listing_cubit.dart';
import 'package:emun/features/listings/domain/entities/category.dart';
import 'package:emun/features/listings/domain/entities/listing_draft.dart';
import 'package:emun/features/listings/domain/repositories/listings_repository.dart';

class CreateListingScreen extends StatelessWidget {
  const CreateListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CreateListingCubit>(),
      child: const _CreateListingView(),
    );
  }
}

class _CreateListingView extends StatefulWidget {
  const _CreateListingView();

  @override
  State<_CreateListingView> createState() => _CreateListingViewState();
}

class _CreateListingViewState extends State<_CreateListingView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<Category> _categories = [];
  String? _selectedCategory;
  String _condition = 'New';

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final repository = getIt<ListingsRepository>();
    final categories = await repository.fetchCategories();
    setState(() {
      _categories = categories;
      _selectedCategory = categories.isNotEmpty ? categories.first.id : null;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateListingCubit, CreateListingState>(
      listener: (context, state) {
        if (state.status == CreateListingStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Listing created successfully')),
          );
          _formKey.currentState?.reset();
          _titleController.clear();
          _priceController.clear();
          _locationController.clear();
          _descriptionController.clear();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create listing'),
        ),
        body: _categories.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick tips',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Clear titles and detailed descriptions help buyers trust your listing.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(labelText: 'Listing title'),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Price (ETB)'),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a price';
                            }
                            if (double.tryParse(value.trim()) == null) {
                              return 'Enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          key: ValueKey('category-$_selectedCategory'),
                          initialValue: _selectedCategory,
                          decoration: const InputDecoration(labelText: 'Category'),
                          items: _categories
                              .map((category) => DropdownMenuItem(
                                    value: category.id,
                                    child: Text(category.name),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _selectedCategory = value),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          key: ValueKey('condition-$_condition'),
                          initialValue: _condition,
                          decoration: const InputDecoration(labelText: 'Condition'),
                          items: const [
                            DropdownMenuItem(value: 'New', child: Text('New')),
                            DropdownMenuItem(value: 'Used', child: Text('Used')),
                            DropdownMenuItem(value: 'Refurbished', child: Text('Refurbished')),
                          ],
                          onChanged: (value) => setState(() => _condition = value ?? 'New'),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(labelText: 'Location'),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a location';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(labelText: 'Description'),
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<CreateListingCubit, CreateListingState>(
                          builder: (context, state) {
                            return PrimaryButton(
                              label: 'Publish listing',
                              isLoading: state.status == CreateListingStatus.saving,
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                final category = _categories.firstWhere(
                                  (item) => item.id == _selectedCategory,
                                  orElse: () => _categories.first,
                                );
                                context.read<CreateListingCubit>().submit(
                                      ListingDraft(
                                        title: _titleController.text.trim(),
                                        description: _descriptionController.text.trim(),
                                        price: double.parse(_priceController.text.trim()),
                                        location: _locationController.text.trim(),
                                        condition: _condition,
                                        categoryId: category.id,
                                        categoryName: category.name,
                                      ),
                                    );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
