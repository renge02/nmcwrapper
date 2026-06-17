import 'package:flutter/material.dart';
import 'package:nmc_wrapper/utils/extensions.dart';
import 'package:nmc_wrapper/utils/logger.dart';

Future<String?> pickGender(BuildContext context) async {
  List<String> gender = ['Male', 'Female', 'Other'];
  String? selected = await showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          clipBehavior: Clip.antiAlias,
          insetPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: getChild(context, gender),
        );
      });
  logger('selected=$selected');
  return selected;
}

Widget getChild(BuildContext context, List<String> gender) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 12, left: 12),
        child: Text("Pick Gender", style: context.bodyMedium()),
      ),
      Divider(
        height: 12,
        thickness: 1,
        color: Colors.grey,
      ),
      Flexible(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: gender.length,
          itemBuilder: (ctx, index) {
            return ListTile(
              dense: true,
              onTap: () {
                ctx.pop(arguments: gender[index]);
              },
              title: Text(gender[index], style: context.bodyMedium()),
            );
          },
        ),
      )
    ],
  );
}
