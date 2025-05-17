import 'package:flutter/material.dart';

class UserBadge extends StatelessWidget {
  final String badge;

  const UserBadge({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(badge));
  }
}