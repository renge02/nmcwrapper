import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class ServiceItem {
  final String image;
  final String title;
  final Function(BuildContext) onTap;

  ServiceItem({
    required this.image,
    required this.title,
    required this.onTap,
  });
}