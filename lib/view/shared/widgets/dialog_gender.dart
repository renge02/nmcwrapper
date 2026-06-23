import 'package:flutter/material.dart';
import 'package:nmc_wrapper/utils/app_strings.dart';
import 'package:nmc_wrapper/utils/extensions.dart';
import 'package:nmc_wrapper/utils/logger.dart';

Future<String?> pickGender(BuildContext context) async {

  final List<Map<String, String>> genders = [
    {
      "value": "Male",
      "label": AppStrings.translate(context, 'male'),
    },
    {
      "value": "Female",
      "label": AppStrings.translate(context, 'female'),
    },
    {
      "value": "Other",
      "label": AppStrings.translate(context, 'other'),
    },
  ];
  String? selected = await showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          clipBehavior: Clip.antiAlias,
          insetPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: getChild(context, genders),
        );
      });
  logger('selected=$selected');
  return selected;
}

Widget getChild(BuildContext context,
    List<Map<String, String>> genders,
    ) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 12, left: 12),
        child: Text(
            AppStrings.translate(context, 'pick_gender'),
            style: context.bodyMedium()),
      ),
      Divider(
        height: 12,
        thickness: 1,
        color: Colors.grey,
      ),
      Flexible(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: genders.length,
          itemBuilder: (ctx, index) {
            return ListTile(
              dense: true,
              onTap: () {
                ctx.pop(arguments: genders[index]['value'],
                );
              },
              title: Text(genders[index]['label']!, style: context.bodyMedium()),
            );
          },
        ),
      )
    ],
  );
}
