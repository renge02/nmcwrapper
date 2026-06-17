import 'package:flutter/material.dart';
import 'package:nmc_wrapper/utils/extensions.dart';

class VerticleKeyValueText extends StatelessWidget {
  const VerticleKeyValueText(
      {super.key,
      required this.title,
      required this.value,
      this.titleStyle,
      this.maxLineValue,
      this.valueStyle,
        this.decorateContainer,
      this.crossAxisAlignment = CrossAxisAlignment.start,});
  final String title;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final String value;
  final String? decorateContainer ;
  final int? maxLineValue;
  final CrossAxisAlignment crossAxisAlignment;
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 1,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          title,
          style: titleStyle ?? context.bodyMedium(),
        ),
        Container(
          padding: decorateContainer == "YES"
              ? const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 8,
          )
              : const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 0,
          ),
          decoration: decorateContainer == "YES"
              ? BoxDecoration(
            color: const Color(0xFFF3E4DF),
            borderRadius: BorderRadius.circular(20),
          )
              : null,
          child: Text(
            value,
            maxLines: maxLineValue,
            overflow: TextOverflow.ellipsis,
            style: valueStyle ?? context.bodyMedium()?.bold(),
          ),
        )
      ],
    );
  }
}
