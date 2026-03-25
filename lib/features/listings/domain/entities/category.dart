import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<String> subcategories;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.subcategories = const [],
  });

  @override
  List<Object?> get props => [id, name, icon, color, subcategories];
}
