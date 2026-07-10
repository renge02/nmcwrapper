import 'dart:ui';

import 'package:flutter/material.dart';

class HelplineModel {
  final String titleKey;
  final String filterKey;
  final IconData icon;
  final Color color;

  HelplineModel({
    required this.titleKey,
    required this.filterKey,
    required this.icon,
    required this.color,
  });
}