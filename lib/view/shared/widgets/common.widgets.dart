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

