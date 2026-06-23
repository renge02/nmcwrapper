import 'package:flutter/material.dart';

Future<DateTime?> pickDate({
  required BuildContext context,
  required DateTime initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  Locale? locale,
}) async {
  final ThemeData theme = Theme.of(context);
  final Brightness brightness = theme.brightness;

  final DateTime? selectedDate = await showDatePicker(
    context: context,
    locale: locale, // <---
    initialDate: initialDate,
    firstDate: firstDate ?? DateTime(1950),
    lastDate: lastDate ?? DateTime.now(),

    builder: (context, child) {
      if (child == null) return const SizedBox();

      return Theme(
        data: theme.copyWith(
          colorScheme: ColorScheme(
            brightness: brightness,
            primary: Color(0xFF7A1236),
            onPrimary: Colors.white,
            secondary: theme.colorScheme.secondary,
            onSecondary: Colors.black,
            error: Colors.red,
            onError: Colors.white,
            surface: brightness == Brightness.light
                ? Colors.white
                : Colors.grey.shade900,
            onSurface:
                brightness == Brightness.light ? Colors.black : Colors.white,
          ),
        ),
        child: child,
      );
    },
  );

  return selectedDate;
}

Future<TimeOfDay?> pickTime(
    {required BuildContext context, required TimeOfDay initialTime}) async {
  TimeOfDay? time = await showTimePicker(
    context: context,
    initialTime: initialTime,
    builder: (context, child) {
      return Theme(
        data: ThemeData(
          useMaterial3: false,
          colorScheme: ColorScheme(
              brightness: Theme.of(context).brightness,
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              secondary: Colors.white,
              onSecondary: Colors.black,
              error: Colors.red,
              onError: Colors.white,
              // background: Theme.of(context).cardColor,
              // onBackground: Colors.white,
              surface: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Theme.of(context).cardColor,
              onSurface: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white),
        ),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        ),
      );
    },
  );
  return time;
}
