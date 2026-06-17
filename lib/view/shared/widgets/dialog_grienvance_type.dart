import 'package:flutter/material.dart';
import 'package:nmc_wrapper/utils/extensions.dart';
import 'package:nmc_wrapper/utils/logger.dart';
import 'package:nmc_wrapper/view/shared/models/grievance.type.dart';


Future<GrievanceType?> pickGrievanceType(
    BuildContext context,
    List<GrievanceType> data,
    ) async {
  GrievanceType? selected = await showDialog<GrievanceType>(
    context: context,
    builder: (_) {
      return Dialog(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: getChild(context, data),
      );
    },
  );

  logger('selected=${selected?.menuPath}');
  return selected;
}



Widget getChild(
    BuildContext context,
    List<GrievanceType> data,
    ) {
  List<GrievanceType> filteredData = List.from(data);

  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 12,
              left: 12,
              right: 12,
            ),
            child: Text(
              'Pick Grievance Type',
              style: context.bodyMedium(),
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Grievance Type',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  filteredData = data.where((item) {
                    return (item.menuPath ?? '')
                        .toLowerCase()
                        .contains(value.toLowerCase());
                  }).toList();
                });
              },
            ),
          ),

          const Divider(),

          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredData.length,
              itemBuilder: (ctx, index) {
                final service = filteredData[index];

                return ListTile(
                  dense: true,
                  onTap: () {
                    Navigator.pop(ctx, service);
                  },
                  title: Text(
                    service.menuPath ?? '',
                    style: context.bodyMedium(),
                  ),
                );
              },
            ),
          ),
        ],
      );
    },
  );
}
