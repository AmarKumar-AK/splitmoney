import 'package:flutter/material.dart';

class NavItem {
  final Widget screen;
  final IconData icon;
  final String label;

  const NavItem({
    required this.screen,
    required this.icon,
    required this.label,
  });
}