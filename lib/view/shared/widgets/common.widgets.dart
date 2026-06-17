import 'package:flutter/material.dart';
import 'package:nmc_wrapper/l10n/app_localizations.dart';

Widget progressBar() {
  return Center(
    child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2))),
  );
}

Widget pgrTitleWidget(BuildContext context) {
  final localizations = AppLocalizations.of(context)!;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
        Text(
        localizations.applicationFor,
        style: TextStyle(
          fontSize: 12,
          color: Colors.black54,
        ),
      ),
        Text(
        localizations.publicGrievance,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8B1E1E),
        ),
      ),
    ],
  );
}
