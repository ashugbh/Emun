import 'package:flutter/material.dart';
import 'package:emun/core/theme/app_colors.dart';

class PanelCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const PanelCard({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}
