import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/core/di/dependancy_manager.dart';
import 'package:emun/core/presentation/widgets/metric_tile.dart';
import 'package:emun/core/presentation/widgets/panel_card.dart';
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

            final openCount = state.reports.where((report) => report.status == 'Open').length;
            final reviewCount = state.reports.where((report) => report.status == 'Under review').length;
            final resolvedCount = state.reports.where((report) => report.status == 'Resolved').length;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Moderation overview',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                MetricTile(
                  label: 'Open reports',
                  value: '$openCount',
                  icon: Icons.warning_amber_outlined,
                ),
                const SizedBox(height: 8),
                MetricTile(
                  label: 'Under review',
                  value: '$reviewCount',
                  icon: Icons.manage_search_outlined,
                ),
                const SizedBox(height: 8),
                MetricTile(
                  label: 'Resolved',
                  value: '$resolvedCount',
                  icon: Icons.verified_outlined,
                ),
                const SizedBox(height: 18),
                Text(
                  'Moderation reports',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                ...state.reports.map(
                  (report) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: PanelCard(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.report_gmailerrorred_outlined, color: AppColors.accent),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  report.listingTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 2),
                                Text(report.reason),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.cardTint,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(report.status),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Category controls',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
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
