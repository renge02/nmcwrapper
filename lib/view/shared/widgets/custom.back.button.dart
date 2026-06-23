import 'package:flutter/material.dart';
import 'package:nmc_wrapper/utils/app_strings.dart';
import 'package:nmc_wrapper/utils/extensions.dart';

Widget customBackButton(
  BuildContext context, {
  bool showText = true,
  VoidCallback? callback,
}) {
  return Row(
    children: [
      IconButton(
        onPressed:
            callback ??
            () {
              context.pop();
            },
        icon: const Icon(Icons.arrow_back),
      ),
      Visibility(
        visible: showText,
        child: Text(
          AppStrings.translate(context, 'back'),
          style: context.bodyMedium(),
        ),
      ),
    ],
  );
}
