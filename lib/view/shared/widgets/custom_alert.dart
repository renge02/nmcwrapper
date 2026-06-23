// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nmc_wrapper/repository/registerRepo/service.locator.dart';
import 'package:nmc_wrapper/utils/app_strings.dart';
import 'package:nmc_wrapper/utils/extensions.dart';
import 'package:nmc_wrapper/utils/secure.storage.dart';
import 'package:nmc_wrapper/view/login/login.dart';

void showAlert(
  BuildContext context,
  String message, {
  Function()? callback,
  EdgeInsets? insetPadding,
  bool barrierDismissible = false,
  String? btnText,
}) {
  Future.delayed(Duration.zero, () {
    showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) => PopScope(
        canPop: barrierDismissible,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          if (didPop) return;
        },
        child: AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          insetPadding: insetPadding,
          contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          surfaceTintColor: Colors.white,
          content: Text(
            message,
            style: context.bodyMedium(),
            textAlign: TextAlign.center,
          ).scrollable(),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7A1236), // background
                // foreground
              ),
              onPressed:
                  callback ??
                  () {
                    context.pop();
                  },
              child: Text(
                style: context
                    .bodyMedium()
                    ?.copyWith(
                      color: Theme.of(
                        context,
                      ).appBarTheme.titleTextStyle?.color,
                    )
                    .bold(fontWeight: FontWeight.w600),
                btnText ?? AppStrings.translate(context, 'ok'),
              ),
            ),
          ],
        ),
      ),
    );
  });
}

void showTwoOptionAlert({
  required BuildContext context,
  required String message,
  required String option1Title,
  required String option2Title,
  required Function() option1onClick,
  required Function() option2onClick,
  bool canDismiss = true,
}) {
  Future.delayed(Duration.zero, () {
    showDialog(
      context: context,
      barrierDismissible: canDismiss,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.end,
        contentPadding: EdgeInsets.zero,
        actionsOverflowDirection: VerticalDirection.up,
        actions: [
          OutlinedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(width: 1.0, color: Color(0xFF7A1236)),
            ),
            onPressed: () {
              context.pop();
            },
            child: Text(
              AppStrings.translate(context, 'cancel'),
              style: context
                  .bodyMedium()
                  ?.textColor(Colors.white)
                  .bold(fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            key: const ValueKey('yes'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF7A1236), // background
              // foreground
            ),
            onPressed: option1onClick,
            child: Text(
              option1Title,
              style: context
                  .bodyMedium()
                  ?.textColor(Colors.white)
                  .bold(fontWeight: FontWeight.w600),
            ),
          ).padding(const EdgeInsets.only(right: 4)),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        surfaceTintColor: Colors.white,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Text(message, style: context.bodyMedium()),
              ),
            ],
          ),
        ),
      ),
    );
  });
}

void showLogoutAlert({required BuildContext context}) {
  Future.delayed(Duration.zero, () {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        actionsOverflowDirection: VerticalDirection.up,
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          OutlinedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // background
              side: const BorderSide(width: 1.0, color: Color(0xFF7A1236)),
            ),
            onPressed: () {
              context.pop(rootNavigator: true);
            },
            child: Text(
              AppStrings.translate(context, 'cancel'),
              style: context
                  .bodyMedium()
                  ?.textColor(Colors.black)
                  .bold(fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF7A1236), // background
              // foreground
            ),
            onPressed: () async {
              await getIt<SecureStorage>().deleteAll();
              context.pop(rootNavigator: true);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
            child: Text(
              AppStrings.translate(context, 'logout'),
              style: context
                  .bodyMedium()
                  ?.textColor(Colors.white)
                  .bold(fontWeight: FontWeight.w600),
            ),
          ).padding(const EdgeInsets.only(right: 4)),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        surfaceTintColor: Colors.white,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Text(
                  AppStrings.translate(context, 'logout_confirmation'),
                  style: context.bodyMedium(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  });
}
