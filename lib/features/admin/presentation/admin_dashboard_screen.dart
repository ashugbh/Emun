import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/core/di/dependancy_manager.dart';
import 'package:emun/core/theme/app_colors.dart';
import 'package:emun/features/admin/application/admin_cubit.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AdminCubit>()..load(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Admin dashboard')),
        body: BlocBuilder<AdminCubit, AdminState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Moderation reports',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                ...state.reports.map(
                  (report) => Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    color: AppColors.surface,
                    child: ListTile(
                      title: Text(report.listingTitle),
                      subtitle: Text(report.reason),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.cardTint,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          report.status,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Categories',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: state.categories
                      .map(
                        (category) => Chip(
                          avatar: Icon(category.icon, size: 18, color: category.color),
                          label: Text(category.name),
                        ),
                      )
                      .toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
