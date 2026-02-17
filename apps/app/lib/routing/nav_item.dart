import 'package:flutter/material.dart';

typedef PageBuilder = Widget Function();

class NavItem {
  final String path;
  final String label;
  final IconData icon;
  final PageBuilder builder;

  const NavItem({
    required this.path,
    required this.label,
    required this.icon,
    required this.builder,
  });
}
