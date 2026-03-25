import 'package:flutter/material.dart';
import 'package:emun/features/listings/domain/entities/category.dart';
import 'package:emun/core/theme/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? category.color.withOpacity(0.15) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? category.color : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(category.icon, size: 18, color: isSelected ? category.color : AppColors.muted),
            const SizedBox(width: 8),
            Text(
              category.name,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isSelected ? category.color : AppColors.ink,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
